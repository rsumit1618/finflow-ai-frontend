# FinFlow AI — AI Agent Coding Guidelines

> **Companion to `PROJECT_ARCHITECTURE.md`**  
> Quick-reference rules for AI-assisted development.

---

## Before You Code

1. Read the relevant files to understand the current implementation.
2. Check `core/common/` for existing utilities before creating new ones.
3. Follow the **feature-first** structure: `data/ → domain/ → presentation/`.
4. Never modify files unrelated to the task.

## Architecture Rules

| Rule | Enforced |
|------|----------|
| Business logic outside UI | ✅ Always |
| No direct API calls from widgets | ✅ Always |
| Use `Either<Failure, T>` for fallible operations | ✅ Always |
| Immutable state (freezed + equatable) | ✅ Always |
| Dependencies injected via Riverpod | ✅ Always |
| No hardcoded strings — use AppLocalizations | ✅ Always |
| No hardcoded API URLs — use ApiConstants | ✅ Always |

## State Pattern

Every async feature MUST model these states:

```dart
Initial → Loading → Success (with data)
Initial → Loading → Empty
Initial → Loading → Error (with message)
```

## File Structure Per Feature

```
feature_name/
├── data/
│   ├── datasources/        # Remote + Local data sources
│   ├── models/             # freezed DTOs with toEntity()
│   └── repositories/       # Implements domain interfaces
├── domain/
│   ├── entities/           # Pure Dart entities
│   ├── repositories/       # Abstract contracts
│   └── usecases/           # Business logic
└── presentation/
    ├── providers/          # StateNotifier + Riverpod wiring
    ├── screens/            # Pages
    └── widgets/            # Feature-specific components
```

## Layer Dependencies

```
presentation → domain ← data (implements domain contracts)
core/ → used by all features
features must NOT depend on each other
```

## Provider Patterns

```dart
// 1. DataSource provider
final remoteDataSourceProvider = Provider<XxxRemoteDataSource>((ref) {
  return XxxRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

// 2. Repository provider
final repositoryProvider = Provider<XxxRepository>((ref) {
  return XxxRepositoryImpl(remoteDataSource: ref.watch(remoteDataSourceProvider));
});

// 3. UseCase providers (if needed)
final useCaseProvider = Provider<XxxUseCase>((ref) {
  return XxxUseCase(ref.watch(repositoryProvider));
});

// 4. StateNotifier provider
final notifierProvider = StateNotifierProvider<XxxNotifier, XxxState>((ref) {
  return XxxNotifier(useCase: ref.watch(useCaseProvider));
});
```

## Error Handling Flow

```
DioException → DataSource (throw ServerException)
  → Repository (catch, convert to Failure)
    → ViewModel (map to error state)
      → UI (show user-friendly message)
```

## Checklist Before Submitting Code

- [ ] Uses existing reusable widgets (`CustomButton`, `CustomTextField`)
- [ ] All user-facing strings use localization
- [ ] All API endpoints come from `ApiConstants`
- [ ] Loading, empty, success, and error states handled
- [ ] `const` constructors used where possible
- [ ] Tests are possible (testable architecture)
- [ ] `flutter analyze` passes without errors
- [ ] No dead code, no `print()`, no hardcoded values

---

*When in doubt, refer to `PROJECT_ARCHITECTURE.md` for the full specification.*

