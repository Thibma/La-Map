import dotenv from 'dotenv';
import { NextFunction, Request, Response } from 'express'
import { BodyDocument } from '../models';

dotenv.config();

export class AuthentificationController {
    private token: String;
    private static instance: AuthentificationController;

    constructor() {
        this.token = process.env.API_TOKEN as String;
        this.authentificateToken = this.authentificateToken.bind(this);
    }

    public static getInstance(): AuthentificationController {
        if (!AuthentificationController.instance) {
            AuthentificationController.instance = new AuthentificationController();
        }

        return AuthentificationController.instance;
    }

    public authentificateToken(request: Request, response: Response, next: NextFunction) {
        console.log(`${new Date()} :: AuthentificationController.authentificateToken()`);
        const token = request.headers['api-token'];

        if (token != this.token) {
            const body = new BodyDocument(`Error: 'api-token' is not valid`, true);
            response.status(401).send(body);
            return;
        }
        next();
    }
}