import 'package:flutter/material.dart';

class ErrorComponent extends StatelessWidget {
  double? width;
  double? height;
  final String message;
  ErrorComponent(this.message, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: width ?? screenSize.width,
      height: height ?? screenSize.height,
      color: Theme.of(context).colorScheme.error,
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 32,
            color: Theme.of(context).colorScheme.onError,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
