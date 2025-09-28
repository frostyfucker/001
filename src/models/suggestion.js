/**
 * Represents a recommendation provided by the system to the user.
 */
class Suggestion {
    /**
     * Creates an instance of Suggestion.
     * @param {number} id - The unique identifier for the suggestion.
     * @param {number} userId - The ID of the user this suggestion is for.
     * @param {number} patternId - The ID of the work pattern that triggered this suggestion.
     * @param {string} suggestionType - The type of suggestion (e.g., "automation", "shortcut").
     * @param {string} content - The content of the suggestion.
     * @param {string} status - The status of the suggestion (e.g., "offered", "accepted", "rejected").
     */
    constructor(id, userId, patternId, suggestionType, content, status) {
        this.id = id;
        this.userId = userId;
        this.patternId = patternId;
        this.suggestionType = suggestionType;
        this.content = content;
        this.status = status;
    }
}

module.exports = Suggestion;