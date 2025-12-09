//IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");


//IMPORTS FROM OTHER FILES
const authRouter = require('./routes/auth');



//INIT
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://pujan:grabbit%23333@cluster0.jaokfcd.mongodb.net/?appName=Cluster0"

//middleware
app.use(authRouter);

//Connections
mongoose.connect(DB).then(()=>{
    console.log("Connection successful")
}).catch((e)=>{
    console.log(e);
})


app.listen(PORT, "0.0.0.0", ()=>{
    console.log(`Connected at port ${PORT} hello`);
});

