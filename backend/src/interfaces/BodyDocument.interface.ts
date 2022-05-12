import { Document } from "mongoose";

export interface IBodyDocument<Type extends Document> {
    message: Type | Type[] | string,
    error: boolean
}