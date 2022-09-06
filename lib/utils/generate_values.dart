import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String sha1RandomString() {
  final randomNumber = Random().nextDouble();
  final randomBytes = utf8.encode(randomNumber.toString());
  final randomString = sha1.convert(randomBytes).toString();
  return randomString;
}
