/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/24/20
 * Time: 9:42 AM
 * target: 使用helpers操作数据库
 */

import 'package:f_sql/button.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class SQLHelpers extends StatelessWidget {
  final String dbPath;
  TodoProvider _todoProvider = TodoProvider();

  SQLHelpers(this.dbPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQL helpers'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DButton('增加数据', () async {
              await _todoProvider.open(dbPath);
              Todo model = Todo();
              model.title = '测试数据1';
              model.done = true;
              _todoProvider.insert(model);
            }),
            DButton('删除数据', () async {
              // Delete a record
              // _todoProvider.delete(1);
            }),
            DButton('修改数据', () async {
              // Update some record
              // 传入已有的model
              // _todoProvider.update(model);
            }),
            DButton('查询数据', () async {
              // Get the records
              _todoProvider.getTodo(1);
            }),

            DButton('查看本页代码', () async {
              final url =
                  "https://github.com/xes1v1/f_sql/blob/main/lib/sql_helpers.dart";
              if (await canLaunch(url)) {
                await launch(url);
              }
            }),
          ],
        ),
      ),
    );
  }
}

final String tableTodo = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Todo {
  int id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {

  Database db;
  Future open(String dbPath) async {
    db = await openDatabase(dbPath);

    await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
    return this;
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
