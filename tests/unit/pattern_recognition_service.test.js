const PatternRecognitionService = require('../../src/services/pattern_recognition_service');
const TrackingService = require('../../src/services/tracking_service');

describe('PatternRecognitionService', () => {
    it('should analyze patterns', () => {
        const trackingService = new TrackingService();
        trackingService.track({ type: 'keypress', key: 'a' });
        trackingService.track({ type: 'keypress', key: 'b' });
        trackingService.track({ type: 'keypress', key: 'a' });
        trackingService.track({ type: 'keypress', key: 'b' });
        const service = new PatternRecognitionService(trackingService);
        const patterns = service.analyze();
        expect(patterns.length).toBe(1);
    });
});