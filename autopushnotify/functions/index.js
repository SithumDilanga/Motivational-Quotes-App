const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);

var msgData;

exports.messageTrigger = functions.firestore.document(
    'images/{imageId}'
).onCreate(async (snapshot, context) => {

    if (snapshot.empty){
        console.log('No Devices');
        return;
    }

    var tokens = [];

    msgData = snapshot.data(); 

    const deviceTokens = await admin.firestore().collection('pushtokens').get();

    for (var token of deviceTokens.docs){
        tokens.push(token.data().devtoken);
    } 

    var payload = {
        notification:{
            title: 'Motivational Quotes',
            body: 'New Motivational Quote Available',
            sound: 'default'
        },

        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            message: msgData.location
        }
    };

    try {
        //const response = await admin.messaging().sendToDevice(tokens, payload);

        const promises = [];

        for (let i = 0; i < tokens.length; i += 1000) {
            const newTokens = tokens.slice(i, i + 1000);
        
            // using await to wait for sending to 1000 token
            //const response = await admin.messaging().sendToDevice(tokens, payload);
            promises.push(admin.messaging().sendToDevice(newTokens, payload));
        }

        const responses = await Promise.all(promises);

        console.log('Notification sent succesfully');
    } catch (err){
        console.log('Error sending notification');
        console.log(err);
    }

})
