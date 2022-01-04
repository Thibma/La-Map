import express, { Application, Request, Response, NextFunction } from "express"
import "dotenv/config"
import bodyparser from "body-parser"
import Routes from "./routes"
import Connect from "./connect"

const app: Application = express()

app.use(bodyparser.json())
app.use(bodyparser.urlencoded({ extended: true }))

app.get("/", (req: Request, res: Response) => {
    res.send("Hello World !")
})

const PORT = process.env.PORT
const db = "mongodb://mongo:27017/db"

Connect({ db })
Routes({ app })

app.listen(PORT, () => {
    console.log(`Server is running on the port : ${PORT}`)
})