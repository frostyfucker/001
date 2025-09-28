# Changelog

## 1.0.0 - 2025-09-28

### Added
- Initial project setup for Productivity Intelligence System.
- Core services: TrackingService, PatternRecognitionService, SuggestionService, StorageService.
- Basic GUI with dynamic suggestion display and interaction handling.
- Models for User, WorkPattern, and Suggestion.
- Unit tests for all models and services.
- Integration tests for pattern detection, task recognition, and GUI interaction.
- ESLint and Prettier for code quality and formatting.
- Jest for testing.

### Changed
- Updated `PatternRecognitionService` to detect repeating keypress sequences (A, B, A, B) and specific file open events.
- Refactored `src/gui.js` to export `displaySuggestion` and `removeSuggestion` for testability.
- Modified integration tests to correctly instantiate and utilize services.

### Fixed
- Resolved `TypeError: Cannot read properties of null (reading 'appendChild')` in GUI integration test by ensuring `suggestionsContainer` is correctly referenced.
- Corrected `PatternRecognitionService` logic to accurately detect patterns for integration tests.
- Ensured all unit and integration tests are passing.
