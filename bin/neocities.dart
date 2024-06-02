import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:neocities/neocities.dart' hide File;

const String version = '0.0.1';

enum CommandType {
  info,
  list,
  delete,
  upload,
  key,
}

class NeocitiesCommand extends Command {
  CommandType command;
  String? username;
  String? password;
  String? apiKey;

  NeocitiesCommand(this.command);

  @override
  String get name => command.name;

  @override
  String get description => switch (command) {
        CommandType.info => "Show the info of a site",
        CommandType.list => "List the files in your site",
        CommandType.delete => "Delete files from your site",
        CommandType.upload => "Upload files to your site",
        CommandType.key => "Get the api key for your site",
      };

  @override
  FutureOr? run() async {
    final args = argResults!.rest;
    final jsonEncoder = JsonEncoder.withIndent('  ');

    final client = Neocities(
      username: globalResults?.option('username'),
      password: globalResults?.option('password'),
      apiKey: globalResults?.option('key'),
    );

    try {
      switch (command) {
        case CommandType.info:
          final info = await client.info(args.isEmpty ? null : args[0]);
          print(jsonEncoder.convert(info));
          break;
        case CommandType.list:
          final list = await client.list(args.isEmpty ? null : args[0]);
          print(jsonEncoder.convert(list));
          break;
        case CommandType.delete:
          if (args.isEmpty) {
            print('No files specified');
            break;
          }
          await client.delete(args);
          print('success');
          break;
        case CommandType.upload:
          if (args.isEmpty) {
            print('No files specified');
            break;
          }
          await client.upload(
            args.map((filename) {
              final file = File(filename);
              return UploadFile(filename, file.lengthSync(), file.openRead());
            }).toList(),
          );
          break;
        case CommandType.key:
          print(await client.key());
          break;
      }
    } on FailedRequest catch (e) {
      print(e.message);
    } finally {
      client.close();
    }
  }
}

void main(List<String> arguments) async {
  final runner = CommandRunner(
    'neocities',
    'A dart command line interface for neocities.org',
  )
    ..argParser.addOption('username', abbr: 'u')
    ..argParser.addOption('password', abbr: 'p')
    ..argParser
        .addOption('key', abbr: 'k', aliases: ['apiKey', 'api_key', 'apikey']);
  for (final type in CommandType.values) {
    runner.addCommand(NeocitiesCommand(type));
  }
  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e.message);
  }
}
