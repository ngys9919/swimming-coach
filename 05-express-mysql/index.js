const express = require('express');
const app = express();
const hbs = require('hbs');
const wax = require('wax-on');
wax.on(hbs.handlebars); // apply wax to handlebars
wax.setLayoutPath("./views/layouts");

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
    })
}

main();



app.listen(3000, function () {
    console.log("Server has started");
})
