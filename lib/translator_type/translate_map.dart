import 'translate_type.dart';
import 'package:collection/collection.dart';

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
    loopMatchValue(locale, valueList);
    // // print('切割: ${valueList.length}');
    // print('source = ${source}');
    // final splitIndex = 0;
    // for (var i = 0; i < source.entries.length; i++) {
    //   final entry = source.entries.toList()[i];
    //   if (entry.value is TranslateMap) {
    //     final valueData = valueList.sublist(i).join(splitPattern);
    //     print('進入: ${entry.key}, 夾帶: ${valueData}, $i');
    //     entry.value.bindTranslateValue(locale, valueData);
    //   } else {
    //     final valueData = valueList[i];
    //     print('尋找: ${entry.key} => $valueData');
    //     entry.value.bindTranslateValue(locale, valueData);
    //   }
    // }
  }

  @override
  List<String> loopMatchValue(String locale, List<String> valueList) {
    var copyList = List<String>.from(valueList);
    for (var i = 0; i < source.entries.length; i++) {
      final entry = source.entries.toList()[i];
      final entryValue = entry.value;
      copyList = entryValue.loopMatchValue(locale, copyList);
    }
    return copyList;
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
