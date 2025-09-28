const TrackingService = require('../../src/services/tracking_service');

describe('TrackingService', () => {
    it('should track an action', () => {
        const service = new TrackingService();
        const action = { type: 'keypress', key: 'a' };
        service.track(action);
        expect(service.getActions()).toEqual([action]);
    });
});
