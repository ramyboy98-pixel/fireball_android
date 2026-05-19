import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const FireballApp());
}

class FireballApp extends StatelessWidget {
  const FireballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fireball',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
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
                    color: Colors.deepOrange.withOpacity(0.75),
                    blurRadius: 48,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer_rounded,
                color: Colors.white,
                size: 62,
              ),
            ),
            const SizedBox(width: 28),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FIREBALL',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohammed BELKEBIR ABDELKARIM',
                  style: TextStyle(
                    color: Color(0xFFB8C1D1),
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MAIN MENU
// ============================================================

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B12),
      body: Padding(
        padding: const EdgeInsets.all(26),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF111827),
                      Color(0xFF020617),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white12),
                ),
                padding: const EdgeInsets.all(32),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fireball',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'لعبة كرة قدم دائرية سريعة، تحكم مباشر، تمرير، تسديد، وملعب أفقي كامل.',
                      style: TextStyle(
                        fontSize: 19,
                        height: 1.5,
                        color: Color(0xFFB8C1D1),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'نسخة تجريبية محسّنة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MenuButton(
                    title: 'لعب تجريبي',
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFF2563EB),
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
                    color: const Color(0xFF15803D),
                    onTap: () => _soon(context),
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    title: 'الانضمام إلى غرفة',
                    icon: Icons.group_add_rounded,
                    color: const Color(0xFF7E22CE),
                    onTap: () => _soon(context),
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    title: 'الإعدادات',
                    icon: Icons.tune_rounded,
                    color: const Color(0xFF334155),
                    onTap: () => _soon(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سنضيف هذه الميزة بعد ضبط نواة اللعب'),
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
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 34),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GAME SCREEN
// ============================================================

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  Duration last = Duration.zero;

  final FireballWorld world = FireballWorld();

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    ticker = createTicker((elapsed) {
      if (last == Duration.zero) {
        last = elapsed;
        return;
      }

      final dt = (elapsed - last).inMicroseconds / 1000000.0;
      last = elapsed;

      world.update(dt.clamp(0.0, 1 / 30));
      setState(() {});
    });

    ticker.start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: const Color(0xFF020617),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(
              constraints.maxWidth,
              constraints.maxHeight,
            );

            world.resize(size);

            return Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) {
                world.pointerDown(event.pointer, event.localPosition);
              },
              onPointerMove: (event) {
                world.pointerMove(event.pointer, event.localPosition);
              },
              onPointerUp: (event) {
                world.pointerUp(event.pointer);
              },
              onPointerCancel: (event) {
                world.pointerUp(event.pointer);
              },
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

// ============================================================
// DATA
// ============================================================

enum Team {
  red,
  blue,
}

class PlayerDisk {
  PlayerDisk({
    required this.id,
    required this.name,
    required this.team,
    required this.color,
    required this.isUser,
    required this.pos,
  });

  final int id;
  final String name;
  final Team team;
  final Color color;
  final bool isUser;

  Offset pos;
  Offset vel = Offset.zero;

  double radius = 23;
}

// ============================================================
// WORLD LOGIC
// ============================================================

class FireballWorld {
  Size screen = Size.zero;

  double fieldWidth = 1000;
  double fieldHeight = 540;

  final double border = 18;
  final double ballRadius = 13;

  Offset ball = Offset.zero;
  Offset ballVelocity = Offset.zero;

  int? holderId;

  int redScore = 0;
  int blueScore = 0;

  int? joystickPointer;
  Offset joystickVector = Offset.zero;
  Offset lastAim = const Offset(1, 0);

  final List<PlayerDisk> players = [];

  Rect shootButton = Rect.zero;
  Rect passButton = Rect.zero;
  Rect powerButton = Rect.zero;

  bool initialized = false;

  PlayerDisk get user => players.firstWhere((p) => p.isUser);

  void resize(Size size) {
    screen = size;
    fieldWidth = size.width;
    fieldHeight = size.height;

    _updateButtons();

    if (!initialized && size.width > 0 && size.height > 0) {
      initialized = true;
      _createPlayers();
      resetPositions(fullReset: true);
    }
  }

