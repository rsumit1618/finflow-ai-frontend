# FinFlow AI — Project Architecture

> **Version:** 1.0.0  
> **Last Updated:** 2025-01  
> **Stack:** Flutter 3.x • Dart 3.x • Riverpod • RxDart • Clean Architecture • Feature-First

---

## Table of Contents

1. [Architecture Philosophy](#1-architecture-philosophy)
2. [Technology Stack](#2-technology-stack)
3. [Project Structure](#3-project-structure)
4. [Clean Architecture Layers](#4-clean-architecture-layers)
5. [MVVM & Riverpod State Management](#5-mvvm--riverpod-state-management)
6. [RxDart Standards](#6-rxdart-standards)
7. [API Architecture](#7-api-architecture)
8. [Error Handling System](#8-error-handling-system)
9. [Repository Pattern](#9-repository-pattern)
10. [Routing Architecture](#10-routing-architecture)
11. [Reusable UI Component System](#11-reusable-ui-component-system)
12. [Responsive & Adaptive UI](#12-responsive--adaptive-ui)
13. [Theming & Design System](#13-theming--design-system)
14. [Localization](#14-localization)
15. [Performance Standards](#15-performance-standards)
16. [Security](#16-security)
17. [Environment Management](#17-environment-management)
18. [Testing Strategy](#18-testing-strategy)
19. [CI/CD](#19-cicd)
20. [Feature Development Workflow](#20-feature-development-workflow)
21. [Code Quality](#21-code-quality)
22. [Module Dependency Rules](#22-module-dependency-rules)
23. [AI Coding Rules](#23-ai-coding-rules)

---

## 1. Architecture Philosophy

This project follows a **scalable, production-grade Flutter architecture** optimized for:

- **Maintainability** — Features are isolated and independently evolvable.
- **Scalability** — Architecture supports growing codebase without degradation.
- **Testability** — Dependency injection and layer separation make testing straightforward.
- **Readability** — Consistent patterns and clear naming conventions.
- **Performance** — Efficient rendering, smart rebuilds, and pagination.
- **Developer Experience** — Predictable patterns, centralized configurations, and automation.

### Core Principles

| Principle | Application |
|-----------|-------------|
| **High Cohesion** | Related code lives within the same feature module |
| **Low Coupling** | Features depend on abstractions, not concrete implementations |
| **Separation of Concerns** | UI, business logic, and data are in distinct layers |
| **Dependency Inversion** | Domain layer defines contracts; data layer implements them |
| **Single Responsibility** | Every class has one clear purpose |
| **Open/Closed** | Extend behavior via new implementations, not modifications |
| **Composition over Inheritance** | Compose widgets and services rather than deep class hierarchies |
| **Immutable State** | All state objects are immutable; state changes produce new objects |
| **Explicit Dependencies** | All dependencies are injected via constructors or Riverpod providers |

### What to Avoid

- ❌ Business logic inside widgets or screens
- ❌ Direct API calls from UI
- ❌ Global mutable state
- ❌ Hidden dependencies (service locators, static singletons)
- ❌ Hardcoded strings, API URLs, or configuration values
- ❌ Unhandled exceptions
- ❌ God classes, God widgets, massive ViewModels
- ❌ Unnecessary abstractions — the simplest correct solution is preferred

---

## 2. Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.x | Cross-platform UI framework |
| **Language** | Dart 3.x | Type-safe, null-safe language |
| **State Management** | Riverpod 2.x | Dependency injection & state management |
| **Reactive Streams** | RxDart | Advanced stream transformations (debounce, combine, etc.) |
| **Networking** | Dio 5.x | HTTP client with interceptors |
| **Functional Errors** | dartz | `Either<Failure, Success>` pattern |
| **Immutable Models** | freezed + json_serializable | Code-generated immutable data classes |
| **Equality** | equatable | Value-based equality |
| **Secure Storage** | flutter_secure_storage | Encrypted token storage |
| **Local Storage** | shared_preferences | Simple key-value persistence |
| **Localization** | intl + custom JSON loader | Multi-language support |
| **File Handling** | file_picker | File selection from device |
| **PDF Rendering** | pdfrx | In-app PDF preview |
| **WebView** | webview_flutter | Web content embedding |
| **Permissions** | permission_handler | Runtime permission management |
| **URL Launch** | url_launcher | External URL handling |

### Package Management

- All dependencies are declared in `pubspec.yaml` with pinned versions where stability is critical.
- Use `flutter pub upgrade` with care — verify breaking changes before upgrading.
- Minimize dependency footprint; prefer Dart/Flutter built-in capabilities where sufficient.

---

## 3. Project Structure

```
lib/
├── main.dart                          # App entry point, ProviderScope, MaterialApp
│
├── app/                              # Application-level configuration
│   ├── app.dart                       # MyApp widget
│   ├── router/                        # Route definitions
│   ├── theme/                         # Theme configuration
│   ├── config/                        # App configuration
│   └── providers/                     # App-level providers
│
├── core/                             # Shared infrastructure
│   ├── common/
│   │   ├── constants/                 # API endpoints, app constants
│   │   ├── errors/                    # Exceptions, Failure classes
│   │   ├── localization/              # AppLocalizations
│   │   ├── routing/                   # AppRouter, AppRoutes
│   │   ├── theme/                     # ThemeProvider
│   │   ├── usecases/                  # UseCase abstract class
│   │   ├── utils/                     # Validators, platform utils
│   │   └── widgets/                   # Reusable UI components
│   │
│   ├── di/                           # Dependency injection container
│   ├── infrastructure/
│   │   ├── network/                   # ApiClient, AuthInterceptor
│   │   ├── services/                  # Deprecated legacy service
│   │   └── storage/                   # SecureStorage
│   │
│   ├── constants/                     # Shared constants
│   ├── errors/                        # Shared error models
│   ├── network/                       # Network utilities
│   └── utils/                         # General utilities
│
├── features/                          # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/           # Remote + Local data sources
│   │   │   ├── models/                # DTOs (freezed)
│   │   │   └── repositories/          # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/              # Domain entities
│   │   │   ├── repositories/          # Repository contracts
│   │   │   └── usecases/              # Business logic use cases
│   │   └── presentation/
│   │       ├── providers/             # StateNotifiers, Providers
│   │       ├── screens/               # Pages
│   │       └── widgets/               # Feature-specific widgets
│   │
│   └── video/
│       ├── data/
│       ├── domain/
│       └── presentation/              # (same structure as auth)
│
└── utils/                             # App-level utilities
    └── error_utils.dart
```

### Key Structural Rules

1. **Feature modules are independently understandable.** A developer should grasp a feature's purpose by reading its own files without jumping across features.
2. **No circular dependencies between features.** If Feature A needs types from Feature B, the shared types belong in `core/` or a `shared/` module.
3. **Shared widgets** that are used across features belong in `core/common/widgets/`.
4. **Feature-specific widgets** remain inside that feature's `presentation/widgets/`.

---

## 4. Clean Architecture Layers

The project enforces a strict three-layer architecture within each feature:

```
┌──────────────────────────────────┐
│         PRESENTATION             │
│  Screens • Widgets • ViewModels  │
│  StateNotifiers • Riverpod Prov. │
├──────────────────────────────────┤
│            DOMAIN                │
│  Entities • Repository Contracts │
│  UseCases • Business Logic       │
├──────────────────────────────────┤
│             DATA                 │
│  DataSources • Models (DTOs)     │
│  Repository Implementations      │
│  Serialization • API Calls       │
└──────────────────────────────────┘
         ↓                         │
    External Systems                │
  (API • Database • Storage)        │
```

### 4.1 Presentation Layer

**Responsibilities:**
- Render UI based on state
- Handle user interactions
- Listen to state changes via Riverpod
- Trigger ViewModel actions (not business logic directly)

**Constraints:**
- ❌ Must NOT call APIs directly
- ❌ Must NOT contain business logic
- ❌ Must NOT perform database operations
- ❌ Must NOT parse API responses
- ✅ Must handle: loading, success, empty, error states

**Example:**
```dart
// Screen listens to state and delegates actions to notifier
final state = ref.watch(videoNotifierProvider);
// UI renders based on state type
// User action triggers notifier method
ref.read(videoNotifierProvider.notifier).fetchVideos(refresh: true);
```

### 4.2 Domain Layer

**Responsibilities:**
- Define business entities
- Define repository contracts (abstract classes)
- Implement use cases (business logic)
- Remain framework-independent

**Constraints:**
- ✅ Zero dependency on Flutter UI
- ✅ Zero dependency on Dio, HTTP clients, or database packages
- ✅ Zero dependency on JSON serialization
- ✅ Only depends on Dart SDK and `dartz` / `equatable`

**Example:**
```dart
// Domain entity — pure Dart, no Flutter dependency
class UserEntity extends Equatable {
  final String id;
  final String email;
  // ...
}

// Repository contract — defined in domain, implemented in data
abstract class AuthRepository {
  Future<Either<Failure, AuthTokensEntity>> login({required String email, required String password});
}

// Use case — orchestrates business logic
class GetVideosUseCase implements UseCase<List<VideoEntity>, GetVideosParams> {
  final VideoRepository repository;
  // ...
}
```

### 4.3 Data Layer

**Responsibilities:**
- Communicate with external systems (API, local storage)
- Implement repository contracts from the domain layer
- Handle serialization/deserialization (DTOs ↔ Entities)
- Convert technical exceptions into domain `Failure` objects

**Constraints:**
- ✅ Implements interfaces defined in domain layer
- ✅ Depends on Dio, flutter_secure_storage, etc.
- ✅ Converts `ServerException` → `ServerFailure`
- ❌ Must NOT leak DTOs to the presentation layer

**Example:**
```dart
// Model (DTO) with freezed — includes toEntity() method
@freezed
class UserModel with _$UserModel {
  const factory UserModel({ ... }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  const UserModel._();
  UserEntity toEntity() => UserEntity(/* ... */);
}

// Repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  // Implements domain contract, catches exceptions, returns Either<Failure, T>
}
```

---

## 5. MVVM & Riverpod State Management

### Architecture Pattern

The project uses **Model-View-ViewModel (MVVM)** powered by Riverpod.

```
View (Screen/Widget) ← watches → ViewModel (StateNotifier) ← calls → UseCase ← calls → Repository
       ↓ renders                          ↓ exposes
    UI State                        Immutable State Object
```

### Provider Types & Usage

| Provider Type | When to Use | Example |
|---------------|-------------|---------|
| `Provider` | Injecting dependencies (repositories, datasources) | `final authRepositoryProvider = Provider<AuthRepository>(...)` |
| `FutureProvider` | Simple async data loading without state management | Loading a one-time configuration |
| `StreamProvider` | Exposing a stream of data | Real-time updates |
| `StateNotifierProvider` | Managing mutable state with immutable state objects | `StateNotifierProvider<AuthNotifier, AuthState>` |
| `AsyncNotifierProvider` | Async state with loading/error/data states | Complex async features |

### State Modeling Guidelines

Every async feature should model these states explicitly:

```dart
abstract class VideoState extends Equatable {
  const VideoState();
}

class VideoInitial extends VideoState {}
class VideoLoading extends VideoState {}
class VideoLoaded extends VideoState {
  final List<VideoEntity> videos;
  final bool hasMore;
}
class VideoError extends VideoState {
  final String message;
}
class VideoUploading extends VideoState {}
class VideoUploadSuccess extends VideoState {
  final List<VideoEntity> uploadedVideos;
}
```

**Anti-pattern — avoid:**
```dart
// ❌ Multiple unrelated boolean flags
bool isLoading = false;
bool isError = false;
bool isEmpty = false;
bool hasData = false;
```

### Provider Rules

- ✅ Providers must have a clear, single responsibility.
- ✅ Use `ref.watch()` for reactive rebuilds and `ref.read()` for one-time actions.
- ✅ Use provider overrides for testing.
- ✅ Prefer `family` providers for parameterized dependencies.
- ❌ Avoid unnecessary global state — prefer feature-scoped providers.
- ❌ Don't create providers that mix unrelated concerns.

### ViewModel (StateNotifier) Guidelines

- ✅ Manages feature-specific presentation state.
- ✅ Exposes methods for UI actions.
- ✅ Uses `state =` to trigger UI rebuilds with new state objects.
- ❌ Should NOT become a replacement for the domain layer — complex business logic belongs in UseCases.
- ❌ Should NOT directly call API or database operations.

---

## 6. RxDart Standards

### When to Use RxDart

RxDart should be used **only when reactive programming provides clear value** over native Dart streams.

**Good use cases for RxDart:**
- ✅ Search with debounce (`debounceTime`)
- ✅ Combining multiple streams (`CombineLatestStream`, `ZipStream`)
- ✅ Reactive form validation
- ✅ Complex stream transformations (`switchMap`, `flatMap`)
- ✅ WebSocket or real-time data pipelines
- ✅ Pagination event streams
- ✅ Token refresh queue management

**Avoid RxDart when:**
- ❌ A simple `FutureProvider` or `AsyncNotifier` suffices.
- ❌ Only a single stream is being listened to.
- ❌ The transformation is simple enough for native Dart streams.

### Current RxDart Usage in Project

```dart
// AuthNotifier uses BehaviorSubject for internal reactive state
final _emailSubject = BehaviorSubject<String>();
final _passwordSubject = BehaviorSubject<String>();
```

### RxDart Patterns

- ✅ Always close subjects in `dispose()`.
- ✅ Use `add()` to push values, not `addError()` for business errors (use `Failure` objects instead).
- ✅ Prefer `.stream` property for exposing subjects externally.

---

## 7. API Architecture

### Centralized API Client

The project uses a single `Dio` instance configured centrally in `ApiClient`:

```
UI → ViewModel → UseCase → Repository → DataSource → ApiClient (Dio) → Backend
```

### ApiClient Configuration

```dart
class ApiClient {
  ApiClient(this.dio) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
```

### Auth Interceptor

The `AuthInterceptor` automatically:
1. Attaches `Authorization: Bearer <token>` to all outgoing requests.
2. Intercepts 401 responses and attempts token refresh.
3. On successful refresh, retries the original request with the new token.
4. On refresh failure, clears tokens (forcing re-login).

### API Constants

All endpoints are centralized in `ApiConstants`:
- Single source of truth — no scattered URL strings.
- Supports dev/prod base URL switching via comment toggle.
- Document-like endpoints, video endpoints, auth endpoints in one place.

**Important:** `AppConstants` is deprecated. Use `ApiConstants` exclusively for API configuration.

---

## 8. Error Handling System

### Unified Error Model

```
Technical Exception (e.g., DioException)
        ↓
  ServerException / CacheException
        ↓
  ServerFailure / CacheFailure / NetworkFailure
        ↓
  ViewModel maps to user-friendly error state
        ↓
  UI renders user-friendly message
```

### Exception Classes (Data Layer)

```dart
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error occurred']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache Error occurred']);
}
```

### Failure Classes (Shared Across All Layers)

```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure { const ServerFailure(super.message); }
class CacheFailure extends Failure { const CacheFailure(super.message); }
class NetworkFailure extends Failure { const NetworkFailure([super.message = 'No Internet Connection']); }
```

### Error Handling Rules

- ✅ Technical exceptions (DioException, SocketException) are caught in the Data layer.
- ✅ Exceptions are converted to `Failure` objects before crossing into the Domain layer.
- ✅ ViewModels map `Failure` to typed error states (`VideoError(message)`).
- ✅ UI shows user-friendly messages, never raw exception text.
- ❌ Never display: `SocketException: Failed host lookup`
- ✅ Instead display: `"Unable to connect to the server. Please check your internet connection."`

**Pattern for Repository implementation:**

```dart
@override
Future<Either<Failure, List<VideoEntity>>> getVideos({int page = 1, int limit = 10}) async {
  try {
    final models = await remoteDataSource.getVideos(page: page, limit: limit);
    return Right(models.map((m) => m.toEntity()).toList());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

---

## 9. Repository Pattern

### Structure

```
Domain Layer (abstraction, no implementation)
  ├── abstract class AuthRepository { ... }
  └── abstract class VideoRepository { ... }

Data Layer (implementation)
  ├── class AuthRepositoryImpl implements AuthRepository { ... }
  └── class VideoRepositoryImpl implements VideoRepository { ... }
```

### Rules

- ✅ Domain layer defines abstract repository interfaces.
- ✅ Data layer provides concrete implementations.
- ✅ ViewModels and UseCases depend on abstractions, not implementations.
- ✅ Riverpod providers wire abstractions to implementations.

### Benefits

- Swap between REST API, mock data, local database, or cached data without changing business logic.
- Testing is straightforward — inject mock repositories.
- Clear contract between domain and data layers.

---

## 10. Routing Architecture

### Centralized Routing

Route definitions are centralized in `AppRouter` and `AppRoutes`:

```dart
class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      // ...
    }
  }
}
```

### Route Guards

Authentication-based navigation is handled at the app root in `main.dart`:

```dart
Widget _getHome(AuthState state) {
  if (state is AuthInitial || state is AuthLoading) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  if (state is AuthAuthenticated) {
    return const VideoListScreen();
  }
  return const LoginScreen();
}
```

### Navigation Rules

- ✅ Use `Navigator.pushNamed` with route constants from `AppRoutes`.
- ❌ Avoid direct screen instantiation for navigation — use named routes.
- ❌ Avoid scattering route strings across the codebase.

---

## 11. Reusable UI Component System

### Available Components

| Component | File | Description |
|-----------|------|-------------|
| `CustomButton` | `core/common/widgets/custom_button.dart` | Elevated button with loading state, custom color |
| `CustomTextField` | `core/common/widgets/custom_text_field.dart` | Text input with label, icon, validation, theming |

### Design System Guidelines

- ✅ All reusable components live in `core/common/widgets/`.
- ✅ Components use `Theme` from context for colors, typography, and shapes.
- ✅ Components support loading, disabled, and error states where applicable.
- ✅ Components are composable — prefer composition over one massive widget.

### Adding New Components

1. Place in `core/common/widgets/`.
2. Use `Theme.of(context)` for styling — do not hardcode colors/sizes.
3. Support `const` constructors where possible.
4. Document the widget's purpose and parameters.
5. Consider: loading state, disabled state, empty state, error state.

---

## 12. Responsive & Adaptive UI

### Strategy

The application adapts to different screen sizes using:
- `LayoutBuilder` for breakpoint-based layouts
- `ConstrainedBox` for maximum content width on large screens
- `MediaQuery` for safe area insets and screen dimensions
- `Flexible` and `Expanded` for proportional layouts

### Current Responsive Patterns

- Login/Register screens use `ConstrainedBox(maxWidth: 400)` centered on all screen sizes.
- Content areas use single-column scrolling layouts optimized for mobile-first.
- Future: Navigation rail for tablets, bottom navigation for phones.

### Rules

- ✅ Avoid hardcoded width/height values where proportional sizing makes sense.
- ✅ Test on small phones (360px), large phones (414px), and tablets (768px+).
- ✅ Use `RefreshIndicator` for pull-to-refresh across all platforms.
- ❌ Do not use platform checks (`Platform.isAndroid`) for layout decisions — use screen metrics.

---

## 13. Theming & Design System

### Theme Architecture

The `ThemeProvider` (currently using `ChangeNotifier`) manages:
- `ThemeMode` — light, dark, system
- `PrimaryColor` — dynamically selectable accent color
- `FontFamily` — configurable typography

### Dark Mode

Premium dark palette:
- Background: `#0F111A` (deep navy)
- Surface: `#1A1D2D` (dark card)
- Surface Variant: `#25293D`

### Design Tokens

The project uses Material 3 design language:
- `ColorScheme.fromSeed()` for harmonious color generation.
- Rounded corners (12px–24px radius).
- Consistent card and button shapes.
- Gradient-friendly backgrounds.

### Rules

- ✅ All components get colors from `Theme.of(context).colorScheme`.
- ✅ Do not hardcode colors in widget files.
- ✅ Use `Theme.of(context).textTheme` for typography.
- ✅ Support both light and dark themes via `ThemeProvider`.

---

## 14. Localization

### Current Implementation

- JSON-based translation files in `assets/lang/`.
- `AppLocalizations` class loads JSON and provides `translate(key)`.
- Supports `en.json` (English).

### Adding a New Language

1. Create `assets/lang/{languageCode}.json` with translated keys.
2. Add language code to `isSupported()` in `AppLocalizations`.
3. All UI text should use `AppLocalizations.of(context)!.translate('key')`.

### Rules

- ✅ All user-facing strings must go through `AppLocalizations`.
- ❌ No hardcoded user-facing strings in widgets.
- ✅ Translation keys should be descriptive and hierarchical (e.g., `auth.login.title`).

---

## 15. Performance Standards

### Optimization Practices

| Area | Practice |
|------|----------|
| Widgets | Use `const` constructors whenever possible |
| Lists | Use `ListView.builder` for large/variable-length lists |
| Pagination | Fetch data in pages (10 items per page) |
| Images | Cache network images; provide error builders |
| Rebuilds | Use selective Riverpod watching; avoid watching entire state when a field suffices |
| Disposal | Close streams, controllers, and subjects in `dispose()` |
| Initial Load | Use `Future.microtask` for initial async operations in `initState` |

### Pagination Pattern (Video Feature)

```dart
// Pagination state tracked in ViewModel
int _currentPage = 1;

// On fetch, increment page counter
// hasMore = videos.length >= pageSize
state = VideoLoaded(videos: [...currentVideos, ...videos], hasMore: videos.length >= 10);
```

### Rules

- ❌ Do not perform expensive operations inside `build()` methods.
- ❌ Do not load all data at once — paginate lists.
- ✅ Profile before optimizing — do not prematurely optimize.
- ✅ Use `const` constructors as a default habit.

---

## 16. Security

### Current Practices

- ✅ Tokens stored in `flutter_secure_storage` (encrypted).
- ✅ Android: `encryptedSharedPreferences: true`.
- ✅ iOS: `KeychainAccessibility.first_unlock`.
- ✅ No hardcoded API keys or secrets in source code.
- ✅ Token refresh mechanism prevents long-lived access tokens.

### Rules

- ❌ Never commit secrets, API keys, or tokens to version control.
- ❌ Never log passwords, tokens, or sensitive personal data.
- ❌ Never store sensitive data in `SharedPreferences`.
- ✅ Use environment configuration for sensitive values.
- ✅ Clear tokens on logout.

---

## 17. Environment Management

### Supported Environments

| Environment | Base URL | Notes |
|-------------|----------|-------|
| Development | `http://localhost:3000/api/v1` | Local backend |
| Production | `http://16.171.113.12:3000/api/v1` | Deployed backend |

### Switching Environments

In `ApiConstants`, toggle the base URL:
```dart
static const String baseUrl = 'http://localhost:3000/api/v1'; // Dev
// static const String baseUrl = 'http://16.171.113.12:3000/api/v1'; // Prod
```

### Future Enhancement

Implement a proper environment configuration system with:
- `.env` files or Dart `--dart-define` flags.
- Build-time environment selection.
- Feature flags per environment.

### Rules

- ✅ Never manually edit production URLs in code at deployment time.
- ✅ Environment selection should be explicit and intentional.
- ❌ Never hardcode environment-specific values in feature code.

---

## 18. Testing Strategy

### Current State

- Test directory exists at `test/` with `widget_test.dart`.
- Architecture is designed for testability (DI, abstract repositories, immutable state).

### Testing Layers

| Test Type | Scope | Tools |
|-----------|-------|-------|
| **Unit Tests** | UseCases, Repositories, Validators, Mappers, Failure conversion | `flutter_test`, `mocktail`/`mockito` |
| **Widget Tests** | Loading/Success/Empty/Error states, User interactions | `flutter_test`, `ProviderScope` overrides |
| **Integration Tests** | Auth flow, Video upload/list/delete flow | `integration_test` |

### Writing Tests

**Repository test pattern:**
```dart
void main() {
  late MockRemoteDataSource mockRemote;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemote, localDataSource: mockLocal);
  });

  test('login returns Right on success', () async { ... });
  test('login returns Left(ServerFailure) on exception', () async { ... });
}
```

**Provider test pattern:**
```dart
void main() {
  testWidgets('LoginScreen shows error on AuthError', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authNotifierProvider.overrideWith(...)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    // verify error state renders correctly
  });
}
```

### Rules

- ✅ Every UseCase should have unit tests.
- ✅ Every screen should have widget tests for all states.
- ✅ Use provider overrides for injecting mock ViewModels.
- ❌ Tests should not depend on real APIs or external services.

---

## 19. CI/CD

### Current State

No automated CI/CD pipeline is currently configured.

### Recommended Pipeline

```
Pull Request
    ↓
Format Check (dart format --dry-run)
    ↓
Static Analysis (flutter analyze)
    ↓
Unit Tests (flutter test --coverage)
    ↓
Widget Tests
    ↓
Build Validation (flutter build apk --debug)
    ↓
Code Review
    ↓
Merge to Main
    ↓
Build Release (manual or automated)
```

### Tools

| Tool | Purpose |
|------|---------|
| `dart format` | Code formatting |
| `flutter analyze` | Static analysis |
| `flutter test` | Run all tests |
| `flutter build` | Build for release |

---

## 20. Feature Development Workflow

### Step-by-Step Process

For every new feature:

1. **Understand the business requirement.**
2. **Define the domain entity** (in `domain/entities/`).
3. **Define repository contracts** (in `domain/repositories/`).
4. **Define UseCases** (in `domain/usecases/`).
5. **Define API models/DTOs** (in `data/models/` with freezed).
6. **Implement data sources** (remote and/or local in `data/datasources/`).
7. **Implement repository** (in `data/repositories/`).
8. **Create ViewModel** (`StateNotifier` in `presentation/providers/`).
9. **Define immutable UI state** (in `presentation/providers/state/`).
10. **Create providers** (Riverpod wiring in `presentation/providers/`).
11. **Create reusable UI components** as needed.
12. **Build screens/pages** (in `presentation/screens/`).
13. **Add routing** to `app_router.dart`.
14. **Implement loading, empty, success, and error states.**
15. **Add responsive behavior** (test on multiple screen sizes).
16. **Add tests** (unit + widget).
17. **Run `flutter analyze` and `dart format`**.
18. **Review architecture and dependencies.**

### Verification Checklist

Before finalizing any feature, verify:

- [ ] Does it follow SOLID principles?
- [ ] Is business logic outside the UI?
- [ ] Is the feature independently testable?
- [ ] Are dependencies properly injected (no hidden dependencies)?
- [ ] Are API errors handled and converted to user-friendly messages?
- [ ] Are loading, empty, and error states implemented?
- [ ] Is the UI responsive across phone/tablet?
- [ ] Are reusable components used (not duplicated UI)?
- [ ] Is routing properly integrated?
- [ ] Is the code easy to modify later?
- [ ] Are hardcoded strings avoided (localization)?
- [ ] Are `const` constructors used where possible?

---

## 21. Code Quality

### Linting & Analysis

- The project uses `package:flutter_lints/flutter.yaml` as the base lint set.
- **Current configuration in `analysis_options.yaml`:**
  ```yaml
  include: package:flutter_lints/flutter.yaml
  ```
- Stricter lint rules should be enabled as the project matures.

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Files | `snake_case` | `auth_repository.dart` |
| Classes | `PascalCase` | `AuthRepository` |
| Methods/Functions | `camelCase` | `fetchVideos()` |
| Variables | `camelCase` | `accessToken` |
| Constants | `camelCase` (or `SCREAMING_CASE` for static const) | `connectTimeout` |
| Private members | Prefix with `_` | `_currentPage` |
| Providers | `camelCase` + `Provider` suffix | `authRepositoryProvider` |

### Code Review Standards

- ✅ Code must pass `flutter analyze` without errors.
- ✅ No dead code or commented-out code.
- ✅ No `print()` statements — use `debugPrint()` for development logging.
- ✅ No `// ignore:` comments without a documented reason.
- ✅ Prefer simple, readable code over clever, complex solutions.

---

## 22. Module Dependency Rules

### Dependency Direction

```
app/  →  features/  →  core/  →  Dart SDK / Flutter SDK / Packages
```

### Rules

1. **Core layer** (`core/`) must not depend on any feature module.
2. **Domain layer** within a feature must not depend on Flutter UI or data layer packages.
3. **Data layer** depends on domain layer (implements interfaces).
4. **Presentation layer** depends on domain layer (uses entities, calls use cases).
5. **Features** must not have circular dependencies.
6. **Shared utilities** belong in `core/`, not in a feature module.
7. **App-level providers** in `core/di/` wire features together — this is the only place where multiple features are composed.

### Visual Dependency Map

```
┌──────────────────────────────────────────────────────┐
│  app/ (main.dart, app.dart)                          │
│  ┌────────────────────────────────────────────────┐  │
│  │  features/auth/                                │  │
│  │  features/video/                               │  │
│  └────────────────────────────────────────────────┘  │
│           ↓ depends on                                │
│  ┌────────────────────────────────────────────────┐  │
│  │  core/                                         │  │
│  │  constants, errors, network, widgets, etc.     │  │
│  └────────────────────────────────────────────────┘  │
│           ↓ depends on                                │
│  Flutter SDK + Dart SDK + Pub Packages               │
└──────────────────────────────────────────────────────┘
```

---

## 23. AI Coding Rules

When generating or modifying code with AI assistance:

1. **First understand the existing architecture** — read the relevant files and this document.
2. **Follow existing project conventions** — naming, structure, patterns.
3. **Do not introduce a new architecture** without justification and discussion.
4. **Do not create duplicate utilities** — check `core/common/` first.
5. **Reuse existing components** — `CustomButton`, `CustomTextField`, etc.
6. **Keep changes focused** — modify only the files relevant to the task.
7. **Do not modify unrelated files** — avoid scope creep.
8. **Explain architectural decisions** when deviating from established patterns.
9. **Generate production-ready code** — include error handling, loading states, empty states.
10. **Consider responsive layouts** — test on multiple screen sizes.
11. **Consider testing** — ensure new code is testable.
12. **Consider performance** — avoid unnecessary rebuilds, paginate lists.
13. **Consider localization** — no hardcoded user-facing strings.
14. **Use `Either<Failure, T>`** for operations that can fail.
15. **Generate immutable state models** — use freezed for data classes.

---

> **This document is the architectural constitution of the FinFlow AI project.**
> All contributors and AI coding agents should refer to this document when making decisions about project structure, patterns, and standards.
>
> *The goal is not to create the most layers — it is to create a codebase where features can evolve independently, business logic is easy to test, and the application can scale without becoming difficult to maintain.*

