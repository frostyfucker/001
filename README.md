# Productivity Intelligence System
[![Deploy to GitHub Pages](https://github.com/frostyfucker/001/actions/workflows/deploy.yml/badge.svg)](https://github.com/frostyfucker/001/actions/workflows/deploy.yml)
This project is a **Productivity Intelligence System** designed to learn from user work patterns and provide intelligent suggestions through a minimalist Graphical User Interface (GUI).

## Core Components:

1.  **TrackingService (`src/services/tracking_service.js`):**
    *   Captures user interactions (clicks, keypresses) from the `document.body`.
    *   Persists these actions using `StorageService` (localStorage).

2.  **PatternRecognitionService (`src/services/pattern_recognition_service.js`):**
    *   Analyzes tracked actions to identify repetitive work patterns.
    *   Currently detects two types of patterns:
        *   Repeating sequences of two keypress actions (e.g., `a, b, a, b`).
        *   Specific file open events (e.g., `report.docx`).

3.  **SuggestionService (`src/services/suggestion_service.js`):**
    *   Generates suggestions based on identified patterns from `PatternRecognitionService`.
    *   Manages a list of active suggestions, persisting them via `StorageService`.

4.  **StorageService (`src/services/storage_service.js`):**
    *   Provides a simple interface for persisting and retrieving data using `localStorage`.

5.  **GUI Logic (`src/gui.js`):**
    *   Initializes and integrates the `TrackingService`, `PatternRecognitionService`, and `SuggestionService`.
    *   Listens for user input (clicks, keypresses) and triggers pattern analysis and suggestion generation.
    *   Dynamically displays suggestions in the `suggestions-container` element in `index.html`.
    *   Handles user feedback (accept/reject) on suggestions, removing them from the display.

6.  **Models (`src/models/user.js`, `src/models/work_pattern.js`, `src/models/suggestion.js`):**
    *   Simple JavaScript classes representing the core data structures of the system.

7.  **User Interface (`index.html`, `style.css`):**
    *   `index.html`: Provides the basic HTML structure, including the `suggestions-container` where dynamic suggestions are displayed.
    *   `style.css`: Implements a minimalist, "Invisible Design" aesthetic, focusing on efficiency and clarity.

## How to Use (Development/Testing):

1.  **Clone the repository:** (Assuming this is a git repository)
    ```bash
    git clone <repository-url>
    cd daily-workflow
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    ```
3.  **Open `index.html` in a web browser:**
    *   Simply open the `index.html` file located in the project root with your preferred web browser.
    *   The GUI will load, and as you interact with the page (clicks, keypresses), the system will start tracking your actions.
    *   If you perform a recognized pattern (e.g., repeatedly type "ab" or open a file named "report.docx"), suggestions should appear in the designated container.

4.  **Run Tests:**
    ```bash
    npm test
    ```
    *   This will execute all unit and integration tests, ensuring the core logic and interactions are functioning as expected. All tests should now pass.

## Next Steps / Further Development:

*   **Enhance Pattern Recognition:** The current `PatternRecognitionService` is basic. It can be extended to detect more complex patterns, sequences, and context-aware behaviors.
*   **Refine Suggestion Logic:** Improve the relevance and variety of suggestions. Implement a feedback loop where user acceptance/rejection influences future suggestions.
*   **Advanced Storage:** For more complex data or cross-device synchronization, consider integrating with a backend database or a more robust client-side storage solution like IndexedDB.
*   **User Management:** Implement proper user authentication and management if multiple users are to be supported.
*   **Customization:** Allow users to customize patterns, suggestions, and GUI appearance.
*   **Accessibility:** Ensure the GUI is accessible to users with disabilities.
