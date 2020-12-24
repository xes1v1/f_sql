import 'package:f_sql/button.dart';
import 'package:f_sql/raw_sql.dart';
import 'package:f_sql/sql_helpers.dart';
import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sqflite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'sqflite Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _databasesPath;
  String _dbPath;
  Database _database;

  @override
  void initState() {
    dbPath();
    super.initState();
  }

  void dbPath() async {
    _databasesPath = await getDatabasesPath();
    print('databasesPath $_databasesPath');
    _dbPath = join(_databasesPath, 'demo.db');
    print('_dbPath $_dbPath');
    setState(() {});
  }

  void initDatabase() async {
    if (_database == null) {
      print('open the database');
      Database database = await openDatabase(
        _dbPath,
        version: 1,
        onConfigure: (Database db) {
          print('onConfigure');
        },
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          print('onCreate');
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) {
          print('onUpgrade oldVersion $oldVersion newVersion $newVersion');
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) {
          print('onDowngrade $oldVersion newVersion $newVersion');
        },
        onOpen: (Database db) {
          print('onOpen');
        },
      );
      _database = database;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dbPath == null) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('数据库基地址： $_databasesPath'),
            SizedBox(height: 5),
            Text('demo.db 数据库地址： $_dbPath'),
            DButton('创建/获取数据库', () async {
              initDatabase();
            }),
            DButton('创建一张表', () async {
              // Insert some records in a transaction
              print('create table Test2 begin');
              await _database.execute(
                  'CREATE TABLE Test2 (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
              print('create table Test2 end');
            }),
            DButton('新增表字段', () async {
              print('新增字段 begin');
              await _database.execute(
                  'alter table Test2 ADD num2 REAL NOT NULL Default 0');
              print('新增字段 end');
            }),
            DButton('更改表字段', () async {
              print('更改字段 begin');
              await _database
                  .execute('alter table Test2 rename column num to num3');
              print('更改字段 end');
            }),
            SizedBox(height: 5),
            Text('数据库的操作有两种方式，一种是直接使用sql语句进行操作，即Raw SQL操作, '
                '另一种是基于SQL helpers的操作，两种方式各有优势，点击下方查看具体使用'),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 本demo中_database使用单例，直接传值db，或者传db路径再根据路径获取db，是一样的
                DButton('Raw SQL方式', () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => RawSql(_database)));
                }),
                Container(width: 1, height: 40, color: Colors.grey),
                DButton('SQL helpers方式', () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SQLHelpers(_dbPath)));
                }),
              ],
            ),
            DButton('关闭数据库', () async {
              // Close the database
              print('close db');
              int version = await _database.getVersion();
              print('getVersion $version');

              await _database.close();

              version = await _database.getVersion();
              print('getVersion $version');
            }),
            DButton('删除数据库', () async {
              // Delete the database
              await deleteDatabase(_dbPath);
            }),

            DButton('查看本页代码', () async {
              final url =
                  "https://github.com/xes1v1/f_sql/blob/main/lib/main.dart";
              if (await canLaunch(url)) {
                await launch(url);
              }
            })
          ],
        ),
      ),
    );
  }
}
