const express = require('express');
const app = express();
const hbs = require('hbs');
const wax = require('wax-on'); // wax-on -> template inheritance
wax.on(hbs.handlebars); // apply wax to handlebars
wax.setLayoutPath("./views/layouts");

// Inform express that we are using HBS as view engine
// (aka template engine)
app.set("view engine", "hbs");

// ROUTES (example)
// app.get('/', function(req,res){
//     res.render('hello');
// });

app.get("/", function(req,res){
    res.render('home')
})

app.get("/contact-us", function(req,res){
    res.render('contact');
})

app.listen(3000, function(){
    console.log("Server has started");
})
