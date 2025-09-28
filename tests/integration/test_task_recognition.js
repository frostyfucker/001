const TrackingService = require('../../src/services/tracking_service');
const PatternRecognitionService = require('../../src/services/pattern_recognition_service');
const SuggestionService = require('../../src/services/suggestion_service');

describe('Task Recognition', () => {
    it('should recognize a task and provide a suggestion', () => {
        // Simulate user actions (e.g., opening a specific file type)
        const userActions = [
            { type: 'file_open', path: 'report.docx' },
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