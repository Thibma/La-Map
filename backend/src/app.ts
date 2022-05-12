import express, { Application} from "express";
import "dotenv/config";
import bodyparser from "body-parser";
import { Routes } from "./routes";
import { Server } from "http";
import mongoose from "mongoose";

class App {
    public app: Application = express.application;
    public server: Server = new Server();
    public PORT = process.env.PORT;
    public mongoUrl = process.env.MONGO_URL!;
    public routes: Routes;

    constructor() {
        this.mongoSetup();

        this.app = express();
        this.config();

        this.server = this.app.listen(this.PORT, () => {
            return console.log('server is running on ' + this.PORT);
        });

        this.routes = new Routes(this.app);
        this.routes.routes();
    }

    private config() {
        this.app.use(bodyparser.json());
        this.app.use(bodyparser.urlencoded({ extended: true }));
    }

    private mongoSetup() {
        mongoose.connect(this.mongoUrl);
    }
}

export default new App().app;