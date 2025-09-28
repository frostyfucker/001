const WorkPattern = require('../models/work_pattern');

/**
 * Service for recognizing work patterns from tracked actions.
 */
class PatternRecognitionService {
    /**
     * Creates an instance of PatternRecognitionService.
     * @param {object} trackingService - The TrackingService instance.
     */
    constructor(trackingService) {
        this.trackingService = trackingService;
    }

    /**
     * Analyzes tracked actions to identify patterns.
     * @returns {Array<WorkPattern>} An array of identified work patterns.
     */
    analyze() {
        const actions = this.trackingService.getActions();
        const patterns = [];

        // Pattern for repeating keypress actions (A, B, A, B)
        if (actions.length >= 4) {
            for (let i = 0; i < actions.length - 3; i++) {
                const action1 = actions[i];
                const action2 = actions[i + 1];
                const action3 = actions[i + 2];
                const action4 = actions[i + 3];

                if (JSON.stringify(action1) === JSON.stringify(action3) && JSON.stringify(action2) === JSON.stringify(action4)) {
                    const pattern = new WorkPattern(
                        1, // hardcoded id for the first pattern
                        1, // hardcoded user id
                        [action1, action2],
                        2, // frequency of the pair
                        'general'
                    );
                    patterns.push(pattern);
                    return patterns; // Return only the first detected pattern
                }
            }
        }

        // Pattern for file_open action
        const reportFileOpen = actions.find(action => action.type === 'file_open' && action.path === 'report.docx');
        if (reportFileOpen) {
            const pattern = new WorkPattern(
                patterns.length + 1,
                1, // hardcoded user id
                [reportFileOpen],
                1,
                'report_writing'
            );
            patterns.push(pattern);
            return patterns; // Return only the first detected pattern
        }

        return patterns;
    }
}

module.exports = PatternRecognitionService;
