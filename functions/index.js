const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({ origin: true });
const moment = require("moment");
admin.initializeApp();

exports.createUserOnRequest = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    const user = {
      email: req.body.email,
      password: req.body.password,
    };

    const createdUser = await admin
      .auth()
      .createUser(user)
      .then((userRecord) => {
        return userRecord.toJSON();
      })
      .catch((error) => {
        res.status;
      });
    const userBody = req.body;
    await admin
      .firestore()
      .collection("users")
      .doc(createdUser.uid)
      .set({
        ...userBody,
        id: createdUser.uid,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    res.send(createdUser);
  });
});

exports.visitorOnCheckOut = functions.firestore
  .document("visitors/{visitorId}")
  .onUpdate(async (change, context) => {
    const visitor = change.after.data();
    const visitorBefore = change.before.data();
    if (
      (visitor.visitorPass !== null && visitorBefore.pass == null) ||
      visitor.visitorPass !== visitorBefore.visitorPass ||
      visitor.check_in !== visitorBefore.check_in
    ) {
      const message = {
        channelId: "b98966ab-3f58-4b20-8393-90ce8b5f8f38",
        to: visitor.phone.replace("-", ""),
        type: "hsm",
        content: {
          hsm: {
            namespace: "03ee105d_e2a4_4260_b403_7ab5046f62d2",
            templateName: "check_in",
            language: { policy: "deterministic", code: "en" },
            components: [
              {
                type: "header",
                parameters: [
                  {
                    type: "image",
                    image: {
                      url: visitor.visitorPass,
                    },
                  },
                ],
              },
              {
                type: "body",
                parameters: [
                  { type: "text", text: visitor.department },
                  { type: "text", text: visitor.company },
                  {
                    type: "text",
                    text: moment(visitor.check_in).format(
                      "MMMM Do YYYY, h:mm a"
                    ),
                  },
                ],
              },
            ],
          },
        },
      };

      await admin.firestore().collection("messages").add(message);
    }

    if (
      visitor.check_out !== null &&
      visitor.check_out !== visitorBefore.check_out
    ) {
      //Add message to messages collection
      const message = {
        channelId: "b98966ab-3f58-4b20-8393-90ce8b5f8f38",
        to: visitor.phone.replace("-", ""),
        type: "hsm",
        content: {
          hsm: {
            namespace: "03ee105d_e2a4_4260_b403_7ab5046f62d2",
            templateName: "check_out",
            language: {
              policy: "deterministic",
              code: "en",
            },
            params: [
              { default: visitor.department },
              { default: visitor.company },
              {
                default: moment(visitor.check_in).format(
                  "MMMM Do YYYY, h:mm a"
                ),
              },
            ],
          },
        },
      };

      await admin.firestore().collection("messages").add(message);
    }
  });

exports.visitorOnCheckIn = functions.firestore
  .document("visitors/{visitorId}")
  .onCreate(async (snapshot, context) => {
    const visitor = snapshot.data();

    //Add message to messages collection
  });
