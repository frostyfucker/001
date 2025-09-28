import TrackingService from './services/tracking_service.js';
import PatternRecognitionService from './services/pattern_recognition_service.js';
import SuggestionService from './services/suggestion_service.js';

const suggestionsContainer = document.getElementById('suggestions-container');

const trackingService = new TrackingService();
const patternRecognitionService = new PatternRecognitionService(trackingService);
const suggestionService = new SuggestionService(patternRecognitionService);

document.body.addEventListener('click', (event) => {
    trackingService.track({
        type: 'click',
        target: event.target.id,
    });
    updateSuggestions();
});

document.body.addEventListener('keypress', (event) => {
    trackingService.track({
        type: 'keypress',
        key: event.key,
    });
    updateSuggestions();
});

function updateSuggestions() {
    const suggestionsContainer = document.getElementById('suggestions-container'); // Get it here
    suggestionService.generateSuggestions();
    const suggestions = suggestionService.getSuggestions();
    suggestionsContainer.innerHTML = '';
    suggestions.forEach(suggestion => {
        displaySuggestion(suggestionsContainer, suggestion); // Pass container
    });
}


function displaySuggestion(suggestionsContainer, suggestion) { // Added suggestionsContainer parameter
    const suggestionElement = document.createElement('div');
    suggestionElement.id = `suggestion-${suggestion.id}`;
    suggestionElement.innerHTML = `
        <p>${suggestion.content}</p>
        <button id="accept-${suggestion.id}">Accept</button>
        <button id="reject-${suggestion.id}">Reject</button>
    `;
    suggestionsContainer.appendChild(suggestionElement);

    const acceptButton = document.getElementById(`accept-${suggestion.id}`);
    acceptButton.addEventListener('click', () => {
        // Handle accept action
        removeSuggestion(suggestionsContainer, suggestion.id); // Pass container
    });

    const rejectButton = document.getElementById(`reject-${suggestion.id}`);
    rejectButton.addEventListener('click', () => {
        // Handle reject action
        removeSuggestion(suggestionsContainer, suggestion.id); // Pass container
    });
}

function removeSuggestion(suggestionsContainer, suggestionId) { // Added suggestionsContainer parameter
    const suggestionElement = document.getElementById(`suggestion-${suggestionId}`);
    if (suggestionElement) {
        suggestionElement.remove();
    }
}

export { displaySuggestion, removeSuggestion }; // Export the functions