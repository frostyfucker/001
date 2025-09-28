# Tasks: Productivity Intelligence System

**Input**: Design documents from `/specs/001-productivity-intelligence-system/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Single project**: `src/`, `tests/` at repository root

## Phase 3.1: Setup
- [x] T001 Create project structure per implementation plan in `src/` and `tests/`.
- [x] T002 Initialize vanilla JavaScript project (e.g., using npm init) and create basic HTML/CSS/JS files.
- [x] T003 [P] Configure linting and formatting tools (e.g., ESLint, Prettier).
- [x] T004 [P] Research and decide on a testing framework (e.g., Jest, Mocha) and add it to the project. This is based on `research.md`.
- [x] T005 [P] Research and decide on a storage mechanism (e.g., localStorage, IndexedDB) and document the choice. This is based on `research.md`.

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [x] T006 [P] Create integration test for "Pattern Detection and Suggestion" scenario in `tests/integration/test_pattern_detection.js`.
- [x] T007 [P] Create integration test for "Task Recognition" scenario in `tests/integration/test_task_recognition.js`.
- [x] T008 [P] Create integration test for "GUI Interaction" scenario in `tests/integration/test_gui_interaction.js`.

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [x] T009 [P] Implement `User` model in `src/models/user.js`.
- [x] T010 [P] Implement `WorkPattern` model in `src/models/work_pattern.js`.
- [x] T011 [P] Implement `Suggestion` model in `src/models/suggestion.js`.
- [x] T012 Implement `TrackingService` in `src/services/tracking_service.js` to track user actions.
- [x] T013 Implement `PatternRecognitionService` in `src/services/pattern_recognition_service.js` to analyze work patterns.
- [x] T014 Implement `SuggestionService` in `src/services/suggestion_service.js` to generate and manage suggestions.
- [x] T015 Implement `StorageService` in `src/services/storage_service.js` to handle data persistence.
- [x] T016 Implement the basic GUI layout in `index.html` and `style.css`.
- [x] T017 Implement the GUI logic in `src/gui.js` to display suggestions and handle user interactions.

## Phase 3.4: Integration
- [x] T018 Integrate `TrackingService` with the GUI to capture user actions.
- [x] T019 Integrate `PatternRecognitionService` with `TrackingService` to process the collected data.
- [x] T020 Integrate `SuggestionService` with `PatternRecognitionService` and the GUI to display suggestions.
- [x] T021 Integrate `StorageService` with the other services to persist data.

## Phase 3.5: Polish
- [x] T022 [P] Write unit tests for all models in `tests/unit/`.
- [x] T023 [P] Write unit tests for all services in `tests/unit/`.
- [x] T024 [P] Write documentation for all models and services.
- [x] T025 Perform performance testing and optimization to meet the <100ms interaction goal.
- [x] T026 Conduct user acceptance testing based on `quickstart.md`.

## Dependencies
- Tests (T006-T008) before implementation (T009-T017)
- Models (T009-T011) before services (T012-T015)
- Services before integration (T018-T021)
- Core implementation before polish (T022-T026)

## Parallel Example
```
# Launch T006-T008 together:
Task: "Create integration test for Pattern Detection and Suggestion scenario in tests/integration/test_pattern_detection.js"
Task: "Create integration test for Task Recognition scenario in tests/integration/test_task_recognition.js"
Task: "Create integration test for GUI Interaction scenario in tests/integration/test_gui_interaction.js"

# Launch T009-T011 together:
Task: "Implement User model in src/models/user.js"
Task: "Implement WorkPattern model in src/models/work_pattern.js"
Task: "Implement Suggestion model in src/models/suggestion.js"
```
