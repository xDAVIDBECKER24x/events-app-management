import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timestampToDateFormatted(Timestamp timestamp){
  DateTime date = DateTime.parse(timestamp.toDate().toString());
  String dateFormatted = DateFormat(" dd 'de' MMMM ", "pt_BR").format(date);
  return dateFormatted;
}
String timestampToTimeFormatted(Timestamp timestamp){
  DateTime date = DateTime.parse(timestamp.toDate().toString());
  String dateFormatted = DateFormat(" HH:mm ").format(date);
  return dateFormatted;
}
