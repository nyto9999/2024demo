importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');


// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
const firebaseConfig = {
  apiKey: 'AIzaSyBksfQyA7Hp5UdLu3v9X_6HxWw77-atZuo',
  authDomain: 'house-ff670.firebaseapp.com',
  databaseURL:
  'https://house-ff670-default-rtdb.asia-southeast1.firebasedatabase.app',
  projectId: 'house-ff670',
  storageBucket: 'house-ff670.appspot.com',
  measurementId: 'G-6K14FM7SHP',
  messagingSenderId: '548071695548',
  appId: '1:548071695548:web:faadd362ec9f68ab1e9cb9',
};

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message: ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: payload.notification.icon,
    data: {
      click_action: payload.notification.click_action || '/',
      txId: payload.data.txId,
    },
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

 