  void _createPlayers() {
    players.clear();

    players.add(
      PlayerDisk(
        id: 0,
        name: 'YOU',
        team: Team.red,
        color: const Color(0xFFE11D48),
        isUser: true,
        pos: Offset.zero,
      ),
    );

    players.add(
      PlayerDisk(
        id: 1,
        name: 'RED 2',
        team: Team.red,
        color: const Color(0xFFFB7185),
        isUser: false,
        pos: Offset.zero,
      ),
    );

    players.add(
      PlayerDisk(
        id: 2,
        name: 'BLUE 1',
        team: Team.blue,
        color: const Color(0xFF2563EB),
        isUser: false,
        pos: Offset.zero,
      ),
    );

    players.add(
      PlayerDisk(
        id: 3,
        name: 'BLUE 2',
        team: Team.blue,
        color: const Color(0xFF60A5FA),
        isUser: false,
        pos: Offset.zero,
      ),
    );
  }

  void resetPositions({bool fullReset = false}) {
    ball = Offset(fieldWidth * 0.5, fieldHeight * 0.5);
    ballVelocity = Offset.zero;
    holderId = null;

    players[0].pos = Offset(fieldWidth * 0.28, fieldHeight * 0.5);
    players[1].pos = Offset(fieldWidth * 0.34, fieldHeight * 0.28);
    players[2].pos = Offset(fieldWidth * 0.72, fieldHeight * 0.5);
    players[3].pos = Offset(fieldWidth * 0.66, fieldHeight * 0.72);

    for (final p in players) {
      p.vel = Offset.zero;
    }

    if (fullReset) {
      redScore = 0;
      blueScore = 0;
    }
  }

  void update(double dt) {
    if (!initialized) return;

    _updateUser(dt);
    _updateAI(dt);
    _resolvePlayerCollisions();
    _updateBall(dt);
    _tryTakePossession();
    _updatePossessionBall();
    _checkGoals();
  }

  void _updateUser(double dt) {
    final speed = fieldWidth * 0.72;

    if (_length(joystickVector) > 0.05) {
      final dir = _normalize(joystickVector);
      lastAim = dir;
      user.vel = dir * speed;
    } else {
      user.vel = user.vel * 0.80;
      if (_length(user.vel) < 5) user.vel = Offset.zero;
    }

    user.pos += user.vel * dt;
    user.pos = _clampInside(user.pos, user.radius);
  }

  void _updateAI(double dt) {
    final redMate = players[1];
    final blue1 = players[2];
    final blue2 = players[3];

    final support = Offset(fieldWidth * 0.58, fieldHeight * 0.34);
    _moveAI(redMate, support, dt, 0.62);

    final target = holderId == null ? ball : _holder().pos;

    _moveAI(
      blue1,
      target + Offset(-fieldWidth * 0.04, -fieldHeight * 0.05),
      dt,
      0.70,
    );

    _moveAI(
      blue2,
      target + Offset(-fieldWidth * 0.07, fieldHeight * 0.10),
      dt,
      0.66,
    );

    if (holderId == blue1.id || holderId == blue2.id) {
      final h = _holder();
      final goal = Offset(border, fieldHeight * 0.5);
      final dir = _normalize(goal - h.pos);

      h.vel = dir * fieldWidth * 0.48;

      if (h.pos.dx < fieldWidth * 0.48) {
        _releaseBall(dir * fieldWidth * 1.08);
      }
    }
  }

  void _moveAI(PlayerDisk p, Offset target, double dt, double speedFactor) {
    final to = target - p.pos;
    final distance = _length(to);

    if (distance > 10) {
      final dir = _normalize(to);
      p.vel = dir * fieldWidth * speedFactor;
    } else {
      p.vel *= 0.70;
    }

    p.pos += p.vel * dt;
    p.pos = _clampInside(p.pos, p.radius);
  }

  void _resolvePlayerCollisions() {
    for (int i = 0; i < players.length; i++) {
      for (int j = i + 1; j < players.length; j++) {
        final a = players[i];
        final b = players[j];

        final diff = b.pos - a.pos;
        final dist = _length(diff);
        final minDist = a.radius + b.radius + 2;

        if (dist > 0 && dist < minDist) {
          final n = _normalize(diff);
          final overlap = minDist - dist;

          a.pos -= n * (overlap * 0.5);
          b.pos += n * (overlap * 0.5);

          a.pos = _clampInside(a.pos, a.radius);
          b.pos = _clampInside(b.pos, b.radius);
        }
      }
    }
  }

  void _updateBall(double dt) {
    if (holderId != null) return;

    ball += ballVelocity * dt;
    ballVelocity *= pow(0.988, dt * 60).toDouble();

    if (_length(ballVelocity) < 6) {
      ballVelocity = Offset.zero;
    }

    final goalTop = fieldHeight * 0.5 - fieldHeight * 0.17;
    final goalBottom = fieldHeight * 0.5 + fieldHeight * 0.17;
    final insideGoal = ball.dy > goalTop && ball.dy < goalBottom;

    if (ball.dy - ballRadius < border) {
      ball = Offset(ball.dx, border + ballRadius);
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy * 0.82);
    }

