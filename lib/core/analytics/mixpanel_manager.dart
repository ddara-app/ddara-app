import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    _instance ??= await Mixpanel.init(
      dotenv.get('MIXPANEL_PROJECT_TOKEN'),
      trackAutomaticEvents: false,
    );
    return _instance!;
  }

  /// init() 이후에만 접근 가능하다.
  static Mixpanel get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError('MixpanelManager.init()이 호출되지 않았습니다.');
    }
    return instance;
  }
}
