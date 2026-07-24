# FinFlow AI - Figma UI Migration TODO

## Phase 1: Project Setup ✅
- [x] Create TODO.md
- [x] Update pubspec.yaml (add flutter_svg dependency)
- [x] Download Figma assets (SVG backgrounds, search icon)
- [x] Add asset paths to pubspec.yaml

## Phase 2: Theme & Design System ✅
- [x] Create `finflow_colors.dart` - Full color palette matching Figma
- [x] Create `finflow_theme.dart` - Light + Dark theme with Figma styles
- [x] Update `main.dart` to use FinFlowTheme

## Phase 3: Reusable Widgets ✅
- [x] Create `glass_card.dart` - Reusable frosted glass container
- [x] Create `finflow_button.dart` - Primary/secondary/social buttons
- [x] Create `finflow_text_field.dart` - Styled input fields
- [x] Create `finflow_stat_card.dart` - Metric display card
- [x] Create `finflow_sidebar.dart` - Sidebar navigation (web) with brand + nav items
- [x] Create `finflow_bottom_nav.dart` - Bottom nav with FAB (mobile)

## Phase 4: Login Screen ✅
- [x] Rebuild login screen (mobile + web responsive with LayoutBuilder)
- [x] Figma glass card with brand icon + "FinFlow AI" heading
- [x] Email/Password fields + Remember Me toggle
- [x] Primary "Sign In" button with boxShadow
- [x] "Or continue with" divider + Google/Apple social buttons
- [x] "New to FinFlow? Create an account" link
- [x] Footer with Privacy Policy, Terms, Cookie links
- [x] Wire up with existing auth state management

## Phase 5: Dashboard Screen ✅
- [x] Rebuild dashboard screen with Figma web layout
- [x] Sidebar (256px) with brand, workspace selector, nav items, upgrade button
- [x] Top navbar with search bar + nav links + notifications + avatar
- [x] Welcome header "Hello, Creator"
- [x] 4 metric stat cards in responsive grid
- [x] Main layout: Recent Content (2/3) + Upload Section (1/3)
- [x] Mobile layout: Bottom nav bar with FAB center button
- [x] Footer with legal links
- [x] Wire up with existing video/providers
- [x] Updated dashboard_upload_section.dart to use FinFlowColors

## Phase 6: Dark Theme ✅
- [x] Create dark theme variant in finflow_theme.dart
- [x] Dashboard adapts to dark mode (isDark checks throughout)

## Phase 7: Polish & Verify
- [ ] Run `flutter pub get` to resolve dependencies
- [ ] Verify all existing API integrations still work
- [ ] Test responsive breakpoints
- [ ] Add missing font files to assets/fonts/

