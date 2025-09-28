/**
 * Represents a recurring sequence of actions performed by a user.
 */
class WorkPattern {
    /**
     * Creates an instance of WorkPattern.
     * @param {number} id - The unique identifier for the pattern.
     * @param {number} userId - The ID of the user this pattern belongs to.
     * @param {Array<object>} actions - A sequence of actions that constitute the pattern.
     * @param {number} frequency - How often the pattern occurs.
     * @param {string} context - The context in which the pattern typically occurs.
     */
    constructor(id, userId, actions, frequency, context) {
        this.id = id;
        this.userId = userId;
        this.actions = actions;
        this.frequency = frequency;
        this.context = context;
    }
}

module.exports = WorkPattern;