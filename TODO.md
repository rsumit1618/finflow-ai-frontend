# FinFlow AI Refactoring TODO

## Phase 1: Fix Imports & Compilation ✅
- [x] Create TODO.md
- [x] Fix imports in `api_constants.dart` (unify with app_constants)
- [x] Fix imports in `app_router.dart`
- [x] Fix imports in `auth_interceptor.dart`
- [x] Fix imports in `auth_providers.dart`
- [x] Fix imports in `auth_notifier.dart`
- [x] Fix imports in `video_notifier.dart`
- [x] Fix imports in `video_providers.dart`
- [x] Fix imports in `login_screen.dart`
- [x] Fix imports in `register_screen.dart`
- [x] Fix imports in `video_list_screen.dart`
- [x] Fix imports in `video_card.dart`
- [x] Fix imports in `api_service.dart` (deprecated + imports)
- [x] Fix imports in `injection_container.dart`
- [x] Fix imports in `auth_remote_datasource.dart`
- [x] Fix imports in `video_remote_datasource.dart`
- [x] Fix imports in `auth_repository_impl.dart`
- [x] Fix imports in `video_repository_impl.dart`
- [x] Fix imports in `auth_state.dart`, `video_state.dart`
- [x] Fix imports in `usecase.dart`
- [x] Fix imports in `api_client.dart`
- [x] Fix imports in `auth_local_datasource.dart`
- [x] Fix imports in `user_model.dart`, `video_model.dart`
- [x] Fix imports in `video_repository.dart` (domain)
- [x] Fix `VideoLoading` state bug in video_list_screen.dart

## Phase 2: Unify & Clean Architecture ✅
- [x] Merge API constants into single source of truth (api_constants.dart)
- [x] Mark api_service.dart as @Deprecated
- [x] Added documentation comments to key classes

## Phase 3: Run & Test ✅
- [x] Run flutter pub get - ✅ Dependencies resolved
- [x] Run flutter analyze - ✅ No errors! (only 4 info/warnings remain)

## Remaining Non-blocking Items (info/warnings only):
- `analysis_options.yaml` - need to fix lints package
- `theme_provider.dart` - deprecated `background`/`surfaceVariant` 
- `platform_view_web.dart` - deprecated `dart:html`
- Need a running backend server at `http://localhost:3000/api/v1`

