import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

function sendDeviceNotification(candidateName: string, owner: string, token: string, journeyName: string, extraData: any) {

	const payload: admin.messaging.MessagingPayload = {
		notification: {
			title: 'LineUp: Action for ' + candidateName,
			body: 'Hello ' + owner + ', you need to process '+ candidateName + ' for ' + journeyName,
			click_action: 'FLUTTER_NOTIFICATION_CLICK'
		},
data: {
'candidate_id': extraData.get('id')
}
	};

	return fcm.sendToDevice(token, payload);
}

function findDeviceToken(candidateName: string, owner: string, ownerEmailId: string, journeyName: string, data: any) {

	// find owner FCM token
	db.collection('users')
		.where('email', '==', ownerEmailId).get()
		.then(snapshot => {
			if (snapshot.empty) {
				console.log('No matching documents.');
				return;
			}

			snapshot.forEach(user => {
				let token = user.get('token');
				if (token != null) {
					sendDeviceNotification(candidateName, owner, token, journeyName, data);
				}
			});
		})
		.catch(err => {
			console.log('Error getting documents', err);
		});

}

function onCandidateDataChange(candidate: any) {

	let candidateName = candidate.get("name");
	let journies = candidate.get("journey");

	for (let journey of journies) {

		// check journey validity

		// Get journey details

		let journeyName = journey.name;
		let owner = journey.owner;
		let ownerEmailId = journey.owner_email_id;
		let status = journey.status;
		let started_on = journey.started_on;
		let expiry = started_on + 10000;
		// check if journey status is current and latest modified

console.log('started_on : ', started_on);
console.log('expiry : ', expiry);
console.log('Date.now() : ', Date.now());

		if (status == 'current' && Date.now() < expiry) {
			// prepare notification for owner
			findDeviceToken(candidateName, owner, ownerEmailId, journeyName, candidate);
		}
	}
}

exports.sendToDevice = functions.firestore
	.document('/candidate/{documentId}')
	.onWrite((change, context) => {

		let documentId = context.params.documentId;
		db.collection('candidate').doc(documentId).get().then(doc => {
			onCandidateDataChange(doc);

		});

	});