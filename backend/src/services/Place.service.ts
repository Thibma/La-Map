import { Model, Types } from "mongoose";
import { IPlace } from "../interfaces";
import { BodyDocument, IPlaceDocument, PlaceModel } from "../models";

export class PlaceService {

    constructor() {

    }

    public getModel(): Model<IPlaceDocument> { return PlaceModel; }

    public async createPlace(place: IPlace): Promise<BodyDocument<IPlaceDocument>> {
        console.log(`${new Date()} :: PlaceService.insert, object = `, place);

        let result: BodyDocument<IPlaceDocument>;
        try {
            let object = await PlaceModel.create(place);
            if (!object) {
                throw new Error('ERROR : Could not create place');
            }
            result = new BodyDocument(object);
        }
        catch (error) {
            result = new BodyDocument<IPlaceDocument>((error as Error).message, true);
            console.error((error as Error).message);
        }
        return result;
    }

    public async getAllPlacesByUser(idUser: string): Promise<BodyDocument<IPlaceDocument>> {
        console.log(`${new Date()} :: PlaceService.getAllPlacesByUser, idUser = ${idUser}`);

        let result;
        try {
            if (!Types.ObjectId.isValid(idUser)) {
                throw new Error('BAD REQUEST: Id not valid');
            }

            let places = await this.getModel().find(( {'userId': idUser} )) as IPlaceDocument[];
            if (!places) { 
                throw new Error('BAD REQUEST: places ids');
            }

            result = new BodyDocument<IPlaceDocument>(places);
        }
        catch (error) {
            result = new BodyDocument<IPlaceDocument>((error as Error).message, true);
            console.error((error as Error).message);
        }

        return result;
    }

}