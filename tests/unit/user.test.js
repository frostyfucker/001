const User = require('../../src/models/user');

describe('User', () => {
    it('should create a user with the correct properties', () => {
        const user = new User(1, 'Test User', { theme: 'dark' });
        expect(user.id).toBe(1);
        expect(user.name).toBe('Test User');
        expect(user.preferences.theme).toBe('dark');
    });
});
