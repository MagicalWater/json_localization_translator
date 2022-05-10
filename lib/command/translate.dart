import 'dart:io';

import 'package:args/args.dart';
import 'package:json_localization_translator/json_localization_translator.dart';

class TranslateCommand {
  final ArgResults argsResult;

  TranslateCommand(this.argsResult);

  Future<void> execute() async {
    verifyArgs();

    final inFile = argsResult['in'] as String;
    final outFile = argsResult['out'] as String;
    final fromLanguage = argsResult['from'] as String;
    final toLanguage = argsResult['to'] as String;

    final parser = JsonValueParser.file(File(inFile));
    parser.parse();
    final translate = await parser.translate(fromLanguage, toLanguage);
    File(outFile).writeAsStringSync(translate);
  }

  /// 驗證輸入參數
  void verifyArgs() {
    final inFile = argsResult['in'] as String?;
    final outFile = argsResult['out'] as String?;
    final fromLanguage = argsResult['from'] as String?;
    final toLanguage = argsResult['to'] as String?;

    if (inFile == null) {
      throw '缺少必要參數(in/i): 來源檔案';
    } else if (!File(inFile).existsSync()) {
      throw '找不到來源檔案';
    }

    if (outFile == null) {
      throw '缺少必要參數(out/o): 輸出檔案';
    }

    if (fromLanguage == null) {
      throw '缺少必要參數(from/f): 來源語系';
    }

    if (toLanguage == null) {
      throw '缺少必要參數(to/t): 目標語系';
    }
  }
}