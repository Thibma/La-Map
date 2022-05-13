import express, { Application} from "express";
import "dotenv/config";
import bodyparser from "body-parser";
import { UserRoutes } from "./routes";
import { Server } from "http";
import mongoose from "mongoose";

class App {
    public app: Application = express.application;
    public server: Server = new Server();
    public PORT = process.env.PORT;
    public mongoUrl = process.env.MONGO_URL!;

    constructor() {
        this.mongoSetup();

        this.app = express();
        this.config();
        this.configRoutes();

        this.server = this.app.listen(this.PORT, () => {
            return console.log('server is running on ' + this.PORT);
        });

    }

    private config() {
        this.app.use(bodyparser.json());
        this.app.use(bodyparser.urlencoded({ extended: true }));
    }

    private mongoSetup() {
        mongoose.connect(this.mongoUrl);
    }

    private configRoutes() {
        new UserRoutes(this.app).configureRoutes();
    }
}

export default new App().app;