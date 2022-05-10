import 'package:json_localization_translator/command/translate.dart';
import 'package:json_localization_translator/json_localization_translator.dart';

void main(List<String> arguments) async {
  final action = CommandAction(arguments);
  switch (action.action) {
    case CommandAction.helpArg:
      printHelp();
      break;
    case CommandAction.translateArg:
      // 取得輸入的檔案
      await TranslateCommand(action.result).execute();
      break;
  }
}
