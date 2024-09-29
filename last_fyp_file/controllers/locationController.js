// controllers/locationController.js
const axios = require('axios');

const GOOGLE_API_KEY = 'AIzaSyDpk7Ppr4lybxJDOIs-sSzQuRlRhHeSfKQ'; // Replace with your actual Google Places API key

// Function to handle the autocomplete request
const autocomplete = async (req, res) => {
    const searchText = req.query.search_text;

    // Construct the request URL for the Google Places API
    const url = `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${encodeURIComponent(searchText)}&key=${GOOGLE_API_KEY}`;

    try {
        // Make the request to the Google Places API
        const response = await axios.get(url);
        const data = response.data; // Parse the JSON response

        // Check if the request was successful
        if (data.status === 'OK') {
            return res.json({
                success: true,
                data: data.predictions,
            });
        } else {
            return res.status(400).json({
                success: false,
                message: data.error_message || 'An error occurred',
            });
        }
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: 'Internal Server Error',
        });
    }
};

// Export the controller functions
module.exports = {
    autocomplete,
};
