# FinFlow AI - Modern Financial Document Manager

FinFlow AI is a high-performance, cross-platform application (Web & Android) designed for smart finance tracking and secure document management. Built with Flutter, it features a premium Material 3 design system, dynamic theming, and a robust S3-backed document infrastructure.

## 🚀 Key Features

### 1. Advanced Document Management
*   **Secure S3 Upload**: Upload PDF documents directly to AWS S3 via a secure v1 API.
*   **Document Vault**: A clean, sortable dashboard to fetch and view your uploaded documents.
*   **Smart Preview**: High-performance in-app PDF previewer (Pinch-to-zoom, search, and smooth scrolling).
*   **File Validation**: Automatic enforcement of a **5MB file size limit** to optimize storage and bandwidth.
*   **Delete with Safety**: One-tap deletion from both S3 and the database with a secure confirmation workflow.

### 2. Premium Design System (Dynamic Theming)
*   **Hybrid Dark Mode**: A sophisticated deep-navy dark theme optimized for reduced eye strain and luxury feel.
*   **Live Color Customization**: Change the entire app's accent color in real-time from the settings.
*   **Typography Engine**: Choose between modern fonts: **Inter**, **Poppins**, or **Roboto**.
*   **Material 3 Harmony**: Full implementation of Google's latest design language with rounded corners (24px cards) and glassmorphism effects.

### 3. Responsive Hybrid Navigation
*   **Adaptive Layout**: Automatically switches between a **centered pill-shaped menu (Web)** and a **native side drawer (Mobile)** based on screen width.
*   **Stretched UI**: Layouts are optimized to use 100% of available screen real estate on mobile while maintaining professional constraints on desktop.

### 4. Global Infrastructure
*   **Localization**: Fully localized architecture using JSON-based translation files (`en.json`). No hardcoded text.
*   **Session Management**: Secure authentication with automated **Token Refresh** logic (Access & Refresh tokens).
*   **Cross-Platform Fixes**: Integrated conditional platform abstractions to solve Web-specific issues like **CORS** using iFrame fallbacks.

---

## 🛠️ Technical Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) (3.x) |
| **State Management** | [Provider](https://pub.dev/packages/provider) |
| **Networking** | [Dio](https://pub.dev/packages/dio) (with Interceptors & Request Queueing) |
| **Storage** | [Shared Preferences](https://pub.dev/packages/shared_preferences) & [Secure Storage](https://pub.dev/packages/flutter_secure_storage) |
| **PDF Engine** | [pdfrx](https://pub.dev/packages/pdfrx) (Native) & [dart:ui_web](https://api.flutter.dev/flutter/dart-ui_web/dart-ui_web-library.html) (Web iFrame) |
| **Navigation** | Flutter Material 3 Navigation Rails & Drawers |
| **Tools** | [file_picker](https://pub.dev/packages/file_picker), [url_launcher](https://pub.dev/packages/url_launcher), [permission_handler](https://pub.dev/packages/permission_handler) |

---

## 📂 Project Structure

*   `lib/core/theme`: Dynamic Theme Provider and Material 3 configurations.
*   `lib/core/services`: Dio-based API service with auth-handshaking.
*   `lib/core/localization`: JSON translation engine.
*   `lib/views`: Fully responsive screens (Home, Profile, Settings, Auth).
*   `lib/models`: Null-safe data models for Documents and Pagination.
*   `assets/lang`: Centralized language management.

---

## 🏁 Getting Started

1.  **Clone the project**
2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the App**:
    *   **Android**: `flutter run -d <device_id>`
    *   **Web**: `flutter run -d chrome`

---

## 📦 Download & Demo

### 📱 Android
You can download the latest production APK here:
[**Download finflow-ai.apk**](release_builds/finflow-ai.apk)

### 🌐 Web Version
The web version is optimized for desktop and mobile browsers. You can access the local build here:
[**Open Web App**](release_builds/web_app/index.html)

---
*FinFlow AI - Empowering your financial journey with beautiful, secure, and responsive technology.*
