const TrackingService = require('../../src/services/tracking_service');
const PatternRecognitionService = require('../../src/services/pattern_recognition_service');
const SuggestionService = require('../../src/services/suggestion_service');

describe('Pattern Detection and Suggestion', () => {
    it('should detect a repetitive pattern and create a suggestion', () => {
        // Simulate user actions (e.g., pressing the same key combination multiple times)
        const userActions = [
            { type: 'keypress', key: 'a' },
            { type: 'keypress', key: 'b' },
            { type: 'keypress', key: 'a' },
            { type: 'keypress', key: 'b' },
            { type: 'keypress', key: 'a' },
            { type: 'keypress', key: 'b' },
        ];

        // Process the actions
        const trackingService = new TrackingService();
        userActions.forEach(action => trackingService.track(action));

        // Check if a suggestion is created
        const patternRecognitionService = new PatternRecognitionService(trackingService);
        const suggestionService = new SuggestionService(patternRecognitionService);
        suggestionService.generateSuggestions(); // Generate suggestions based on patterns
        const suggestions = suggestionService.getSuggestions();
        expect(suggestions.length).toBe(1);
        expect(suggestions[0].content).toBe('You seem to be repeating an action. Would you like to automate this?');
    });
});