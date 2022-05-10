import 'translate_type.dart';

class TranslateString extends TranslateType<String> {
  final String source;

  TranslateString(this.source);

  @override
  String toTranslateSource() {
    return source;
  }

  @override
  void bindTranslateValue(String locale, String value) {
    translate[locale] = value;
  }

  @override
  String exportJson(String locale) {
    return translate[locale]!.trim();
  }
}
