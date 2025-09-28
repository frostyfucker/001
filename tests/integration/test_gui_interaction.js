const { displaySuggestion, removeSuggestion } = require('../../src/gui');

describe('GUI Interaction', () => {
    let suggestionsContainer;

    beforeEach(() => {
        // Set up the DOM before each test
        document.body.innerHTML = '<div id="suggestions-container"></div>';
        suggestionsContainer = document.getElementById('suggestions-container');
    });

    it('should display a suggestion and handle user feedback', () => {
        // Create a suggestion
        const suggestion = {
            id: 1,
            content: 'Test suggestion',
        };

        // Display the suggestion
        displaySuggestion(suggestionsContainer, suggestion); // Pass container

        // Simulate user feedback
        const acceptButton = document.getElementById(`accept-${suggestion.id}`);
        acceptButton.click();

        // Check if the suggestion is removed from the GUI
        expect(suggestionsContainer.innerHTML).toBe('');
    });
});
