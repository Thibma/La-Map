import mongoose, { Schema, Document, Types, model } from "mongoose";
import { Visibility } from "../enums";
import { IPlace } from '../interfaces';

export type IPlaceDocument = IPlace & Document;

export const PlaceSchema = new Schema({

    name: {
        type: String,
        required: true
    },
    userId: {
        type: String,
        required: true
    },
    withWho: {
        type: String,
        required: false,
    },
    photo: {
        type: String,
        required: false
    },
    coordinates: {
        longitude: {
            type: Number,
            required: true
        },
        latitude: {
            type: Number,
            required: true
        }
    },
    date: {
        type: Date,
        require: true
    },
    visibility: {
        type: String,
        enum: Object.values(Visibility),
        require: true
    },
    note: {
        type: String,
        required: false
    }
}, {
    versionKey: false,
    timestamps: true
});

export const PlaceModel = model<IPlaceDocument>('Place', PlaceSchema);