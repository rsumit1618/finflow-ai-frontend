# Video Upload Fix - Task List

## ✅ Phase 1: Upload Progress Tracking
- [ ] `video_remote_datasource.dart` - Add `onProgress` callback to `uploadVideos`
- [ ] `video_repository.dart` - Add `onProgress` to repository interface
- [ ] `video_repository_impl.dart` - Pass progress callback through
- [ ] `upload_videos_usecase.dart` - Add progress callback
- [ ] `video_state.dart` - Add `VideoUploadProgress` state
- [ ] `video_notifier.dart` - Track upload progress
- [ ] `video_list_screen.dart` - Show progress bar in UI

## ✅ Phase 2: Fix Null Safety & Edge Cases
- [ ] `video_response.dart` - Add null-safe `createdAt` fallback
- [ ] `video_model.dart` - Add null-safe `createdAt` fallback

## ✅ Phase 3: Video Playback
- [ ] Add video playback on card tap (open URL externally)
- [ ] Install `url_launcher` if not available

## ✅ Phase 4: Backend Fixes
- [ ] Verify CORS config allows upload origins
- [ ] Add proper error types for Prisma/S3 errors
- [ ] Ensure Express 5 compatibility

## ✅ Phase 5: Testing
- [ ] Run backend `npm run dev`
- [ ] Ensure frontend builds without errors
- [ ] Test full upload flow end-to-end

