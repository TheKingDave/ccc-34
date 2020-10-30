import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:tuple/tuple.dart';

void main(List<String> arguments) async {
  final dry = arguments.isNotEmpty;

  final path = 'files/level2/level2_';
  
  await runFile('${path}example', dry);
  
  for(var i = 1; i <= 5; i++) {
    //await runFile('$path$i', dry);
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
  
  final costNum = int.parse(await input.next);
  var costs = await input.take(costNum);
  final taskNum = int.parse(await input.next);
  var tasks = (await input.take(taskNum)).map((e) {
    final split = e.split(' ').map(int.parse).toList();
    return Tuple2(split[0], split[1]);
  });
  
  final taskMin = <int, int>{};
  
  for(var i = 0; i < costNum; i++) {
    
  }
  
  return '0';
}