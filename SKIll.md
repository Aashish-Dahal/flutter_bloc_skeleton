# Flutter Bloc Skeleton — Engineering Guide

## Project overview

Flutter application using **BLoC** for state, **GetIt** for dependency injection, **Dio** for HTTP, and **go_router** for navigation. Business logic is grouped by **feature** under `lib/features/`. Shared UI and cross-cutting concerns live under `lib/core/` and `lib/shared/`. Localization is generated from ARB (`flutter gen-l10n`).

---

## Generic checklist — add a new page (any feature)

Use this order for **every** new screen so routing, DI, and tests stay consistent. Replace `<feature>` with the feature folder name (e.g. `auth`, `home`).

| Step | Action |
|------|--------|
| 1 | Place UI only under `lib/features/<feature>/presentation/`. Do not add feature pages under `lib/core/`. |
| 2 | Add **path** and **route name** in `presentation/routes/<feature>_route_paths.dart` (or extend the existing enum/constants for that feature). |
| 3 | Register a **`GoRoute`** in `presentation/routes/<feature>_routes.dart` pointing to your `const` page widget. |
| 4 | Compose routes in **`lib/core/routes/app_routes.dart`** (e.g. `...<Feature>Routes.routes`). If global redirects or `AppPage` need the new segment, update **`route_path.dart`** (or the shared enum) so paths stay in sync with step 2. |
| 5 | Implement **`presentation/pages/<name>_page.dart`** as a thin page; move layout/forms to **`presentation/widgets/`** (atoms / molecules as needed). |
| 6 | **Bloc**: add events/handlers/states for new user actions; no API calls or repositories inside widgets. |
| 7 | **DI**: register new use cases, repositories, or blocs in **`<feature>_di.dart`**. `service_locator.dart` should already call `init<Feature>()`. |
| 8 | **Barrel** **`lib/features/<feature>/<feature>.dart`**: export anything that `core/` or tests import by package path. |
| 9 | **l10n**: add ARB strings and regenerate if the title or copy uses **`S`**. |
| 10 | **Tests**: widget test with mocked bloc + `MaterialApp`; supply **`S.localizationsDelegates`** and **`S.supportedLocales`** when the page calls **`S.of`**. Add unit tests for new pure logic. |
| 11 | Run **`dart format .`**, **`flutter analyze --fatal-infos`**, and affected tests. |

**Reference implementation:** `lib/features/auth/` (`auth_route_paths.dart`, `auth_routes.dart`, `login_page.dart`, `login_page_view.dart`).

---

## Feature-based folder structure

### Rules

- Each **feature** is a vertical slice: `data` → `domain` → `presentation`, plus feature-local wiring.
- A feature **must not** import another feature’s implementation details. Use **core**, **shared**, or explicit shared contracts if needed.
- **Public surface** of a feature is exposed through a single barrel file: `lib/features/<feature>/<feature>.dart` (e.g. `auth.dart`) exporting DI registration, primary bloc(s), and routes owned by that feature.
- **Routes** defined by a feature stay under `presentation/routes/` (e.g. `auth_route_paths.dart`, `auth_routes.dart`). The app router composes feature route lists (e.g. `AuthRoutes.routes`).
- **Dependency injection**: each feature provides `init<Feature>()` in `<feature>_di.dart`, called from `lib/core/di/service_locator.dart`.

### Layout (reference)

```
lib/
  app.dart
  main.dart
  config.dart
  core/                 # Cross-cutting: theme, network, DI bootstrap, global routes composition
  features/
    <feature>/
      <feature>.dart    # Barrel (exports)
      <feature>_di.dart
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/   # Abstract repository interfaces
        usecases/
      presentation/
        bloc/
        pages/
        routes/         # Feature-owned paths + GoRoute builders
        widgets/
  shared/               # Reusable widgets, pagination helpers, non-feature-specific cubits
```

---

## Coding standards

- **Null safety**: no unchecked null assertions in production UI paths; prefer explicit guards and early returns.
- **State**: events and states are immutable; use `equatable` / code generation where the project already does.
- **Errors**: map failures to user-visible messages in the presentation layer; keep domain and data layers free of `BuildContext` and widgets.
- **Async**: use cases return typed results (`ApiResult` / similar); avoid throwing for expected failures.
- **Imports**: prefer **relative imports** within `lib` (`prefer_relative_imports`); package imports are acceptable for tests and generated code.

