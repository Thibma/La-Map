import { IUser, IData } from "../interfaces";
import { BodyDocument, IUserDocument, UserModel } from "../models";
import { Model, Types } from "mongoose";

export class UserService {

    constructor() {
        this.createUser = this.createUser.bind(this);
    }

    public getModel(): Model<IUserDocument> { return UserModel; }

    // Création d'un user
    public async createUser(user: IUser): Promise<BodyDocument<IUserDocument>> {
        console.log(`${new Date()} :: UserService.insert, object = `, user);

        let result : BodyDocument<IUserDocument>;
        try {
            let object = await UserModel.create(user);
            if (!object) {
                throw new Error('ERROR : Could not create user');
            }
            result = new BodyDocument(object);
        }
        catch (error) {
            result = new BodyDocument<IUserDocument>((error as Error).message, true);
            console.error((error as Error).message);
        }
        return result;
    }

    // Connexion firebase d'un user
    public async firebaseSignIn(idFirebase: string): Promise<BodyDocument<IUserDocument>> {
        console.log(`${new Date()} :: UserService.firebaseSignin, object = `, idFirebase);

        let result;
        try {
            let user = await this.getModel().findOne({ 'idFirebase': idFirebase }) as IUserDocument;
            if (!user) {
                throw new Error('User not found : Signup');
            }

            result = new BodyDocument<IUserDocument>(user);
        }

        catch(error) {
            console.error((error as Error).message);
            result = new BodyDocument<IUserDocument>((error as Error).message, true);
        }

        return result;
    }

    // Connexion d'un user
    public async signIn(idUser: string): Promise<BodyDocument<IUserDocument>> {
        console.log(`${new Date()} :: UserService.signin, object = `, idUser);

        let result;
        try {
            const searchUser = await this.getById(idUser)
            if (searchUser.error) {
                throw new Error(searchUser.message as string);
            }

            const user = searchUser.message as IUserDocument;

            const now = new Date();
            const lastConnexion = user.lastConnexion || new Date(now.getFullYear(), now.getMonth(), now.getDate());
            const newConnexion = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            user.lastConnexion = newConnexion;
            result = await this.update(user._id, user) as BodyDocument<IUserDocument>
        }
        catch (error) {
            console.error((error as Error).message);
            result = new BodyDocument<IUserDocument>((error as Error).message, true);
        }

        return result;
    }

    // Avoir un user
    private async getById(id: string): Promise<BodyDocument<IUserDocument>> {

        let result;
        try {
            if (!Types.ObjectId.isValid(id)) {
                throw new Error('BAD REQUEST : id invalid');
            }

            let user = await this.getModel().findById(id) as IUserDocument;
            if (!user) {
                throw new Error('BAD REQUEST : User not found');
            }

            result = new BodyDocument<IUserDocument>(user);
        }
        catch(error) {
            result = new BodyDocument<IUserDocument>((error as Error).message, true);
            console.error((error as Error).message);
        }

        return result;
    }

    // Update d'un user
    private async update(id: string, data: IData): Promise<BodyDocument<IUserDocument>> {

        let result;
        try {
            let user = await this.getModel().findByIdAndUpdate(id, data as any, { useFindAndModify: false, new: true }) as IUserDocument;
            if (!user) {
                throw new Error('BAD REQUEST : User not found');
            }

            result = new BodyDocument<IUserDocument>(user);
        }
        catch(error) {
            result = new BodyDocument<IUserDocument>((error as Error).message, true);
        }

        return result;

    }
    
}