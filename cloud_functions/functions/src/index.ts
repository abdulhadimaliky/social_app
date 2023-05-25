import { firestore } from "firebase-admin"
import * as functions from "firebase-functions"

import * as admin from "firebase-admin";
import { Message } from "firebase-admin/lib/messaging/messaging-api";

admin.initializeApp()



exports.helloToUser = functions.firestore.document("userData/{userId}").onUpdate(async (snapshot, context) => {


    const data = snapshot.after.data()

    functions.logger.info("User data")
    functions.logger.info(data)

    await firestore().collection("from_cloud_functions").add(data)

    return;

})

"/userData/G2WuxOcv0CSsFq5t3z49i6r3QNJ3/inbox/G2WuxOcv0CSsFq5t3z49i6r3QNJ3_kJy27LMelaZo1aHZ8B1zjcZ6ow23/messages"

exports.onSendMessage = functions.firestore
    .document('userData/{userId}/inbox/{inboxId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {

        const userId = context.params.userId;
        const inboxId = context.params.inboxId;
        const messageId = context.params.messageId;

        const message = snapshot.data();


        // ID is composed of two user ids. For current user in context where the message is created,
        // the ID of the inbox is composed in such a way that the current user id is placed first
        // followed by the other user id that the user is message
        // ID nomenclature - currentUser_otherUserId

        // Same is the case for other user. When looked, the document is supposed to [otherUsrId_currentUserId]


        // Here, the message sender is in context. So message sender is taken as "Current user" or "My user"
        const userIds = inboxId.split("_")

        const otherUserId = userIds[1]

        const myUserDoc = await firestore().collection("userData").doc(userId).get();
        const otherUserDoc = await firestore().collection("userData").doc(otherUserId).get();

        const myUser = myUserDoc.data()!
        const otherUser = otherUserDoc.data()!;



        // Other user inbox id by placing otherUserId first and current user id last
        const otherInboxId = `${otherUserId}_${userId}`;


        // Setting the message document for the Other users under inbox collection
        await firestore().collection("userData")
            .doc(otherUserId)
            .collection("inbox")
            .doc(otherInboxId)
            .collection("messages")
            .doc(messageId)
            .set(message);



        // Getting current user inbox document 
        const myInboxDoc = await firestore().collection("userData").doc(userId).collection("inbox").doc(inboxId).get();
        const now = new Date()
        now.setDate(now.getDate() - 1)

        // Checks whether or not current inbox document exists or not and do appropriately
        if (myInboxDoc.exists) {
            //TODO: 
            // only update some particular fields in case inbox already exists for CURRENT user

            const myInbox = myInboxDoc.data()!;

            myInbox["lastMessage"] = message;
            myInbox["lastUpdatedAt"] = new Date()

            await firestore().collection("userData").doc(userId).collection("inbox").doc(inboxId).update(myInbox);
        } else {

            // Create the inbox document for Current user

            const myInboxUser = {
                "inboxId": inboxId,
                "inboxUser": {
                    "userId": otherUserId,
                    "userName": otherUser["userName"],
                    "userProfileUrl": otherUser["profilePicture"]
                },
                "lastMessage": message,
                "lastOpenedByUserAt": now,
                "lastUpdatedAt": new Date(),
                "unreadMessagesCount": 0,
            }
            await firestore().collection("userData").doc(userId).collection("inbox").doc(inboxId).set(myInboxUser);
        }
        const otherInboxDoc = await firestore().collection("userData").doc(otherUserId).collection("inbox").doc(otherInboxId).get();

        if (otherInboxDoc.exists) {
            //TODO: Update the other inbox items

            const otherInbox = otherInboxDoc.data()!;

            //Updating particular field in case of inbox document already exists for OTHER user
            otherInbox["lastMessage"] = message;
            otherInbox["lastUpdatedAt"] = new Date()

            // Unread count is incremented because the message is considered as unread for OTHER user
            // Note that the unreadCount should only be updated for the OTHER that means
            // Sender Id should be equal to the userId in the params

            if (message["senderId"] == userId) {

                otherInbox["unreadMessagesCount"]++;
            }

            await firestore().collection("userData").doc(otherUserId).collection("inbox").doc(otherInboxId).update(otherInbox);

        } else {
            // Create the inbox document for OTHER user
            const otherInboxUser = {
                "inboxId": otherInboxId,
                "inboxUser": {
                    "userId": userId,
                    "userName": myUser["userName"],
                    "userProfileUrl": myUser["profilePicture"]
                },
                "lastMessage": message,
                "lastOpenedByUserAt": new Date(),
                "lastUpdatedAt": new Date(),
                "unreadMessagesCount": 1,
            }

            await firestore().collection("userData").doc(otherUserId).collection("inbox").doc(otherInboxId).set(otherInboxUser);

        }
       
        const notificationMessage: Message = {
            "token": otherUser["deviceToken"],
            "data":  {
                title: myUser["userName"],
                body: message["messageText"],
                
            },
            "notification": {
                title: myUser["userName"],
                body: message["messageText"],
            },
        }

        admin.messaging().send(notificationMessage)
    })