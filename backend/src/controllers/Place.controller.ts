import { Request, Response } from "express";
import { IPlace } from "../interfaces";
import { PlaceService } from "../services/Place.service";

export class PlaceController {
    public service: PlaceService;

    constructor() {
        this.createPlace = this.createPlace.bind(this);
        this.getAllPlacesByUser = this.getAllPlacesByUser.bind(this);
        this.service = new PlaceService();
    }

    public async createPlace(request: Request, response: Response) {
        const body = request.body as IPlace;

        const created = await this.service.createPlace(body);
        const status = created.error ? 400 : 202;
        response.status(status).send(created);
    }

    public async getAllPlacesByUser(request: Request, response: Response) {
        const { idUser } = request.params;

        const search = await this.service.getAllPlacesByUser(idUser);
        const status = search.error ? 400 : 202;
        response.status(status).send(search);
    }
}