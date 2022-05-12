import { RoutesInput } from "../types/Localisation.type"
import UserController from "../controllers/User.controller"
import express, { Request, Response } from 'express'

export class Routes {
    private app: express.Application;

    constructor(app: express.Application) {
        this.app = app;
    }

    public routes() {
        this.app.route('/').get((req: Request, res: Response) => {
            res.send("Hello World !");
        });
    }
}