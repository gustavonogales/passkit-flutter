import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kViewType = '<passkit-wallet-button>';

class AddButton extends StatelessWidget {
  final Uint8List pass;

  const AddButton({
    required this.pass,
    Key? key,
  }) : super(key: key);

  Map<String, dynamic> get creationParams => {
        "pass": pass,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: 140,
      height: 50,
      child: UiKitView(
        viewType: _kViewType,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: creationParams,
      ),
    );
  }
}
