const Suggestion = require('../../src/models/suggestion');

describe('Suggestion', () => {
    it('should create a suggestion with the correct properties', () => {
        const suggestion = new Suggestion(1, 1, 1, 'automation', 'Test suggestion', 'offered');
        expect(suggestion.id).toBe(1);
        expect(suggestion.userId).toBe(1);
        expect(suggestion.patternId).toBe(1);
        expect(suggestion.suggestionType).toBe('automation');
        expect(suggestion.content).toBe('Test suggestion');
        expect(suggestion.status).toBe('offered');
    });
});
