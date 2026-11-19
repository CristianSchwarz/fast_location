import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static Future<void> inicializar() async {
    await Hive.initFlutter();
    await Hive.openBox('historico_enderecos');
  }
}
