/**
 * Service for handling data persistence using localStorage.
 */
class StorageService {
    constructor() {
        this.storage = localStorage;
    }

    /**
     * Sets an item in localStorage.
     * @param {string} key - The key for the item.
     * @param {any} value - The value to store.
     */
    setItem(key, value) {
        this.storage.setItem(key, JSON.stringify(value));
    }

    /**
     * Retrieves an item from localStorage.
     * @param {string} key - The key of the item to retrieve.
     * @returns {any | null} The retrieved value, or null if not found.
     */
    getItem(key) {
        const item = this.storage.getItem(key);
        return item ? JSON.parse(item) : null;
    }
}

export default StorageService;
