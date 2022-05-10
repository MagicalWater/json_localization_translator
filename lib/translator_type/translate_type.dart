export 'translate_map.dart';
export 'translate_string.dart';

abstract class TranslateType<T> {
  final translate = <String, String>{};

  /// 輸出要進行翻譯的字串值
  String toTranslateSource();

  /// 綁定翻譯後的字串值
  void bindTranslateValue(String locale, String value);

  T exportJson(String locale);
}