---

## Naming conventions

| Kind | Convention | Example |
|------|------------|---------|
| Files | snake_case | `auth_repository_impl.dart` |
| Classes / enums | UpperCamelCase | `AuthBloc`, `AuthRoute` |
| Members / parameters | lowerCamelCase | `loginUseCase` |
| Private members | leading `_` | `_goRouter` |
| Constants | lowerCamelCase or `static const` in class | `AuthRoute.login.path` |
| Bloc files | `*_bloc.dart`, `*_event.dart`, `*_state.dart` | `auth_bloc.dart` |

---

## Code formatting

- **Mandatory**: format all Dart with **`dart format`** (IDE format on save recommended).
- **CI**: `dart format . --set-exit-if-changed` must pass on PRs/pushes to protected branches.
- Do not hand-indent around `dart format` output; run format after substantive edits.

---

## Linting

- **Base ruleset**: `package:flutter_lints/flutter.yaml` via `analysis_options.yaml`.
- **Severity**: selected rules are elevated to **error** in the analyzer (see `analyzer.errors` in `analysis_options.yaml`).

### Active lint rules (project)

- `avoid_print`
- `camel_case_types`
- `camel_case_extensions`
- `non_constant_identifier_names`
- `constant_identifier_names`
- `curly_braces_in_flow_control_structures`
- `avoid_dynamic_calls`
- `avoid_empty_else`
- `avoid_types_as_parameter_names`
- `cancel_subscriptions`
- `collection_methods_unrelated_type`
- `comment_references`
- `control_flow_in_finally`
- `deprecated_member_use_from_same_package`
- `require_trailing_commas`
- `library_prefixes`
- `prefer_relative_imports`

Run **`flutter analyze --fatal-infos`** before merge; CI should match.

---

## Testing strategy

### Unit tests

**Purpose**  
Verify **pure logic**: use cases, mappers, validators, and pure functions with **no** Flutter framework or `BuildContext`.

**Guidelines**

- Test domain/data in isolation: mock repository interfaces or inputs only.
- Use **mocktail** / **bloc_test** for bloc **when** you test bloc logic without pumping widgets.
- No `WidgetTester`; no `MaterialApp` unless you are explicitly in a widget test file.
- Prefer one logical behavior per test; name tests `when … then …` or `given … expect …`.

---

### Widget tests

**Purpose**  
Verify **UI behavior** of screens and components: layout, taps, visibility, and interaction with **mocked** blocs/repositories.

**Guidelines**

- Wrap widgets with `MaterialApp` / `BlocProvider` as needed; inject **mock** blocs (`MockAuthBloc`, etc.).
- Use **mocked data** and fixed bloc states; avoid real network or DI from `main()`.
- Pump interactions with `tester.tap`, `enterText`, then `pumpAndSettle` where async applies.
- If screens use generated localization (`S.of(context)`), provide localization delegates in test harness or mock/stub—tests must not rely on uninitialized `S`.

---

### Integration tests

**Purpose**  
Validate **multi-module flows** and **real app wiring**: navigation, auth gates, and end-to-end paths across features (e.g. login → home).

**Guidelines**

- Live under `integration_test/` (add `integration_test` dependency if not present); drive the **real** `main()` or a test entrypoint with test backends.
- Prefer one critical user journey per test file; use stable `Key`s or semantics where possible.
- Use fake APIs or staging endpoints; do not hit production with automation secrets in-repo.

---

### Coverage requirements

- Treat coverage as a **quality signal**, not a vanity metric.
- **Targets (recommended)**  
  - **Domain / use cases**: high coverage (≥ **80%** lines for touched modules).  
  - **Presentation**: focus on branch coverage for blocs and critical UI paths.  
  - **Generated files (`*.g.dart`, `*.freezed.dart`)**: exclude from expectations or ignore in reports.
- Fail CI if coverage drops below team baseline when `coverage` is enabled (configure in CI when adopted).

---

## Best practices

- Register new features in **`service_locator`** and compose routes in **`AppRouter`** using feature exports (`…Routes.routes`).
- Keep **auth redirect rules** and **auth route paths** consistent: path constants live in the **auth** feature (`AuthRoute`).
- Do not place feature-specific pages in `core/`; keep **core** for infrastructure and shared routing shell only.
- Run **`dart format .`**, **`flutter analyze`**, and tests before opening a PR.
