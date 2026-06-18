import express from "express";
import { authMiddleware } from "../../../middlewares/authMiddleware.js";
import {
  getProfile,
  loginUser,
  registerUser,
} from "../controllers/authController.js";

const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
router.get("/profile", authMiddleware, getProfile);

export default router;
