import { Document } from 'mongoose';

import { IBodyDocument } from '../interfaces';

export class BodyDocument<Type extends Document> implements IBodyDocument<Type> {
    message!: Type | Type[] | string;
    error: boolean;

    constructor(message: Type[] | Type | string, error: boolean = false) {
        this.message = message;
        this.error = error;
    }
}
