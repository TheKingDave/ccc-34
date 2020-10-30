import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';

void main(List<String> arguments) async {
  final dry = arguments.isNotEmpty;
  
  final path = 'files/level1/level1_';
  
  for(var i = 1; i <= 5; i++) {
    await runFile('$path$i', dry);
  }
  
}

void runFile(String path, bool dry) async {
  final solution = await runSolution('$path.in');

  if(dry) {
    print('Solution:');
    print(solution);
    return;
  }

  await File('$path.out').writeAsString(solution);
}

Future<String> runSolution(String path) async {
  final file = File(path);

  if(!await file.exists()) {
    print('File "${file.absolute}" does not exist');
    throw ArgumentError('File "${file.absolute}" does not exist');
  }
  print('File exists');

  final input = StreamQueue<String>(file.openRead().transform(utf8.decoder).transform(LineSplitter()));
  
  final num = int.parse(await input.next);

  var min = int.parse(await input.next);
  var minId = 0;
  
  for(var i = 1; i < num; i++) {
    var cost = int.parse(await input.next);
    if(cost < min) {
      min = cost;
      minId = i;
    }
  }
  
  return '$minId';
}