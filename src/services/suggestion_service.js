import Suggestion from '../models/suggestion.js';
import StorageService from './storage_service.js';

/**
 * Service for generating and managing suggestions.
 */
class SuggestionService {
    /**
     * Creates an instance of SuggestionService.
     * @param {object} patternRecognitionService - The PatternRecognitionService instance.
     */
    constructor(patternRecognitionService) {
        this.patternRecognitionService = patternRecognitionService;
        this.storageService = new StorageService();
        this.suggestions = this.storageService.getItem('suggestions') || [];
    }

    /**
     * Generates suggestions based on identified patterns.
     */
    generateSuggestions() {
        const patterns = this.patternRecognitionService.analyze();
        patterns.forEach(pattern => {
            const suggestion = new Suggestion(
                this.suggestions.length + 1,
                pattern.userId,
                pattern.id,
                'automation',
                `You seem to be repeating an action. Would you like to automate this?`,
                'offered'
            );
            this.suggestions.push(suggestion);
        });
        this.storageService.setItem('suggestions', this.suggestions);
    }

    /**
     * Retrieves all generated suggestions.
     * @returns {Array<Suggestion>} An array of suggestions.
     */
    getSuggestions() {
        return this.suggestions;
    }
}

export default SuggestionService;