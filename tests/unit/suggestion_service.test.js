const SuggestionService = require('../../src/services/suggestion_service');
const PatternRecognitionService = require('../../src/services/pattern_recognition_service');
const TrackingService = require('../../src/services/tracking_service');

describe('SuggestionService', () => {
    it('should generate suggestions', () => {
        const trackingService = new TrackingService();
        trackingService.track({ type: 'keypress', key: 'a' });
        trackingService.track({ type: 'keypress', key: 'b' });
        trackingService.track({ type: 'keypress', key: 'a' });
        trackingService.track({ type: 'keypress', key: 'b' });
        const patternRecognitionService = new PatternRecognitionService(trackingService);
        const service = new SuggestionService(patternRecognitionService);
        service.generateSuggestions();
        const suggestions = service.getSuggestions();
        expect(suggestions.length).toBe(1);
    });
});