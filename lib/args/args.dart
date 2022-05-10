import 'package:args/args.dart';

import 'group.dart';
import 'package:collection/collection.dart';

export 'group.dart';
export 'help_print.dart';

class CommandAction {
  final ArgGroup action;
  final ArgResults result;

  const CommandAction._({required this.action, required this.result});

  factory CommandAction(List<String> args) {
    final code = args.isNotEmpty ? args[0] : null;
    final action = values.firstWhereOrNull((e) => code == e.name) ?? helpArg;
    final result = action.toParser().parse(args);
    return CommandAction._(action: action, result: result);
  }

  static List<ArgGroup> values = [
    helpArg,
    translateArg,
  ];

  static const helpArg = ArgGroup(
    title: '打印幫助',
    name: 'help',
  );

  static const translateArg = ArgGroup(
    title: '翻譯',
    name: 'translate',
    args: [
      ActionArg.option(name: 'in', abbr: 'i', help: '輸入導案'),
      ActionArg.option(name: 'out', abbr: 'o', help: '輸出檔案'),
      ActionArg.option(name: 'from', abbr: 'f', help: '輸出語系'),
      ActionArg.option(name: 'to', abbr: 't', help: '輸出語系'),
    ],
    example: '''
    translate -i {inFile} -o {outFile} -f en -t zh 
    ''',
  );

  ArgResults parseArg(List<String> args) {
    return action.toParser().parse(args);
  }

  @override
  String toString() {
    return action.toString();
  }
}
