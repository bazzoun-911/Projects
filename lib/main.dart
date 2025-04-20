import 'package:flutter/material.dart';
import 'car.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Car playerCar = Car(x: 0, y: 0.8);
  List<Car> enemyCars = [];
  bool gameOver = false;
  int tick = 0;
  int spawnIndex = 0;
  double backgroundY = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    playerCar = Car(x: 0, y: 0.8);
    enemyCars.clear();
    gameOver = false;
    tick = 0;
    spawnIndex = 0;
    backgroundY = 0;
    loop();
  }

  void loop() {
    if (gameOver) return;
    Future.delayed(Duration(milliseconds: 16), () {
      updateGame();
      if (!gameOver) loop();
    });
  }

  void updateGame() {
    setState(() {
      backgroundY += 2;

      for (var car in enemyCars) {
        car.y += 0.01;
      }

      enemyCars.removeWhere((car) => car.y > 1.2);

      tick++;
      if (tick % 60 == 0) {
        double laneX = [-0.5, 0.0, 0.5][spawnIndex % 3];
        enemyCars.add(Car(x: laneX, y: -0.2));
        spawnIndex++;
      }

      Size size = MediaQuery.of(context).size;
      Rect playerRect = playerCar.getRect(size);
      for (var enemy in enemyCars) {
        if (playerRect.overlaps(enemy.getRect(size))) {
          gameOver = true;
          break;
        }
      }
    });
  }

  void handleTap(TapUpDetails details) {
    if (gameOver) {
      startGame();
    } else {
      double middle = MediaQuery.of(context).size.width / 2;
      if (details.globalPosition.dx < middle) {
        playerCar.moveLeft();
      } else {
        playerCar.moveRight();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTapUp: handleTap,
      child: Scaffold(
        body: Stack(
          children: [

            Positioned.fill(
              child: Image.asset("image/road_0.png", fit: BoxFit.cover),
            ),

            Positioned.fromRect(
              rect: playerCar.getRect(size),
              child: Image.asset("image/truck-top-view-clipart.jpg", fit: BoxFit.fill),
            ),

            for (var car in enemyCars)
              Positioned.fromRect(
                rect: car.getRect(size),
                child: Image.asset("image/truck-top-view-clipart.jpg", fit: BoxFit.fill),
              ),

            if (gameOver)
              Center(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Game Over",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}