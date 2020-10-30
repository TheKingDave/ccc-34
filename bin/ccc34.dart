import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:tuple/tuple.dart';

void main(List<String> arguments) async {
  final dry = arguments.isNotEmpty;

  final path = 'files/level2/level2_';

  if (dry) {
    await runFile('${path}example', dry);
    return;
  }

  for (var i = 1; i <= 5; i++) {
    await runFile('$path$i', dry);
  }
}

void runFile(String path, bool dry) async {
  final solution = await runSolution('$path.in');

  if (dry) {
    print('Solution:');
    print(solution);
    return;
  }

  await File('$path.out').writeAsString(solution);
}

Future<String> runSolution(String path) async {
  final file = File(path);

  if (!await file.exists()) {
    print('File "${file.absolute}" does not exist');
    throw ArgumentError('File "${file.absolute}" does not exist');
  }
  print('File exists');

  final input = StreamQueue<String>(
      file.openRead().transform(utf8.decoder).transform(LineSplitter()));

  final costNum = int.parse(await input.next);
  var costs = (await input.take(costNum)).map(int.parse).toList();
  final taskNum = int.parse(await input.next);
  var tasks = (await input.take(taskNum)).map((e) {
    final split = e.split(' ').map(int.parse).toList();
    return Tuple2(split[0], split[1]);
  });

  final costMap = <int, int>{};

  tasks.forEach((task) {
    var minCost = 999999;
    var minMinute = 0;
    for (var i = 0; i < costNum - task.item2+1; i++) {
      final subCost = costs
          .getRange(i, i + task.item2)
          .fold(0, (previousValue, cost) => previousValue + cost);

      if(subCost < minCost) {
        minCost = subCost;
        minMinute = i;
      }
    }
    costMap[task.item1] = minMinute;
  });

  var ret = '${tasks.length}\n';

  ret += costMap.entries.map((e) => '${e.key} ${e.value}').join('\n');

  return ret;
}
