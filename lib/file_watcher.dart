import 'dart:io';
import 'package:get/get.dart';
import 'package:lyrics_shower/app_state.dart';
import 'package:process_run/shell_run.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

var shell = Shell();

var filepath = getHome() + '/Documents/Projects/generics/bash/';
File lyricstify = File(filepath + 'lyricstify.txt');
File configFile = File(filepath + 'fakonfig.yaml');
late RxMap config;

getHome() {
  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  return home;
}

readLastLine() async {
  List<ProcessResult> gotcha =
      await shell.run('tail -n 1 $filepath/lyricstify.txt').then((val) => val);
  return gotcha.first.stdout;
}

getConfig() async {
  try {
    String yamlString = await configFile.readAsString();
    Map yaml = await loadYaml(yamlString);
    appState.fromYaml(yaml);
    await Future.delayed(const Duration(milliseconds: 3500));
    appState.isReady.value = true;
  } catch (e) {
    if (e.toString().contains('PathNotFoundException')) {
      yamlWrite(configFile, appState.toJson());
    }
  }
}

yamlWrite(File file, dynamic json) async {
  YAMLWriter yamlWriter = YAMLWriter();
  var yaml = yamlWriter.convert(json);
  await file.writeAsString(yaml);
  return true;
}