    if (ball.dy + ballRadius > fieldHeight - border) {
      ball = Offset(ball.dx, fieldHeight - border - ballRadius);
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy * 0.82);
    }

    if (!insideGoal) {
      if (ball.dx - ballRadius < border) {
        ball = Offset(border + ballRadius, ball.dy);
        ballVelocity = Offset(-ballVelocity.dx * 0.82, ballVelocity.dy);
      }

      if (ball.dx + ballRadius > fieldWidth - border) {
        ball = Offset(fieldWidth - border - ballRadius, ball.dy);
        ballVelocity = Offset(-ballVelocity.dx * 0.82, ballVelocity.dy);
      }
    }
  }

  void _tryTakePossession() {
    if (holderId != null) return;

    PlayerDisk? closest;
    double best = 999999;

    for (final p in players) {
      final d = _length(ball - p.pos);
      final takeDistance = p.radius + ballRadius + 16;

      if (d < takeDistance && d < best) {
        best = d;
        closest = p;
      }
    }

    if (closest != null) {
      holderId = closest.id;
      ballVelocity = Offset.zero;
    }
  }

  void _updatePossessionBall() {
    if (holderId == null) return;

    final h = _holder();
    Offset aim;

    if (h.isUser) {
      aim = _length(joystickVector) > 0.05 ? _normalize(joystickVector) : lastAim;
    } else {
      final enemyGoal = h.team == Team.red
          ? Offset(fieldWidth - border, fieldHeight * 0.5)
          : Offset(border, fieldHeight * 0.5);
      aim = _normalize(enemyGoal - h.pos);
    }

    if (_length(aim) == 0) {
      aim = h.team == Team.red ? const Offset(1, 0) : const Offset(-1, 0);
    }

    final carryDistance = h.radius + ballRadius + 6;
    ball = h.pos + aim * carryDistance;
  }

  void _checkGoals() {
    final goalTop = fieldHeight * 0.5 - fieldHeight * 0.17;
    final goalBottom = fieldHeight * 0.5 + fieldHeight * 0.17;
    final inGoalY = ball.dy > goalTop && ball.dy < goalBottom;

    if (!inGoalY) return;

    if (ball.dx < 4) {
      blueScore++;
      resetPositions();
    }

    if (ball.dx > fieldWidth - 4) {
      redScore++;
      resetPositions();
    }
  }

  void pass() {
    if (!_userCanKick()) return;

    final mate = players
        .where((p) => p.team == Team.red && !p.isUser)
        .reduce((a, b) {
      final da = _length(a.pos - user.pos);
      final db = _length(b.pos - user.pos);
      return da < db ? a : b;
    });

    final dir = _normalize(mate.pos - ball);

    holderId = null;
    ballVelocity = dir * fieldWidth * 1.18;
  }

  void shoot({required bool power}) {
    if (!_userCanKick()) return;

    final goal = Offset(fieldWidth - border, fieldHeight * 0.5);

    Offset dir;

    if (_length(joystickVector) > 0.08) {
      final manual = _normalize(joystickVector);
      final toGoal = _normalize(goal - ball);
      dir = _normalize(manual * 0.65 + toGoal * 0.35);
    } else {
      dir = _normalize(goal - ball);
    }

    final force = power ? fieldWidth * 1.95 : fieldWidth * 1.35;

    holderId = null;
    ballVelocity = dir * force;
  }

  bool _userCanKick() {
    if (holderId == user.id) return true;

    final d = _length(ball - user.pos);
    return d < user.radius + ballRadius + 24;
  }

  void _releaseBall(Offset velocity) {
    holderId = null;
    ballVelocity = velocity;
  }

  PlayerDisk _holder() {
    return players.firstWhere((p) => p.id == holderId);
  }

  void pointerDown(int pointer, Offset position) {
    _updateButtons();

    if (shootButton.contains(position)) {
      shoot(power: false);
      return;
    }

    if (passButton.contains(position)) {
      pass();
      return;
    }

    if (powerButton.contains(position)) {
      shoot(power: true);
      return;
    }

    final joyCenter = _joystickCenter();

    if (_length(position - joyCenter) < fieldHeight * 0.26) {
      joystickPointer = pointer;
      _updateJoystick(position);
    }
  }

  void pointerMove(int pointer, Offset position) {
    if (pointer == joystickPointer) {
      _updateJoystick(position);
    }
  }

  void pointerUp(int pointer) {
    if (pointer == joystickPointer) {
      joystickPointer = null;
      joystickVector = Offset.zero;
    }
  }

  Offset _joystickCenter() {
    return Offset(fieldWidth * 0.13, fieldHeight * 0.76);
  }

  void _updateJoystick(Offset position) {
    final center = _joystickCenter();
    final delta = position - center;
    final maxDistance = fieldHeight * 0.115;

    if (_length(delta) > maxDistance) {
      joystickVector = _normalize(delta);
    } else {
      joystickVector = delta / maxDistance;
    }
  }

  void _updateButtons() {
    final r = fieldHeight * 0.105;

    shootButton = Rect.fromCircle(
      center: Offset(fieldWidth * 0.87, fieldHeight * 0.72),
      radius: r,
    );

    passButton = Rect.fromCircle(
      center: Offset(fieldWidth * 0.74, fieldHeight * 0.80),
      radius: r * 0.82,
    );

    powerButton = Rect.fromCircle(
      center: Offset(fieldWidth * 0.76, fieldHeight * 0.56),
      radius: r * 0.86,
    );
  }

  Offset _clampInside(Offset p, double radius) {
    return Offset(
      p.dx.clamp(border + radius, fieldWidth - border - radius).toDouble(),
      p.dy.clamp(border + radius, fieldHeight - border - radius).toDouble(),
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
}

// ============================================================
// PAINTER
// ============================================================

class FireballPainter extends CustomPainter {
  FireballPainter(this.world);

  final FireballWorld world;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas);
    _drawField(canvas);
    _drawGoals(canvas);
    _drawScore(canvas);
    _drawPlayers(canvas);
    _drawBall(canvas);
    _drawControls(canvas);
  }

  void _drawBackground(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, world.fieldWidth, world.fieldHeight);

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF0F172A),
          Color(0xFF020617),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  void _drawField(Canvas canvas) {
    final grass = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF166534),
          Color(0xFF15803D),
          Color(0xFF166534),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, 0, world.fieldWidth, world.fieldHeight),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, world.fieldWidth, world.fieldHeight),
      grass,
    );

    final stripePaint = Paint()..color = Colors.white.withOpacity(0.035);

    final stripeWidth = world.fieldWidth / 10;
    for (int i = 0; i < 10; i++) {
      if (i.isEven) {
        canvas.drawRect(
          Rect.fromLTWH(i * stripeWidth, 0, stripeWidth, world.fieldHeight),
          stripePaint,
        );
      }
    }

    final line = Paint()
      ..color = Colors.white.withOpacity(0.88)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;

    final thin = Paint()
      ..color = Colors.white.withOpacity(0.70)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final b = world.border;

    canvas.drawRect(
      Rect.fromLTWH(b, b, world.fieldWidth - b * 2, world.fieldHeight - b * 2),
      line,
    );

    canvas.drawLine(
      Offset(world.fieldWidth / 2, b),
      Offset(world.fieldWidth / 2, world.fieldHeight - b),
      thin,
    );

    canvas.drawCircle(
      Offset(world.fieldWidth / 2, world.fieldHeight / 2),
      world.fieldHeight * 0.18,
      thin,
    );

    canvas.drawCircle(
      Offset(world.fieldWidth / 2, world.fieldHeight / 2),
      4,
      Paint()..color = Colors.white.withOpacity(0.9),
    );

    final boxW = world.fieldWidth * 0.15;
    final boxH = world.fieldHeight * 0.42;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(b + boxW / 2, world.fieldHeight / 2),
        width: boxW,
        height: boxH,
      ),
      thin,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(world.fieldWidth - b - boxW / 2, world.fieldHeight / 2),
        width: boxW,
        height: boxH,
      ),
      thin,
    );
  }

  void _drawGoals(Canvas canvas) {
    final goalTop = world.fieldHeight * 0.5 - world.fieldHeight * 0.17;
    final goalBottom = world.fieldHeight * 0.5 + world.fieldHeight * 0.17;

    final redGoal = Paint()
      ..color = const Color(0xFFFB7185)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final blueGoal = Paint()
      ..color = const Color(0xFF60A5FA)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(world.border, goalTop),
      Offset(world.border, goalBottom),
      redGoal,
    );

    canvas.drawLine(
      Offset(world.fieldWidth - world.border, goalTop),
      Offset(world.fieldWidth - world.border, goalBottom),
      blueGoal,
    );
  }

  void _drawScore(Canvas canvas) {
    final panel = Rect.fromCenter(
      center: Offset(world.fieldWidth / 2, world.fieldHeight * 0.09),
      width: world.fieldWidth * 0.25,
      height: world.fieldHeight * 0.105,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(panel, const Radius.circular(18)),
      Paint()..color = Colors.black.withOpacity(0.34),
    );

    _centerText(
      canvas,
      '${world.redScore}  -  ${world.blueScore}',
      panel.center,
      Colors.white,
      world.fieldHeight * 0.055,
      FontWeight.w900,
    );

    _centerText(
      canvas,
      'RED',
      Offset(panel.left + panel.width * 0.22, panel.bottom + 12),
      const Color(0xFFFF8A9A),
      world.fieldHeight * 0.024,
      FontWeight.w900,
    );

    _centerText(
      canvas,
      'BLUE',
      Offset(panel.right - panel.width * 0.22, panel.bottom + 12),
      const Color(0xFF93C5FD),
      world.fieldHeight * 0.024,
      FontWeight.w900,
    );
  }

  void _drawPlayers(Canvas canvas) {
    for (final p in world.players) {
      _drawPlayer(canvas, p);
    }
  }

  void _drawPlayer(Canvas canvas, PlayerDisk p) {
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.35)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);

    canvas.drawCircle(p.pos + const Offset(3, 4), p.radius, shadow);

    final body = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(p.color, Colors.white, 0.25)!,
          p.color,
          Color.lerp(p.color, Colors.black, 0.35)!,
        ],
      ).createShader(
        Rect.fromCircle(center: p.pos, radius: p.radius),
      );

    canvas.drawCircle(p.pos, p.radius, body);

    canvas.drawCircle(
      p.pos,
      p.radius,
      Paint()
        ..color = Colors.white.withOpacity(0.88)
        ..strokeWidth = 2.3
        ..style = PaintingStyle.stroke,
    );

    if (world.holderId == p.id) {
      canvas.drawCircle(
        p.pos,
        p.radius + 5,
        Paint()
          ..color = Colors.yellowAccent.withOpacity(0.85)
          ..strokeWidth = 2.2
          ..style = PaintingStyle.stroke,
      );
    }

    _centerText(
      canvas,
      p.name,
      Offset(p.pos.dx, p.pos.dy - p.radius - 12),
      Colors.white,
      world.fieldHeight * 0.026,
      FontWeight.w900,
    );
  }

  void _drawBall(Canvas canvas) {
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.40)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);

    canvas.drawCircle(world.ball + const Offset(3, 4), world.ballRadius, shadow);

    final ballPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Colors.grey.shade300,
          Colors.grey.shade700,
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
        ..color = Colors.black.withOpacity(0.55)
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawControls(Canvas canvas) {
    final joyCenter = world._joystickCenter();
    final joyRadius = world.fieldHeight * 0.115;

    canvas.drawCircle(
      joyCenter,
      joyRadius,
      Paint()..color = Colors.black.withOpacity(0.28),
    );

    canvas.drawCircle(
      joyCenter,
      joyRadius,
      Paint()
        ..color = Colors.white.withOpacity(0.20)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    Offset knob = joyCenter;

    if (world._length(world.joystickVector) > 0) {
      knob += world.joystickVector * (joyRadius * 0.62);
    }

    canvas.drawCircle(
      knob,
      joyRadius * 0.42,
      Paint()..color = Colors.white.withOpacity(0.38),
    );

    _drawButton(
      canvas,
      world.shootButton,
      'SHOT',
      const Color(0xFFE11D48),
      world.fieldHeight * 0.030,
    );

    _drawButton(
      canvas,
      world.passButton,
      'PASS',
      const Color(0xFF2563EB),
      world.fieldHeight * 0.025,
    );

    _drawButton(
      canvas,
      world.powerButton,
      'POWER',
      const Color(0xFFF97316),
      world.fieldHeight * 0.023,
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
      Paint()..color = Colors.black.withOpacity(0.25),
    );

    canvas.drawCircle(
      rect.center,
      rect.width / 2 - 3,
      Paint()..color = color.withOpacity(0.88),
    );

    canvas.drawCircle(
      rect.center,
      rect.width / 2 - 3,
      Paint()
        ..color = Colors.white.withOpacity(0.32)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    _centerText(
      canvas,
      label,
      rect.center,
      Colors.white,
      fontSize,
      FontWeight.w900,
    );
  }

  void _centerText(
    Canvas canvas,
    String text,
    Offset center,
    Color color,
    double size,
    FontWeight weight,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: weight,
          shadows: const [
            Shadow(
              color: Colors.black54,
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        center.dx - painter.width / 2,
        center.dy - painter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant FireballPainter oldDelegate) => true;
}
