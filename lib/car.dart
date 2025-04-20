import 'package:flutter/material.dart';

class Car {
  double x;
  double y;

  double width = 50;
  double height = 100;

  Car({required this.x, required this.y});

  void moveLeft() {
    if (x > -0.5) x -= 0.5;
  }

  void moveRight() {
    if (x < 0.5) x += 0.5;
  }

  Rect getRect(Size screenSize) {
    double posX = (x + 1) / 2 * screenSize.width;
    double posY = y * screenSize.height;
    return Rect.fromLTWH(posX - width / 2, posY - height, width, height);
  }
}