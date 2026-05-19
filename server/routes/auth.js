const express = require("express");
const User = require("../models/user");
const ShopProfile = require("../models/shop_profile");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { JWT_SECRET } = require("../middleware/auth");

const authRouter = express.Router();

function createToken(user) {
    return jwt.sign(
        {
            userId: user._id.toString(),
            role: user.type,
        },
        JWT_SECRET,
        { expiresIn: "30d" },
    );
}

function toClientUser(user) {
    return {
        _id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone || "",
        type: user.type,
    };
}

//Sign up

authRouter.post('/api/signup', async (req, res)=>{
    

    try{
        const {name, email, password, type = 'customer'} = req.body;

        if(!['customer', 'shop'].includes(type)){
            return res.status(400).json({msg: "Invalid account type."});
        }

         const existingUser = await User.findOne({email});

    if(existingUser){
        return res.status(400).json({msg: "User with same email already exists!"});
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
        email,
        password: hashedPassword,
        name,
        type,
    })
    user = await user.save();

    if(type === "shop"){
        await ShopProfile.findOneAndUpdate(
            { userId: user._id },
            {
                userId: user._id,
                businessName: name,
                initials: name
                    .split(" ")
                    .filter(Boolean)
                    .slice(0, 2)
                    .map((part) => part[0].toUpperCase())
                    .join("") || "SH",
                categories: [],
            },
            { upsert: true, new: true },
        );
    }

    res.json({user: toClientUser(user), token: createToken(user)});

    } catch(e){
        res.status(500).json({err: e.message})
    }

   
})

authRouter.post('/api/login', async (req, res)=>{
    try{
        const {email, password} = req.body;

        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({msg: "Invalid email or password."});
        }

        const isMatch = await bcryptjs.compare(password, user.password);
        if(!isMatch){
            return res.status(400).json({msg: "Invalid email or password."});
        }

        res.json({user: toClientUser(user), token: createToken(user)});
    } catch(e){
        res.status(500).json({err: e.message})
    }
})

module.exports = authRouter;
