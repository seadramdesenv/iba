import 'package:flutter/foundation.dart';

class Globals {
  static const String apiBaseUrl = kReleaseMode
      ? 'http://46.202.148.41:8080/api'
      : 'http://localhost:8080/api';
}