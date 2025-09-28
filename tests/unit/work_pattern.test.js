const WorkPattern = require('../../src/models/work_pattern');

describe('WorkPattern', () => {
    it('should create a work pattern with the correct properties', () => {
        const actions = [{ type: 'keypress', key: 'a' }];
        const pattern = new WorkPattern(1, 1, actions, 1, 'general');
        expect(pattern.id).toBe(1);
        expect(pattern.userId).toBe(1);
        expect(pattern.actions).toEqual(actions);
        expect(pattern.frequency).toBe(1);
        expect(pattern.context).toBe('general');
    });
});
