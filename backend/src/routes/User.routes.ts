import { Application } from "express";
import { AuthentificationController, UserController } from "../controllers";
import { UserService } from "../services";


export class UserRoutes {

    private app: Application;

    constructor (app: Application) {
        this.app = app;
    }

    public configureRoutes() {
        const authentificationController = AuthentificationController.getInstance();
        const services = new UserService();
        const userController = new UserController();

        this.app.use(authentificationController.authentificateToken);
        this.app.route(`/users`)
            .post(userController.signUp);

        return this.app;
    }
}