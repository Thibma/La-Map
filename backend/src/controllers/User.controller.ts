import { Request, Response } from "express"; 
import { IData, IUser } from "../interfaces";
import { UserService } from "../services";

export class UserController {
    public service: UserService;
    
    constructor() {
        this.signUp = this.signUp.bind(this);
        this.signIn = this.signIn.bind(this);
        this.service = new UserService();
    }

    // Inscription
    public async signUp(request: Request, response: Response) {
        const body = request.body as IUser;
        console.log(body);

        const created = await this.service.createUser(body);
        const status = created.error ? 400 : 202;
        response.status(status).send(created);
    }

    public async signIn(request: Request, response: Response) {
        const { idFirebase } = request.params;

        const updated = await this.service.firebaseSignIn(idFirebase);
        if (updated.message == 'User not found : Signup') {
            response.status(404).send(updated);
            return;
        }
        const status = updated.error ? 400 : 202;
        response.status(status).send(updated);
    }

}