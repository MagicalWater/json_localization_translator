import 'args.dart';

void printHelp() {
  var commandHelp = CommandAction.values.map((e) => e.toString()).toList();
  var helpCommand = '''
～命令～
===
''';
  for (var i = 0; i < commandHelp.length; i++) {
    helpCommand += '${i + 1}. ${commandHelp[i]}\n';
  }

  print(helpCommand);
}
