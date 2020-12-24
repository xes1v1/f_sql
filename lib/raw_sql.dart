/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/24/20
 * Time: 2:17 PM
 * target: 使用原始sql语句操作数据库
 */

import 'package:f_sql/button.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class RawSql extends StatelessWidget {

  final Database database;
  RawSql(this.database);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Raw Sql')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DButton('增加数据', () async {
              // Insert some records in a transaction
              await database.transaction((txn) async {
                int id1 = await txn.rawInsert(
                    'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
                print('inserted1: $id1');
                int id2 = await txn.rawInsert(
                    'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
                    ['another name', 12345678, 3.1416]);
                print('inserted2: $id2');
              });
            }),
            DButton('删除数据', () async {
              // Delete a record
              await database
                  .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
            }),
            DButton('修改数据', () async {
              // Update some record
              int count = await database.rawUpdate(
                  'UPDATE Test SET name = ?, value = ? WHERE name = ?',
                  ['updated name', '9876', 'some name']);
              print('updated: $count');
            }),
            DButton('查询数据', () async {
              // Get the records
              List<Map> list = await database.rawQuery('SELECT * FROM Test');
              print(list);
            }),

            DButton('查看本页代码', () async {
              final url =
                  "https://github.com/xes1v1/f_sql/blob/main/lib/raw_sql.dart";
              if (await canLaunch(url)) {
                await launch(url);
              }
            }),
          ],
        ),
      )
    );
  }
}
