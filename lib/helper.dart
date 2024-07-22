import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Page getPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
  );
}

//timestamp to date

DateTime? timestampToDate(Map<String, dynamic> map, String key) {
return  map[key] != null ? (map[key] as Timestamp).toDate() : null;
}


Timestamp? dateToTimestamp(DateTime? date) {
return date != null ? Timestamp.fromDate(date) : null;
}

 

//extendsion fieldvalue to date


 
enum MapType {
  serverTimestamp,
  dateTime

}