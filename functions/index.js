const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
// 所有tx qoutes的变化都会触发这个函数
// 假设每小时有 1000 次任意 transactions/{transactionId}/quotes/{quoteId} 文档的变更触发 Cloud Function：

// 每次触发 Cloud Function 的费用（256 MB 内存，2.5 秒）：

// 每次操作费用：0.0016 USD ≈ 0.048 TWD
// 每小时操作费用（1000 次）：0.0016 USD * 1000 ≈ 50.4 TWD
// Firestore 操作费用：

// 读取次数：1000 次，费用：1000 * 0.0054 TWD ≈ 5.4 TWD
// 写入次数：2000 次（每次操作 2 次写入），费用：2000 * 0.0324 TWD ≈ 64.8 TWD
// 总费用：

// Cloud Function 总费用：50.4 TWD
// Firestore 总费用：70.2 TWD
// 每小时总费用：120.6 TWD
// 每天总费用：120.6 TWD * 24 ≈ 2,894.4 TWD
// 每月总费用：120.6 TWD * 24 * 30 ≈ 86,832 TWD
exports.sendQuoteNotification = functions
    .region('asia-east1')
    .firestore
    .document('transactions/{transactionId}/quotes/{quoteId}')
    .onWrite(async (change, context) => {
      const quoteData = change.after.exists ? change.after.data() : null;
      const previousQuoteData = change.before.exists ? change.before.data() : null;
      const customerId = quoteData ? quoteData.customerId : previousQuoteData.customerId;
      const txId = context.params.transactionId;
      let messageTitle;
      let messageBody;

      if (!change.before.exists) {
        // Document was created
        messageTitle = '新报价通知';
        messageBody = `您有一个新的报价，金额为：${quoteData.quoteAmount} 元'`;
      } else if (change.before.exists && change.after.exists) {
        // Document was updated
        messageTitle = '报价更新通知';
        messageBody = `您的报价已更新，从 ${previousQuoteData.quoteAmount} 元变为 ${quoteData.quoteAmount} 元`;
      } else if (!change.after.exists) {
        // Document was deleted
        messageTitle = '报价删除通知';
        messageBody = '您的报价已被删除';
      }

      // 获取客户的 FCM Token
      const userDoc = await admin.firestore().collection('userRoles').doc(customerId).get();
      const fcmToken = userDoc.data().fcmToken;

      const payload = {
        notification: {
          title: messageTitle,
          body: messageBody,
        },
        data: {
          txId: txId,
        },
        token: fcmToken,
      };

      // 发送通知
      try {
        await admin.messaging().send(payload);
        console.log('消息存储成功');
      } catch (error) {
        console.error('通知发送失败', error);
      }
    });
