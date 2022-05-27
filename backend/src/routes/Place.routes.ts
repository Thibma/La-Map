import { Application } from "express";
import { PlaceController } from "../controllers";

export class PlaceRoutes {

    private app: Application;

    constructor(app: Application) {
        this.app = app;
    }

    public configureRoutes() {
        const placeController = new PlaceController();

        this.app.route(`/places`)
            .post(placeController.createPlace);

        this.app.use(`/places/:idUser`, placeController.getAllPlacesByUser);

        return this.app;
    }

}