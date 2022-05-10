import 'package:args/args.dart';

class ArgGroup {
  final String title;
  final String name;
  final List<ActionArg> args;
  final String? example;
  final String? description;

  final String _intent = '  ';

  const ArgGroup({
    required this.title,
    this.description,
    required this.name,
    this.args = const [],
    this.example,
  });

  @override
  String toString() {
    var optionList = args.where((e) => !e.isFlag && !e.hide).toList();
    var flagList = args.where((e) => e.isFlag && !e.hide).toList();

    var text = '''
$title
$_intent命令: $name
''';

    if (description != null && description!.isNotEmpty) {
      text += '$_intent說明:\n';
      text += '$_intent$_intent$description\n\n';
    }

    if (optionList.isNotEmpty) {
      text += '$_intent參數:';
      for (var e in optionList) {
        text += '\n${e.toString()}';
      }
      text += '\n';
    }

    if (flagList.isNotEmpty) {
      text += '${_intent}Flag:';
      for (var e in flagList) {
        text += '\n${e.toString()}';
      }
      text += '\n';
    }

    if (example != null) {
      text += '\n$_intent範例:\n$example';
    }

    return text;
  }

  ArgParser toParser() {
    var parser = ArgParser();
    var optionList = args.where((e) => !e.isFlag).toList();
    var flagList = args.where((e) => e.isFlag).toList();

    for (var e in optionList) {
      parser.addOption(e.name, abbr: e.abbr, help: e.help, hide: e.hide);
    }
    for (var e in flagList) {
      parser.addFlag(e.name, abbr: e.abbr, help: e.help, hide: e.hide);
    }
    return parser;
  }
}

class ActionArg {
  final String name;
  final String? abbr;
  final String help;
  final String? expandHelp;
  final bool isFlag;
  final String _intent = '    ';
  final bool hide;

  const ActionArg.option({
    required this.name,
    this.abbr,
    required this.help,
    this.expandHelp,
    this.hide = false,
  }) : isFlag = false;

  const ActionArg.flag({
    required this.name,
    this.abbr,
    required this.help,
    this.expandHelp,
    this.hide = false,
  }) : isFlag = true;

  @override
  String toString() {
    String arg;
    if (abbr != null) {
      arg = '$_intent--$name, $abbr => $help';
    } else {
      arg = '$_intent--$name => $help';
    }
    if (expandHelp != null) {
      arg += '\n$expandHelp';
    }
    return arg;
  }
}
