import 'translate_type.dart';

class TranslateMap extends TranslateType<Map<String, dynamic>> {
  final Map<String, TranslateType> source;

  static const splitPattern = '\n===\n';

  TranslateMap(this.source);

  @override
  String toTranslateSource() {
    return source.entries
        .map((e) => e.value.toTranslateSource())
        .join(splitPattern);
  }

  @override
  void bindTranslateValue(String locale, String value) {
    final valueList = value.split(splitPattern);
    // print('切割: ${valueList.length}, $valueList');
    for (var i = 0; i < source.entries.length; i++) {
      final entry = source.entries.toList()[i];
      if (entry.value is TranslateMap) {
        final valueData = valueList.sublist(i).join(splitPattern);
        entry.value.bindTranslateValue(locale, valueData);
      } else {
        final valueData = valueList[i];
        entry.value.bindTranslateValue(locale, valueData);
      }
    }
  }

  /// 輸出翻譯後的json
  @override
  Map<String, dynamic> exportJson(String locale) {
    return source.map((key, value) {
      if (value is TranslateMap) {
        final valueJson = value.exportJson(locale);
        return MapEntry(key, valueJson);
      } else if (value is TranslateString) {
        final valueJson = value.exportJson(locale);
        return MapEntry(key, valueJson);
      } else {
        throw '錯誤: 未知型態: $value';
      }
    });
  }
}
