const express = require('express');
const app = express();
const hbs = require('hbs');
const wax = require('wax-on');
wax.on(hbs.handlebars); // apply wax to handlebars
wax.setLayoutPath("./views/layouts");

// require in handlebars and their helpers
const helpers = require('handlebars-helpers');
// tell handlebars-helpers where to find handlebars
helpers({
    'handlebars': hbs.handlebars
})

require('dotenv').config();

// use destructuring syntax to only require in the createConnection function
const { createConnection } = require('mysql2/promise');

// Inform express that we are using HBS as view engine
// (aka template engine)
app.set("view engine", "hbs");

// enable form (i.e forms submitted by the browser) processing in Express
app.use(express.urlencoded());

async function main() {

    const connection = await createConnection({
        'host': process.env.DB_HOST, // or 127.0.0.1
        'user': process.env.DB_USER,
        'database': process.env.DB_DATABASE, // name of the database to use
        'password': process.env.DB_PASSWORD
    });

    app.get('/test', async function (req, res) {
        let [companies] = await connection.execute(`SELECT * FROM Companies`);
        // await connection.execute() returns an array
        // element 0 - is the result
        // element 1 - some metadata
        // let response = await connection.execute("SELECT * FROM Companies");
        // let companies = response[0];
        res.send(companies);
    })

    app.get("/customers", async function (req, res) {
        // retrieve the customers from the database
        const [customers] = await connection.execute(`SELECT * FROM Customers 
                JOIN Companies ON Customers.company_id = Companies.company_id
                ORDER BY first_name ASC
                
                `);

        res.render('customers', {
            'customerList': customers
        })
    })

    app.get('/customers/create', async function (req, res) {
        const [companies] = await connection.execute(`SELECT * FROM Companies`);
        res.render('customers/create', {
            "companies": companies
        })
    });

    app.post('/customers/create', async function (req, res) {
        // req.body will contain what the user has submitted through the form
        // we are using PREPARED STATEMENTS (to counter SQL injection attacks)
        const sql = `
            INSERT INTO Customers (first_name, last_name, rating, company_id)
            VALUES (?, ?, ?, ?);`

        const bindings = [
            req.body.first_name,
            req.body.last_name,
            req.body.rating,
            req.body.company_id

        ]

        // first parameter = the SQL statemnet to execute
        // second parameter = bindings, or the parameter for the question marks, in order
        await connection.execute(sql, bindings);

        // redirect tells the client (often time the broswer) to go a different URL
        res.redirect('/customers');
    });

    app.get('/customers/:customer_id/edit', async function (req, res) {
        // fetch the customer we are editing
        const customerId = req.params.customer_id;
        // in prepared statements, we give the instructions to MySQL in 2 pass
        // 1. the prepared statement - so SQL knows what we are executing and won't execute anything else
        // 2. send what is the data for each ?
        // Do you ESCAPE your MySQL statements
        const [customers] = await connection.execute(`SELECT * FROM Customers WHERE customer_id = ?`, [customerId]);

        // MySQL2 will always return an array of results even if there is only one result
        const customer = customers[0]; // retrieve the customer that we want to edit which will be at index 0

        // get all the customers to populate the drop down form
        const [companies] = await connection.execute(`SELECT * FROM Companies`);

        // send the customer to the hbs file so the user can see details prefilled in the form
        res.render('customers/edit', {
            customer, // => same as 'customer': customer
            companies // => same as 'companies' : companies
        })
    })

    app.post('/customers/:customer_id/edit', async function (req, res) {
        try {
            const { company_id, first_name, last_name, rating } = req.body;

            if (!first_name || !last_name || !company_id || !rating) {
                throw new Exception("Invalid values");
            }

            const sql = `UPDATE Customers SET first_name=?, last_name=?, rating=?, company_id=?
                            WHERE customer_id = ?;`

            const bindings = [first_name, last_name, rating, company_id, req.params.customer_id];

            await connection.execute(sql, bindings);

            res.redirect("/customers");
        } catch (e) {
            res.status(400).send("Error " + e);
        }
    })

    app.get('/customers/:customer_id/delete', async function(req,res){
        // display a confirmation form 
        const [customers] = await connection.execute(
            "SELECT * FROM Customers WHERE customer_id =?", [req.params.customer_id]
        );
        const customer = customers[0];

        res.render('customers/delete', {
            customer
        })

    })

    app.post('/customers/:customer_id/delete', async function(req, res){
        await connection.execute(`DELETE FROM Customers WHERE customer_id = ?`, [req.params.customer_id]);
        res.redirect('/customers');
    })
}

main();



app.listen(3000, function () {
    console.log("Server has started");
})
