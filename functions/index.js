const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
    .document("chat/{message}")
    .onCreate((snapshot, context) => {
      admin.messaging().sendToTopic("chat", {
        notification: {
          title: snapshot.data().userName,
          body: snapshot.data().text,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      });
    });
