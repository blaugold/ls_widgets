import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:ls_widgets/ls_widgets.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

class CliOptions {
  const CliOptions({
    @required this.package,
    @required this.output,
  });

  final String package;
  final String output;
}

CliOptions parseArguments(List<String> arguments) {
  final parser = ArgParser();
  parser.addOption(
    'help',
    help: 'Show usage info.',
  );
  parser.addOption(
    'package',
    help: 'Path to the package to search for widgets.',
  );
  parser.addOption(
    'output',
    help: 'Path to the output file.',
    defaultsTo: './widgets.json',
  );

  final args = parser.parse(arguments);

  final package = args['package'] as String;
  final output = args['output'] as String;
  final hasRequiredArgs = package != null && output != null;

  if (!hasRequiredArgs) {
    print(parser.usage);
    exitCode = 64;
    return null;
  }

  if (args['help'] != null) {
    print(parser.usage);
    exitCode = 0;
    return null;
  }

  return CliOptions(
    package: package,
    output: output,
  );
}

Future<void> writeOutput(List<WidgetInfo> widgetInfos, String output) async {
  final outputFile = File(p.absolute(output));
  final outputContent = JsonEncoder.withIndent('\t').convert(widgetInfos);
  await outputFile.writeAsString(outputContent);
}

void main(List<String> arguments) async {
  final options = parseArguments(arguments);
  if (options == null) return;

  try {
    final widgetInfos = await collectWidgetInfos(options.package);

    print('Found ${widgetInfos.length} Widgets in ${options.package}.');

    await writeOutput(widgetInfos, options.output);
  } catch (e) {
    print(e);
    if (e is Error) {
      print(e.stackTrace);
    }
    exitCode = 1;
  }
}
