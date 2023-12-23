import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

Future<YamlMap> loadConfig() async {
  final String configPath = 'assets/config/apps_config.yaml';
  final String yamlString = await rootBundle.loadString(configPath);
  final YamlMap yamlMap = loadYaml(yamlString);
  return yamlMap;
}
