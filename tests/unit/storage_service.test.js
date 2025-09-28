const StorageService = require('../../src/services/storage_service');

describe('StorageService', () => {
    it('should set and get an item', () => {
        const service = new StorageService();
        const key = 'test';
        const value = { a: 1 };
        service.setItem(key, value);
        expect(service.getItem(key)).toEqual(value);
    });
});
