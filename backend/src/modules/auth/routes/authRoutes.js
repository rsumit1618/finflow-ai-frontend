import express from "express";
import { authMiddleware } from "../../../middlewares/authMiddleware.js";
import {
  changePassword,
  getProfile,
  loginUser,
  logoutUser,
  registerUser,
  updateProfile,
} from "../controllers/authController.js";

const router = express.Router();

router.post("/register", registerUser);
router.post("/login", loginUser);
router.post("/change-password", authMiddleware, changePassword);
router.post("/logout", authMiddleware, logoutUser);

router.get("/profile", authMiddleware, getProfile);
router.put("/profile", authMiddleware, updateProfile);


export default router;
