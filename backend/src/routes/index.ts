import { RoutesInput } from "../types/types"
import UserController from "../controllers/User.controller"

export default ({ app }: RoutesInput) => {
    app.post("/api/user", async (req, res) => {
        const user = await UserController.CreateUser({
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            email: req.body.email,
        })

        return res.send({ user })
    })
}