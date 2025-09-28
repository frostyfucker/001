/**
 * Represents a user of the system.
 */
class User {
    /**
     * Creates an instance of User.
     * @param {number} id - The unique identifier for the user.
     * @param {string} name - The name of the user.
     * @param {object} [preferences={}] - User-specific settings.
     */
    constructor(id, name, preferences = {}) {
        this.id = id;
        this.name = name;
        this.preferences = preferences;
    }
}

module.exports = User;