import 'package:flutter/material.dart';

push(context, pagename) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return pagename;
  }));
}

replace(context, pagename) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    return pagename;
  }));
}

pop(context) {
  Navigator.of(context).pop();
}

snack(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Center(
          child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ))));
}
