// FILE: live-api.js
// This file handles all communication with the LIVE backend server.

const LiveAPI = (function() {
    const getApiBaseUrl = () => {
        if (window.location.protocol === 'file:') {
            return 'http://localhost:3000';
        }
        return window.location.origin;
    };

    const API_URL = getApiBaseUrl();

    const resolveAssetUrl = (url) => {
        if (!url) return '';
        if (/^https?:\/\//i.test(url)) return url;
        return `${API_URL}${url}`;
    };

    // A helper function to handle fetch requests and errors
    const request = async (endpoint, options = {}) => {
        try {
            const response = await fetch(`${API_URL}${endpoint}`, options);
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'An unknown server error occurred.');
            }
            if (response.status === 204) return null; // Handle empty responses
            return response.json();
        } catch (error) {
            console.error(`API Error on ${endpoint}:`, error);
            throw error; // Re-throw the error for the calling function to handle
        }
    };

    // --- Public API Methods that will be used by the website ---
    return {
        API_URL, // Expose the base URL so other files can use it for image/audio paths
        resolveAssetUrl,
        getArtists: () => request('/api/artists'),
        getSongs: () => request('/api/songs'),
        getStats: () => request('/api/stats'),
        toggleSongLike: (songId, increment) => request(`/api/songs/${songId}/toggle-like`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ increment })
        }),

        // NEW METHODS
        getBandMembers: () => request('/api/band-members'),
        getVideos: () => request('/api/videos'),

        // The user auth backend is not fully built, so these are simulated
        // but are ready to be connected to real endpoints like '/api/auth/register'
        registerUser: (username, email, password) => {
            console.log("LiveAPI: Simulating user registration for:", { username, email });
            return new Promise(resolve => setTimeout(() => resolve({ id: Date.now(), username, email }), 500));
        },
        loginUser: (email, password) => {
            console.log("LiveAPI: Simulating user login for:", { email });
            return new Promise(resolve => setTimeout(() => resolve({ id: Date.now(), username: 'Live User', email }), 500));
        },
    };
})();