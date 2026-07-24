# Fix Web Launch Issues (Multiple Tabs & Connection Refused)

The goal is to resolve the issue where the web app opens multiple tabs upon launch and shows a "can't reach this page" error.

## User Review Required

> [!IMPORTANT]
> The "can't reach this page" error in your screenshot is for `localhost:62069`, which suggests your debug configuration is trying to connect to a port that wasn't properly initialized or has already been closed.
>
> Your `.vscode/launch.json` is currently configured to look for `localhost:8080`, but Flutter is choosing a random port (62069).

## Proposed Changes

### Configuration Fixes

#### [MODIFY] [.vscode/launch.json](file:///C:/Users/rsumi/Projects/finflow-ai-frontend/.vscode/launch.json)
- Update the configuration to be a standard Dart/Flutter launch config.
- Remove the hardcoded URL and type "chrome".
- Add `--web-port 8080` to the launch arguments to ensure the port is consistent and matches what the IDE expects.

### Navigation Logic Refinement

#### [MODIFY] [lib/features/auth/presentation/screens/login_screen.dart](file:///C:/Users/rsumi/Projects/finflow-ai-frontend/lib/features/auth/presentation/screens/login_screen.dart)
- Remove the `Navigator.pushNamedAndRemoveUntil` calls in the `ref.listen` block.
- **Reason**: `main.dart` already uses a conditional `home: _getHome(authState)` which handles the switch to `VideoListScreen` (Dashboard) automatically. Having both the widget switch and a `Navigator` push can cause inconsistent states or multiple route triggers on Web, which might contribute to multiple tab/history entries.

### Code Cleanup

#### [MODIFY] [lib/core/common/network/constants/api_constants.dart](file:///C:/Users/rsumi/Projects/finflow-ai-frontend/lib/core/common/network/constants/api_constants.dart)
- Confirm if the user intended to use the Local backend or the Production IP. I will leave it as is but ensure the launch flow is stable.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no linting errors were introduced.

### Manual Verification
1. Close all currently open browser tabs for `localhost`.
2. Stop all running Flutter processes in the terminal/IDE.
3. Launch the app using the updated "FinFlow AI (Web)" configuration in VS Code.
4. Verify that only **one** tab opens and it correctly loads the app on `http://localhost:8080`.
