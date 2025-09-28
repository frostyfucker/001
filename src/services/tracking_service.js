import StorageService from './storage_service.js';

/**
 * Service for tracking user actions.
 */
class TrackingService {
    constructor() {
        this.storageService = new StorageService();
        this.actions = this.storageService.getItem('actions') || [];
    }

    /**
     * Tracks a user action.
     * @param {object} action - The action to track.
     */
    track(action) {
        this.actions.push(action);
        this.storageService.setItem('actions', this.actions);
    }

    /**
     * Retrieves all tracked actions.
     * @returns {Array<object>} An array of tracked actions.
     */
    getActions() {
        return this.actions;
    }
}

export default TrackingService;