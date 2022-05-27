import { IUserDocument } from '../models';
import { Id, IData } from './';


export interface IUser extends IData {
    id?: Id;
    pseudo: String;
    idFirebase: String,
    idImage: String,
    friends: String[] | IUserDocument[],
    lastConnexion?: Date;
}