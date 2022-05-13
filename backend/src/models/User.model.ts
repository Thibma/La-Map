import mongoose, { Schema, Document, Types, model } from "mongoose";
import { IUser } from '../interfaces';

export type IUserDocument = IUser & Document;

export const UserSchema = new Schema({
    pseudo: {
        type: String,
        required: true,
        unique: true
    },
    idFirebase: {
        type: String,
        required: true
    },
    idImage: {
        type: String,
        required: true
    },
    friends: [
        {
            type: Types.ObjectId,
            required: true,
            ref: 'User',
            default: []
        }
    ],
    places: [
        {
            type: Types.ObjectId,
            required: true,
            ref: 'Place',
            default: []
        }
    ],
    lastConnexion: {
        type: Date,
        required: true,
        default: new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate() - 1),  
    },
},
{
    versionKey: false,
    timestamps: true
});

export const UserModel = model<IUserDocument>('User', UserSchema);