import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { successResponse } from "../../../utils/apiResponse.js";
import { env } from "../../../config/env.js";
import { registerSchema, loginSchema } from "../validators/authValidator.js";
import {
  getProfileService,
  loginUserService,
  registerUserService,
} from "../services/authService.js";

export const registerUser = async (req, res, next) => {
  try {
    const validatedData = registerSchema.parse(req.body);

    const result = await registerUserService(validatedData);

    return successResponse(res, "User registered successfully", result, 201);
  } catch (error) {
    next(error);
  }
};

export const loginUser = async (req, res, next) => {
  try {
    const validatedData = loginSchema.parse(req.body);

    const result = await loginUserService(validatedData);

    return successResponse(res, "Login successful", result);
  } catch (error) {
    next(error);
  }
};

export const getProfile = async (req, res, next) => {
  try {
    const user = await getProfileService(req.user.userId);

    return successResponse(res, "Profile fetched successfully", {
      user,
    });
  } catch (error) {
    next(error);
  }
};
