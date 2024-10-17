const express = require('express');
const app = express();
const hbs = require('hbs');
const wax = require('wax-on');
wax.on(hbs.handlebars); // apply wax to handlebars
wax.setLayoutPath("./views/layouts");

require('dotenv').config();

// use destructuring syntax to only require in the createConnection function
const {createConnection} = require('mysql2/promise');

// Inform express that we are using HBS as view engine
// (aka template engine)
app.set("view engine", "hbs");

async function main() {

    const connection = await createConnection({
        'host': process.env.DB_HOST, // or 127.0.0.1
        'user': process.env.DB_USER,
        'database':process.env.DB_DATABASE, // name of the database to use
        'password': process.env.DB_PASSWORD
    });

    // ROUTES (example)
    app.get('/', function(req,res){
        res.send('Hello World!');
    });

    app.get('/test', async function(req, res){
        // [companies] -> array destructuring
        let [companies] = await connection.execute(`SELECT * FROM Companies`);
        // await connection.execute() returns an array
        // element 0 - is the result
        // element 1 - some metadata
        // let response = await connection.execute("SELECT * FROM Companies");
        // let companies = response[0];
        res.send(companies);
    })

    app.get("/customers", async function(req,res){
        // retrieve the customers from the database
        const [customers] = await connection.execute(`SELECT * FROM Customers`);
   
        res.render('customers', {
            'customerList': customers
        })
    })
}

main();



app.listen(3000, function(){
    console.log("Server has started");
})
