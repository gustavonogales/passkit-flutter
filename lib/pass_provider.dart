import 'dart:typed_data';

import 'package:flutter/services.dart';

const _kSamplePass = 'assets/health_id_card_sample.pkpass';

Future<Uint8List> passProvider() async {
  ByteData pass = await rootBundle.load(_kSamplePass);
  return pass.buffer.asUint8List();
}
