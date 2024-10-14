/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Function to delete a user by UID
exports.deleteUserByUID = functions.https.onCall(async (data, context) => {
    const uid = data.uid;

    // Check if the request is authenticated and from an admin
    if (!context.auth || !context.auth.token.admin) {
        throw new functions.https.HttpsError('permission-denied', 'Must be an administrative user to delete a user.');
    }

    try {
        await admin.auth().deleteUser(uid);
        return { message: `Successfully deleted user with UID: ${uid}` };
    } catch (error) {
        throw new functions.https.HttpsError('internal', 'Failed to delete user', error.message);
    }
});

