import { firestore } from "firebase-admin"
import * as functions from "firebase-functions"



exports.helloToUser = functions.firestore.document("userData/{userId}").onUpdate(async (snapshot, context) => {


    const data = snapshot.after.data()

   functions.logger.info("User data")
   functions.logger.info(data)

  await firestore().collection("from_cloud_functions").add(data)

   return;

})