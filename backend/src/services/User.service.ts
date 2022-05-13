import { IUser } from "../interfaces";
import { BodyDocument, IUserDocument, UserModel } from "../models";
import { Model } from "mongoose";

export class UserService {

    constructor() {

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
    
}