import { IData, Id } from "./";
import { Visibility } from "../enums";
import { Localisation } from "../types";

export interface IPlace extends IData {
    id?: Id,
    name: String,
    withWho?: String[],
    photo?: String,
    coordinates: Localisation,
    date: Date,
    visibility: Visibility,
    note?: String;
}