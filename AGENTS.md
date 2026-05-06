# AGENTS.md

## Workspace Reality
- This repo is a Dart workspace + Melos monorepo, but the live workspace only includes `apps/financial-app`, `packages/core`, `packages/components`, and `packages/features/financial-app/funds` from root `pubspec.yaml`.
- Ignore legacy `client-app` references in `README.md`, `scripts/`, `codecov.yml`, and `codemagic.yaml`; they do not match the current workspace.
- Flutter is pinned via FVM in `.fvmrc` to `3.38.9`.

## Correct Command Flow
- First-time setup: `melos bootstrap`.
- Before analyze/test/web build, generate code with `melos run build:financial-all`. This creates `injectable`, `envied`, Drift, and other generated files across the workspace.
- CI's verified local-safe flow is: `melos bootstrap` -> `melos run build:financial-all` -> `melos run format` -> `melos run analyze` -> `melos run test:coverage`.
- `melos run ci` exists, but it skips the required codegen step and runs `test` instead of `test:coverage`.

## High-Value Commands
- Run the app: `melos run run:financial:web`, `melos run run:financial:mobile`, `melos run run:financial:desktop`.
- Run all tests: `melos run test`.
- Run only app tests: `melos run test:financial`.
- Run one test file: `cd apps/financial-app && flutter test test/features/funds/bloc/funds_bloc_test.dart`.
- Run one test case: `cd apps/financial-app && flutter test test/features/funds/bloc/funds_bloc_test.dart --plain-name "<test name>"`.
- Web Drift setup when needed: `./scripts/setup_web.sh apps/financial-app`.

## Architecture Notes
- App entrypoint is `apps/financial-app/lib/main.dart`; dependency injection is assembled in `apps/financial-app/lib/config/injectable/injectable_dependency.dart`; routing is in `apps/financial-app/lib/config/routes/app_router.dart`.
- `feature_funds` owns the fund and transaction UI/domain/data flow, with routes exposed from `packages/features/financial-app/funds/lib/routes.dart` and mounted by the app router.
- `feature_funds` is not fully standalone: its `pubspec.yaml` depends on `financial_app`, so app and feature boundaries are already coupled.
- Most tests live under `apps/financial-app/test`, including feature BLoC/widget tests; there are currently no `packages/**/test` files.

## Env And Generated Code
- `apps/financial-app/lib/config/env/env.dart` reads all three files: `.env.dev`, `.env.qa`, `.env.prod`. Keep all three present before running `build_runner`.
- Runtime flavor selection is only through `--dart-define=FLAVOR=dev|qa|prod`; switching flavor does not require regenerating code if the env files already exist.
- Web builds that need Drift assets must have `web/sqlite3.wasm` and `web/drift_worker.dart.js`; `scripts/setup_web.sh` downloads/compiles them.

## Conventions That Matter
- Root `analysis_options.yaml` enforces `always_use_package_imports`, strict casts/inference/raw types, single quotes, trailing commas, and excludes generated files from analysis.
- Formatting commands intentionally exclude generated files and `injectable.module.dart`; do not hand-edit generated files.
