/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/24/20
 * Time: 11:02 AM
 * target: 按钮
 */

import 'package:flutter/material.dart';

class DButton extends StatelessWidget {

  final String title;
  final Function fn;

  DButton(this.title, this.fn);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: TextButton(
          onPressed: this.fn,
          style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.blueGrey.shade100),
          child: Text(this.title)),
    );
  }
}
