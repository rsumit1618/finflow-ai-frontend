# Migration Plan: Blank Screen → Admin Dashboard

## Information Gathered
- Project uses **Clean Architecture + Feature-First** structure
- `blank_screen.dart` at `lib/features/blank/presentation/screens/blank_screen.dart` contains the Admin Portal UI
- `creator_studio_widgets.dart` has all widgets (sidebar, stat cards, upload section, video cards, access note)
- `video/` feature already has **full data layer**: remote datasource, repository, models, use cases, notifier, state
- `video_list_screen.dart` is current dashboard after login (YouTube-style, dark theme)
- `main.dart` routes authenticated users to `VideoListScreen`
- `login_screen.dart` has "Go to Blank Page" TextButton to `/blank`
- API base URL: `http://56.228.4.142:3000/api/v1`
- API endpoints for upload/video exist and are working

## Plan

### Step 1: Rename and Restructure
- Rename `blank/` feature folder to `dashboard/`
- Rename `blank_screen.dart` → `dashboard_screen.dart`
- Rename class `BlankScreen` → `DashboardScreen`
- Move/rename route from `/blank` → `/dashboard`
- Update `login_screen.dart` → remove "Go to Blank Page" button
- Update `main.dart` → route authenticated users to `DashboardScreen`

### Step 2: Integrate Real Video Data (API)
- Remove dummy video data in `creator_studio_widgets.dart`
- Inject `VideoNotifier` into `DashboardScreen` to use real videos from API
- The `UploadSection` widget should use the `VideoNotifier.uploadVideos()` method
- Video cards should use real `VideoEntity` data
- Add delete functionality via `VideoNotifier.deleteVideo()`
- Add video playback via `url_launcher` (same as `video_list_screen.dart`)

### Step 3: UI Component Splitting (Reusable)
- `DashboardScreen` → Presenter/Stateful shell with responsive layout
- Split into reusable components following the architecture:
  - `dashboard_sidebar.dart` (from `CreatorStudioSidebar`)
  - `stats_grid.dart` (from stat cards)
  - `dashboard_upload_section.dart` (upload with real API binding)
  - `dashboard_video_grid.dart` (grid with real video data)
  - `video_card_dashboard.dart` (dashboard-styled video card)
  - `access_note.dart`
- Follow `presentation/widgets/` pattern per architecture

### Step 4: Login Screen Update
- Remove the "Go to Blank Page" `TextButton`
- After login → navigate to `/dashboard` (AppRoutes.dashboard)

### Step 5: Clean Up
- Delete old `blank/` feature folder
- Delete `video_card.dart`, `youtube_video_card.dart` (old styling)

## Files to Create/Modify

### Create:
- `lib/features/dashboard/presentation/screens/dashboard_screen.dart`
- `lib/features/dashboard/presentation/widgets/dashboard_sidebar.dart`
- `lib/features/dashboard/presentation/widgets/stats_grid.dart`
- `lib/features/dashboard/presentation/widgets/dashboard_upload_section.dart`
- `lib/features/dashboard/presentation/widgets/dashboard_video_grid.dart`
- `lib/features/dashboard/presentation/widgets/video_card_dashboard.dart`
- `lib/features/dashboard/presentation/widgets/access_note.dart`

### Modify:
- `lib/core/common/utils/routing/app_router.dart` → add dashboard route, remove blank
- `lib/features/auth/presentation/screens/login_screen.dart` → remove blank button
- `lib/main.dart` → route to dashboard on auth

### Delete:
- `lib/features/blank/` (entire folder)
- Old `video_card.dart`, `youtube_video_card.dart`

## Follow-up:
- Run `flutter analyze` to verify no errors
- Test navigation flow: Login → Dashboard
- Test video listing, upload, and delete via API

