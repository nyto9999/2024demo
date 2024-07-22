import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:house/main.dart';
import 'package:house/notification/customer/customer_notification.dart';
import 'package:house/post/pages/customer_page/create_post_page.dart';
import 'package:house/post/pages/customer_page/customer_my_posts_page.dart';
import 'package:house/post/methods/customer_post_methods.dart';
import 'package:house/post/methods/master_post_methods.dart';
import 'package:house/post/pages/customer_page/payment_page.dart';
import 'package:house/post/pages/master_page/master_my_order_page.dart';

class PostRepo {
  final PostCustomerMethods customer;
  final PostMasterMethods master;

  PostRepo({required this.customer, required this.master});

  //種類
  Future<QuerySnapshot<Map<String, dynamic>>> getServiceKinds() =>
      firestoreRepo.getServiceKinds();

  ///[UI] [Customer]
  Widget buildCreatePostPage() => const CustomerCreatePostPage();

  Widget buildMyPostsPage() => const CustomerMyPostsPage();

  Widget buildCustomerNotificationPage() => const CustomerNotificationPage();

  Widget buldCustomerCreatePostPage() => const CustomerCreatePostPage();

  Widget buildPaymentPage() => const PaymentPage();

  ///[UI] [Master]
  Widget buildMasterMyOrdersPage() => const MasterMyOrderPage();
}
