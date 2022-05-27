import { Application } from "express";
import { AuthentificationController, UserController } from "../controllers";

export class UserRoutes {

    private app: Application;

    constructor(app: Application) {
        this.app = app;
    }

    public configureRoutes() {
        const authentificationController = AuthentificationController.getInstance();
        const userController = new UserController();

        this.app.use(authentificationController.authentificateToken);
        this.app.route(`/users`)
            .post(userController.signUp);

        this.app.use(`/users/signin/:idFirebase`, userController.signIn);

        return this.app;
    }
}