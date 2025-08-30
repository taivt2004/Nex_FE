import 'package:talker/talker.dart';

final talker = Talker(
  settings: TalkerSettings(
    colors: {TalkerKey.info: AnsiPen()..yellow()},
    titles: {
      TalkerKey.exception: 'ex',
      TalkerKey.error: 'e',
      TalkerKey.info: 'i',
      TalkerKey.debug: 'i',
    },
  ),
);
