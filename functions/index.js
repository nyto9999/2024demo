const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendQuoteNotification = functions
    .region('asia-east1') // 将区域设置为亚洲
    .firestore
    .document('transactions/{transactionId}/quotes/{quoteId}')
    .onWrite(async (change, context) => {
      const quoteData = change.after.data();
      const customerId = quoteData.customerId;

      // 获取客户的 FCM Token
      const userDoc = await admin.firestore().collection('userRoles').doc(customerId).get();
      const fcmToken = userDoc.data().fcmToken;

      const payload = {
        notification: {
          title: '新报价通知',
          body: '您的报价已更新',
        },
        token: fcmToken, // 确保包含 token 字段
      };

      // 发送通知
      try {
        await admin.messaging().send(payload);
        console.log('通知发送成功');
      } catch (error) {
        console.error('通知发送失败', error);
      }
    });
