import 'dart:convert';
import 'dart:io';

import 'package:json_localization_translator/translator_type/translate_type.dart';
import 'package:translator/translator.dart';

class JsonValueParser {
  final String _jsonString;

  TranslateMap? _parseData;

  JsonValueParser.file(File jsonFile)
      : _jsonString = jsonFile.readAsStringSync();

  void parse() {
    final jsonObject = json.decode(_jsonString) as Map<String, dynamic>;
    _parseData = TranslateMap(_parseMap(jsonObject));
  }

  /// 開始進行翻譯
  Future<String> translate(String fromLanguage, String toLanguage) async {
    if (_parseData == null) {
      throw '沒有可供翻譯的資料, 請先執行JsonValueParser.parse()';
    }
    final googleTranslator = GoogleTranslator();

    final splitSource = _splitTranslateText(
      _parseData!.toTranslateSource(),
      500,
    );

    // print('翻譯文本: ${splitSource}');
    final splitTranslate = <String>[];

    // google翻譯有上限, 需要針對文字作分段
    for (final source in splitSource) {
      try {
        final translateValue = await googleTranslator.translate(
          source,
          from: fromLanguage,
          to: toLanguage,
        );
        // print('翻譯文字: ${translateValue.text}');
        splitTranslate.add(translateValue.text);
        Future.delayed(Duration(seconds: 1));
      } catch (e) {
        print('翻譯出現錯誤: $e');
        splitTranslate.add(source);
      }
    }

    // final translateValue = await googleTranslator.translate(
    //   aa,
    //   from: fromLanguage,
    //   to: toLanguage,
    // );

    // print('分割量: ${splitTranslate.length}');
    // for (var s in splitTranslate) {
    //   print(s);
    // }
    // print('組合後: ${splitTranslate.join(TranslateMap.splitPattern)}');


    // print('原始');
    // print('========');
    // print(_parseData?.source.values.map((e) => e.toTranslateSource()));
    // print('\n\n\n\n');
    // print('翻譯結果 to en');
    // print('========');
    // print(splitTranslate);

    _parseData!.bindTranslateValue(
      toLanguage,
      splitTranslate.join(TranslateMap.splitPattern),
    );

    final data = JsonEncoder.withIndent('  ')
        .convert(_parseData!.exportJson(toLanguage));
    // print('打印翻譯後的json');
    // print('========');
    // print(data);
    return data;
  }

  Map<String, TranslateType> _parseMap(Map<String, dynamic> jsonObject) {
    return jsonObject.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, TranslateMap(_parseMap(value)));
      } else {
        final valueString = value as String;
        return MapEntry(key, TranslateString(valueString));
      }
    });
  }

  /// 因為google翻譯有上限, 所以要針對翻譯文本做切割
  /// 剛好可以拿 [TranslateMap.splitPattern] 過來使用
  /// [splitLength] - 需要切割的長度
  List<String> _splitTranslateText(String source, int splitLength) {
    // 切割後的列表
    final allList = <String>[];

    // 將翻譯文本再次依照分段切割
    final sourceList = source.split(TranslateMap.splitPattern);
    // print('分割: $sourceList');

    // 當前累積的文本列表
    final currentList = <String>[];
    int currentLength = 0;
    for (final text in sourceList) {
      if (currentLength + text.length > splitLength) {
        // print('切割: $currentLength');
        if (currentList.isEmpty) {
          currentLength += text.length;
          currentList.add(text);
        } else {
          allList.add(currentList.join(TranslateMap.splitPattern));
          currentLength = text.length;
          currentList
            ..clear()
            ..add(text);
        }
      } else {
        currentLength += text.length;
        currentList.add(text);
      }
    }
    if (currentList.isNotEmpty) {
      allList.add(currentList.join(TranslateMap.splitPattern));
    }
    return allList;
  }
}
