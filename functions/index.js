const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.loginByPhone = functions.region('asia-east1').https.onCall(async (data, context) => {
  const phoneNumber = data.phoneNumber;
  let userRecord;

  try {
    // 根據電話號碼獲取用戶，處理台灣區號
    const formattedPhoneNumber = phoneNumber.startsWith('0') ? '+886' + phoneNumber.substring(1) : phoneNumber;
    userRecord = await admin.auth().getUserByPhoneNumber(formattedPhoneNumber);

    // 創建自定義令牌
    const customToken = await admin.auth().createCustomToken(userRecord.uid);
    return {token: customToken};
  } catch (error) {
    console.error('Error creating custom token:', error);
    throw new functions.https.HttpsError('internal', error.message);
  }
});
