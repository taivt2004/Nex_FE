import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceInfoCollector {
  Map<String, dynamic> deviceData = <String, dynamic>{};

  Future<dynamic> collect() async {
    try {
      if (deviceData.isNotEmpty) {
        return deviceData;
      }
      return deviceData = <String, dynamic>{
        'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      };
    } on PlatformException {
      return <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }
  }

}
