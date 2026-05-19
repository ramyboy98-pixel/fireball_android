import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const FireballApp());
}

class FireballApp extends StatelessWidget {
  const FireballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fireball',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

// ===============================
// SPLASH SCREEN
// ===============================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainMenuScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFFFFF176),
                    Color(0xFFFF7043),
                    Color(0xFFB71C1C),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.7),
                    blurRadius: 45,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer_rounded,
                color: Colors.white,
                size: 68,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'FIREBALL',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mohammed BELKEBIR ABDELKARIM',
              style: TextStyle(
                color: Color(0xFFB8C1D1),
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// MAIN MENU
// ===============================

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B12),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Fireball',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'كرة قدم دائرية سريعة بين الأصدقاء',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF9EA7B8),
                ),
              ),
              const Spacer(),
              _MenuButton(
                title: 'لعب تجريبي',
                icon: Icons.play_arrow_rounded,
                color: const Color(0xFF1E88E5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                title: 'إنشاء غرفة Wi-Fi',
                icon: Icons.wifi_tethering_rounded,
                color: const Color(0xFF2E7D32),
                onTap: () {
                  _comingSoon(context);
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                title: 'الانضمام إلى غرفة',
                icon: Icons.group_add_rounded,
                color: const Color(0xFF6A1B9A),
                onTap: () {
                  _comingSoon(context);
                },
              ),
              const SizedBox(height: 16),
              _MenuButton(
                title: 'الإعدادات',
                icon: Icons.settings_rounded,
                color: const Color(0xFF455A64),
                onTap: () {
                  _comingSoon(context);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سنضيف هذه الميزة في المرحلة القادمة'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================
// GAME SCREEN
// ===============================

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _last = Duration.zero;

  final FireballWorld world = FireballWorld();

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      if (_last == Duration.zero) {
        _last = elapsed;
        return;
      }

      final dt = (elapsed - _last).inMicroseconds / 1000000.0;
      _last = elapsed;

      world.update(dt.clamp(0.0, 1 / 30));
      setState(() {});
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details, Size size) {
    world.handleJoystickStart(details.localPosition, size);
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    world.handleJoystickMove(details.localPosition, size);
  }

  void _handlePanEnd(DragEndDetails details) {
    world.handleJoystickEnd();
  }

  void _handleTapDown(TapDownDetails details, Size size) {
    world.handleTap(details.localPosition, size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => _handlePanStart(d, size),
              onPanUpdate: (d) => _handlePanUpdate(d, size),
              onPanEnd: _handlePanEnd,
              onTapDown: (d) => _handleTapDown(d, size),
              child: CustomPaint(
                size: size,
                painter: FireballPainter(world),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ===============================
// WORLD LOGIC
// ===============================

class FireballWorld {
  final double fieldWidth = 1600;
  final double fieldHeight = 900;

  Offset player = const Offset(430, 450);
  Offset playerVelocity = Offset.zero;

  Offset ball = const Offset(800, 450);
  Offset ballVelocity = Offset.zero;

  final double playerRadius = 35;
  final double ballRadius = 22;
  final double playerSpeed = 560;

  Offset joystickVector = Offset.zero;
  bool joystickActive = false;

  Offset lastAim = const Offset(1, 0);

  int redScore = 0;
  int blueScore = 0;

  Rect shootButton = Rect.zero;
  Rect passButton = Rect.zero;
  Rect powerButton = Rect.zero;

  void update(double dt) {
    _updatePlayer(dt);
    _updateBall(dt);
    _playerBallCollision();
    _checkGoals();
  }

  void _updatePlayer(double dt) {
    if (_length(joystickVector) > 0.05) {
      final dir = _normalize(joystickVector);
      lastAim = dir;
      playerVelocity = dir * playerSpeed;
    } else {
      playerVelocity = Offset.zero;
    }

    player += playerVelocity * dt;

    player = Offset(
      player.dx.clamp(55, fieldWidth - 55).toDouble(),
      player.dy.clamp(55, fieldHeight - 55).toDouble(),
    );
  }

  void _updateBall(double dt) {
    ball += ballVelocity * dt;

    ballVelocity = ballVelocity * pow(0.985, dt * 60).toDouble();

    if (_length(ballVelocity) < 4) {
      ballVelocity = Offset.zero;
    }

    final goalTop = fieldHeight / 2 - 120;
    final goalBottom = fieldHeight / 2 + 120;
    final insideGoalY = ball.dy > goalTop && ball.dy < goalBottom;

    if (ball.dy - ballRadius < 50) {
      ball = Offset(ball.dx, 50 + ballRadius);
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy * 0.78);
    }

    if (ball.dy + ballRadius > fieldHeight - 50) {
      ball = Offset(ball.dx, fieldHeight - 50 - ballRadius);
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy * 0.78);
    }

    if (!insideGoalY) {
      if (ball.dx - ballRadius < 50) {
        ball = Offset(50 + ballRadius, ball.dy);
        ballVelocity = Offset(-ballVelocity.dx * 0.78, ballVelocity.dy);
      }

      if (ball.dx + ballRadius > fieldWidth - 50) {
        ball = Offset(fieldWidth - 50 - ballRadius, ball.dy);
        ballVelocity = Offset(-ballVelocity.dx * 0.78, ballVelocity.dy);
      }
    }
  }

  void _playerBallCollision() {
    final diff = ball - player;
    final distance = _length(diff);
    final minDistance = playerRadius + ballRadius;

    if (distance < minDistance && distance > 0) {
      final normal = _normalize(diff);
      final overlap = minDistance - distance;

      ball += normal * overlap;

      final impact = _dot(playerVelocity, normal);

      if (impact > 0) {
        ballVelocity += normal * impact * 1.35;
      }

      ballVelocity += normal * 85;
    }
  }

  void _checkGoals() {
    final goalTop = fieldHeight / 2 - 120;
    final goalBottom = fieldHeight / 2 + 120;

    final inGoalY = ball.dy > goalTop && ball.dy < goalBottom;

    if (inGoalY && ball.dx < 24) {
      blueScore++;
      resetAfterGoal();
    }

    if (inGoalY && ball.dx > fieldWidth - 24) {
      redScore++;
      resetAfterGoal();
    }
  }

  void resetAfterGoal() {
    player = const Offset(430, 450);
    ball = const Offset(800, 450);
    playerVelocity = Offset.zero;
    ballVelocity = Offset.zero;
    joystickVector = Offset.zero;
    joystickActive = false;
    lastAim = const Offset(1, 0);
  }

  void shoot(double power) {
    Offset dir;

    if (_length(joystickVector) > 0.05) {
      dir = _normalize(joystickVector);
    } else {
      dir = _normalize(lastAim);
    }

    final dist = _length(ball - player);

    if (dist <= playerRadius + ballRadius + 55) {
      ballVelocity += dir * power;
    }
  }

  void handleJoystickStart(Offset position, Size screen) {
    final center = Offset(150, screen.height - 145);

    if (_length(position - center) < 150) {
      joystickActive = true;
      handleJoystickMove(position, screen);
    }
  }

  void handleJoystickMove(Offset position, Size screen) {
    if (!joystickActive) return;

    final center = Offset(150, screen.height - 145);
    final delta = position - center;
    final maxDistance = 82.0;

    if (_length(delta) > maxDistance) {
      joystickVector = _normalize(delta);
    } else {
      joystickVector = delta / maxDistance;
    }
  }

  void handleJoystickEnd() {
    joystickActive = false;
    joystickVector = Offset.zero;
  }

  void handleTap(Offset position, Size screen) {
    _updateButtonRects(screen);

    if (shootButton.contains(position)) {
      shoot(820);
    } else if (passButton.contains(position)) {
      shoot(500);
    } else if (powerButton.contains(position)) {
      shoot(1180);
    }
  }

  void _updateButtonRects(Size screen) {
    shootButton = Rect.fromCircle(
      center: Offset(screen.width - 120, screen.height - 135),
      radius: 60,
    );

    passButton = Rect.fromCircle(
      center: Offset(screen.width - 245, screen.height - 100),
      radius: 48,
    );

    powerButton = Rect.fromCircle(
      center: Offset(screen.width - 235, screen.height - 225),
      radius: 50,
    );
  }

  double _length(Offset o) {
    return sqrt(o.dx * o.dx + o.dy * o.dy);
  }

  Offset _normalize(Offset o) {
    final l = _length(o);
    if (l == 0) return Offset.zero;
    return Offset(o.dx / l, o.dy / l);
  }

  double _dot(Offset a, Offset b) {
    return a.dx * b.dx + a.dy * b.dy;
  }
}

// ===============================
// PAINTER
// ===============================

class FireballPainter extends CustomPainter {
  final FireballWorld world;

  FireballPainter(this.world);

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / world.fieldWidth;
    final scaleY = size.height / world.fieldHeight;
    final scale = min(scaleX, scaleY);

    final offset = Offset(
      (size.width - world.fieldWidth * scale) / 2,
      (size.height - world.fieldHeight * scale) / 2,
    );

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);

    _drawField(canvas);
    _drawScore(canvas);
    _drawBall(canvas);
    _drawPlayer(canvas);

    canvas.restore();

    _drawControls(canvas, size);
  }

  void _drawField(Canvas canvas) {
    final fieldPaint = Paint()
      ..color = const Color(0xFF168B47)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.78)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final fieldRect = Rect.fromLTWH(
      50,
      50,
      world.fieldWidth - 100,
      world.fieldHeight - 100,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(fieldRect, const Radius.circular(22)),
      fieldPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(fieldRect, const Radius.circular(22)),
      borderPaint,
    );

    canvas.drawLine(
      Offset(world.fieldWidth / 2, 50),
      Offset(world.fieldWidth / 2, world.fieldHeight - 50),
      linePaint,
    );

    canvas.drawCircle(
      Offset(world.fieldWidth / 2, world.fieldHeight / 2),
      115,
      linePaint,
    );

    canvas.drawCircle(
      Offset(world.fieldWidth / 2, world.fieldHeight / 2),
      8,
      Paint()..color = Colors.white,
    );

    canvas.drawRect(
      Rect.fromLTWH(50, world.fieldHeight / 2 - 170, 190, 340),
      linePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        world.fieldWidth - 240,
        world.fieldHeight / 2 - 170,
        190,
        340,
      ),
      linePaint,
    );

    final redGoal = Paint()
      ..color = const Color(0xFFFF5252)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final blueGoal = Paint()
      ..color = const Color(0xFF40A9FF)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(50, world.fieldHeight / 2 - 120),
      Offset(50, world.fieldHeight / 2 + 120),
      redGoal,
    );

    canvas.drawLine(
      Offset(world.fieldWidth - 50, world.fieldHeight / 2 - 120),
      Offset(world.fieldWidth - 50, world.fieldHeight / 2 + 120),
      blueGoal,
    );
  }

  void _drawScore(Canvas canvas) {
    final score = '${world.redScore}   -   ${world.blueScore}';

    final painter = TextPainter(
      text: TextSpan(
        text: score,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        world.fieldWidth / 2 - painter.width / 2,
        74,
      ),
    );

    _drawText(
      canvas,
      'RED',
      Offset(world.fieldWidth / 2 - 155, 136),
      const Color(0xFFFF5252),
      22,
    );

    _drawText(
      canvas,
      'BLUE',
      Offset(world.fieldWidth / 2 + 102, 136),
      const Color(0xFF40A9FF),
      22,
    );
  }

  void _drawPlayer(Canvas canvas) {
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.35)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 10);

    canvas.drawCircle(
      world.player + const Offset(4, 5),
      world.playerRadius,
      shadow,
    );

    final body = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFF7961),
          Color(0xFFE53935),
          Color(0xFFB71C1C),
        ],
      ).createShader(
        Rect.fromCircle(
          center: world.player,
          radius: world.playerRadius,
        ),
      );

    canvas.drawCircle(world.player, world.playerRadius, body);

    canvas.drawCircle(
      world.player,
      world.playerRadius,
      Paint()
        ..color = Colors.white.withOpacity(0.86)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    _drawText(
      canvas,
      'YOU',
      Offset(world.player.dx - 20, world.player.dy - 12),
      Colors.white,
      18,
    );
  }

  void _drawBall(Canvas canvas) {
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);

    canvas.drawCircle(
      world.ball + const Offset(4, 5),
      world.ballRadius,
      shadow,
    );

    final ballPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Colors.white,
          Color(0xFFE0E0E0),
          Color(0xFF9E9E9E),
        ],
      ).createShader(
        Rect.fromCircle(
          center: world.ball,
          radius: world.ballRadius,
        ),
      );

    canvas.drawCircle(world.ball, world.ballRadius, ballPaint);

    canvas.drawCircle(
      world.ball,
      world.ballRadius,
      Paint()
        ..color = Colors.black.withOpacity(0.45)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawControls(Canvas canvas, Size size) {
    world._updateButtonRects(size);

    final joyCenter = Offset(150, size.height - 145);
    final joyRadius = 82.0;

    canvas.drawCircle(
      joyCenter,
      joyRadius,
      Paint()..color = Colors.white.withOpacity(0.12),
    );

    canvas.drawCircle(
      joyCenter,
      joyRadius,
      Paint()
        ..color = Colors.white.withOpacity(0.25)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    Offset knob = joyCenter;

    if (world._length(world.joystickVector) > 0) {
      knob += world.joystickVector * 54;
    }

    canvas.drawCircle(
      knob,
      34,
      Paint()..color = Colors.white.withOpacity(0.45),
    );

    _drawButton(
      canvas,
      world.shootButton,
      'SHOT',
      const Color(0xFFE53935),
      22,
    );

    _drawButton(
      canvas,
      world.passButton,
      'PASS',
      const Color(0xFF1E88E5),
      18,
    );

    _drawButton(
      canvas,
      world.powerButton,
      'POWER',
      const Color(0xFFFF9800),
      16,
    );
  }

  void _drawButton(
    Canvas canvas,
    Rect rect,
    String label,
    Color color,
    double fontSize,
  ) {
    canvas.drawCircle(
      rect.center,
      rect.width / 2,
      Paint()..color = color.withOpacity(0.84),
    );

    canvas.drawCircle(
      rect.center,
      rect.width / 2,
      Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        rect.center.dx - painter.width / 2,
        rect.center.dy - painter.height / 2,
      ),
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    Color color,
    double size,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant FireballPainter oldDelegate) {
    return true;
  }
}
