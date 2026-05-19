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
      backgroundColor: const Color(0xFF161616),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEAEAEA),
                border: Border.all(color: Colors.black, width: 5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer_rounded,
                color: Color(0xFF202020),
                size: 48,
              ),
            ),
            const SizedBox(width: 24),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FIREBALL',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohammed BELKEBIR ABDELKARIM',
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
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
      backgroundColor: const Color(0xFF191919),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF242424),
                  border: Border.all(color: const Color(0xFF555555), width: 1),
                ),
                padding: const EdgeInsets.all(28),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fireball',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'نسخة لعب أفقية بإحساس أقرب إلى ألعاب الدوائر الكلاسيكية: ملعب كامل، سرعة أهدأ، لاعبون أصغر، واحتكاك كرة طبيعي.',
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Color(0xFFCFCFCF),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Prototype v0.3',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 22),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MenuButton(
                    title: 'لعب تجريبي',
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFF3D6FA7),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GameScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    title: 'إنشاء غرفة Wi-Fi',
                    icon: Icons.wifi_tethering_rounded,
                    color: const Color(0xFF4B7B45),
                    onTap: () => _soon(context),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    title: 'الانضمام إلى غرفة',
                    icon: Icons.group_add_rounded,
                    color: const Color(0xFF74508E),
                    onTap: () => _soon(context),
                  ),
                  const SizedBox(height: 14),
                  _MenuButton(
                    title: 'الإعدادات',
                    icon: Icons.tune_rounded,
                    color: const Color(0xFF555555),
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
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
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

      world.update(dt.clamp(0.0, 1 / 45));
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
        backgroundColor: const Color(0xFF303030),
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

  double radius = 15;
}

// ============================================================
// WORLD LOGIC
// ============================================================

class FireballWorld {
  Size screen = Size.zero;

  double fieldWidth = 1000;
  double fieldHeight = 540;

  // الملعب الآن يبدأ من حافة الهاتف إلى حافة الهاتف.
  final double border = 0;

  double playerRadius = 15;
  double ballRadius = 8.5;

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

    // أحجام أقرب إلى Haxball: لاعبون أصغر بكثير وسرعة أهدأ.
    playerRadius = min(fieldWidth, fieldHeight) * 0.034;
    ballRadius = min(fieldWidth, fieldHeight) * 0.020;

    for (final p in players) {
      p.radius = playerRadius;
    }

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
        color: const Color(0xFFD84343),
        isUser: true,
        pos: Offset.zero,
      ),
    );

    players.add(
      PlayerDisk(
        id: 1,
        name: 'R2',
        team: Team.red,
        color: const Color(0xFFE57373),
        isUser: false,
        pos: Offset.zero,
      ),
    );

    players.add(
      PlayerDisk(
        id: 2,
        name: 'B1',
        team: Team.blue,
        color: const Color(0xFF3F70C8),
        isUser: false,
        pos: Offset.zero,
      ),
    );

    players.add(
      PlayerDisk(
        id: 3,
        name: 'B2',
        team: Team.blue,
        color: const Color(0xFF64A2E8),
        isUser: false,
        pos: Offset.zero,
      ),
    );

    for (final p in players) {
      p.radius = playerRadius;
    }
  }

  void resetPositions({bool fullReset = false}) {
    ball = Offset(fieldWidth * 0.5, fieldHeight * 0.5);
    ballVelocity = Offset.zero;
    holderId = null;

    players[0].pos = Offset(fieldWidth * 0.30, fieldHeight * 0.50);
    players[1].pos = Offset(fieldWidth * 0.38, fieldHeight * 0.34);
    players[2].pos = Offset(fieldWidth * 0.70, fieldHeight * 0.50);
    players[3].pos = Offset(fieldWidth * 0.62, fieldHeight * 0.66);

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
    // سرعة أهدأ بكثير من النسخة السابقة.
    final speed = fieldWidth * 0.38;

    if (_length(joystickVector) > 0.05) {
      final dir = _normalize(joystickVector);
      lastAim = dir;
      user.vel = dir * speed;
    } else {
      user.vel = user.vel * 0.86;
      if (_length(user.vel) < 4) user.vel = Offset.zero;
    }

    user.pos += user.vel * dt;
    user.pos = _clampInside(user.pos, user.radius);
  }

  void _updateAI(double dt) {
    final redMate = players[1];
    final blue1 = players[2];
    final blue2 = players[3];

    final support = Offset(fieldWidth * 0.55, fieldHeight * 0.34);
    _moveAI(redMate, support, dt, 0.34);

    final target = holderId == null ? ball : _holder().pos;

    _moveAI(
      blue1,
      target + Offset(-fieldWidth * 0.035, -fieldHeight * 0.035),
      dt,
      0.36,
    );

    _moveAI(
      blue2,
      target + Offset(-fieldWidth * 0.055, fieldHeight * 0.075),
      dt,
      0.33,
    );

    if (holderId == blue1.id || holderId == blue2.id) {
      final h = _holder();
      final goal = Offset(0, fieldHeight * 0.5);
      final dir = _normalize(goal - h.pos);

      h.vel = dir * fieldWidth * 0.25;

      if (h.pos.dx < fieldWidth * 0.44) {
        _releaseBall(dir * fieldWidth * 0.74);
      }
    }
  }

  void _moveAI(PlayerDisk p, Offset target, double dt, double speedFactor) {
    final to = target - p.pos;
    final distance = _length(to);

    if (distance > 8) {
      final dir = _normalize(to);
      p.vel = dir * fieldWidth * speedFactor;
    } else {
      p.vel *= 0.78;
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
        final minDist = a.radius + b.radius + 1.2;

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

    // احتكاك أقوى قليلا حتى لا تكون الكرة مجنونة وسريعة.
    ballVelocity *= pow(0.974, dt * 60).toDouble();

    if (_length(ballVelocity) < 4) {
      ballVelocity = Offset.zero;
    }

    final goalTop = fieldHeight * 0.5 - fieldHeight * 0.18;
    final goalBottom = fieldHeight * 0.5 + fieldHeight * 0.18;
    final insideGoal = ball.dy > goalTop && ball.dy < goalBottom;

    if (ball.dy - ballRadius < 0) {
      ball = Offset(ball.dx, ballRadius);
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy * 0.78);
    }

    if (ball.dy + ballRadius > fieldHeight) {
      ball = Offset(ball.dx, fieldHeight - ballRadius);
      ballVelocity = Offset(ballVelocity.dx, -ballVelocity.dy * 0.78);
    }

    if (!insideGoal) {
      if (ball.dx - ballRadius < 0) {
        ball = Offset(ballRadius, ball.dy);
        ballVelocity = Offset(-ballVelocity.dx * 0.78, ballVelocity.dy);
      }

      if (ball.dx + ballRadius > fieldWidth) {
        ball = Offset(fieldWidth - ballRadius, ball.dy);
        ballVelocity = Offset(-ballVelocity.dx * 0.78, ballVelocity.dy);
      }
    }
  }

  void _tryTakePossession() {
    if (holderId != null) return;

    PlayerDisk? closest;
    double best = 999999;

    for (final p in players) {
      final d = _length(ball - p.pos);
      final takeDistance = p.radius + ballRadius + 7;

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
          ? Offset(fieldWidth, fieldHeight * 0.5)
          : Offset(0, fieldHeight * 0.5);
      aim = _normalize(enemyGoal - h.pos);
    }

    if (_length(aim) == 0) {
      aim = h.team == Team.red ? const Offset(1, 0) : const Offset(-1, 0);
    }

    // الكرة تبقى أمام اللاعب بمسافة صغيرة، لا تلصق ولا تهرب.
    final carryDistance = h.radius + ballRadius + 2.5;
    ball = h.pos + aim * carryDistance;
  }

  void _checkGoals() {
    final goalTop = fieldHeight * 0.5 - fieldHeight * 0.18;
    final goalBottom = fieldHeight * 0.5 + fieldHeight * 0.18;
    final inGoalY = ball.dy > goalTop && ball.dy < goalBottom;

    if (!inGoalY) return;

    if (ball.dx < -ballRadius * 0.2) {
      blueScore++;
      resetPositions();
    }

    if (ball.dx > fieldWidth + ballRadius * 0.2) {
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
    ballVelocity = dir * fieldWidth * 0.66;
  }

  void shoot({required bool power}) {
    if (!_userCanKick()) return;

    final goal = Offset(fieldWidth, fieldHeight * 0.5);

    Offset dir;

    if (_length(joystickVector) > 0.08) {
      final manual = _normalize(joystickVector);
      final toGoal = _normalize(goal - ball);
      dir = _normalize(manual * 0.72 + toGoal * 0.28);
    } else {
      dir = _normalize(goal - ball);
    }

    final force = power ? fieldWidth * 1.08 : fieldWidth * 0.82;

    holderId = null;
    ballVelocity = dir * force;
  }

  bool _userCanKick() {
    if (holderId == user.id) return true;

    final d = _length(ball - user.pos);
    return d < user.radius + ballRadius + 14;
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

    if (_length(position - joyCenter) < fieldHeight * 0.24) {
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
    return Offset(fieldWidth * 0.13, fieldHeight * 0.77);
  }

  void _updateJoystick(Offset position) {
    final center = _joystickCenter();
    final delta = position - center;
    final maxDistance = fieldHeight * 0.105;

    if (_length(delta) > maxDistance) {
      joystickVector = _normalize(delta);
    } else {
      joystickVector = delta / maxDistance;
    }
  }

  void _updateButtons() {
    final r = fieldHeight * 0.092;

    shootButton = Rect.fromCircle(
      center: Offset(fieldWidth * 0.88, fieldHeight * 0.73),
      radius: r,
    );

    passButton = Rect.fromCircle(
      center: Offset(fieldWidth * 0.76, fieldHeight * 0.80),
      radius: r * 0.80,
    );

    powerButton = Rect.fromCircle(
      center: Offset(fieldWidth * 0.77, fieldHeight * 0.58),
      radius: r * 0.82,
    );
  }

  Offset _clampInside(Offset p, double radius) {
    return Offset(
      p.dx.clamp(radius, fieldWidth - radius).toDouble(),
      p.dy.clamp(radius, fieldHeight - radius).toDouble(),
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
    _drawField(canvas);
    _drawGoals(canvas);
    _drawScore(canvas);
    _drawPlayers(canvas);
    _drawBall(canvas);
    _drawControls(canvas);
  }

  void _drawField(Canvas canvas) {
    // لون قريب من ملاعب Haxball الكلاسيكية: أخضر مسطح بدون فخامة زائدة.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, world.fieldWidth, world.fieldHeight),
      Paint()..color = const Color(0xFF5C8F4B),
    );

    final line = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    final thin = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke;

    // حدود الملعب على حواف الهاتف تماما.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, world.fieldWidth, world.fieldHeight),
      line,
    );

    canvas.drawLine(
      Offset(world.fieldWidth / 2, 0),
      Offset(world.fieldWidth / 2, world.fieldHeight),
      thin,
    );

    canvas.drawCircle(
      Offset(world.fieldWidth / 2, world.fieldHeight / 2),
      world.fieldHeight * 0.17,
      thin,
    );

    canvas.drawCircle(
      Offset(world.fieldWidth / 2, world.fieldHeight / 2),
      3.5,
      Paint()..color = Colors.white.withOpacity(0.9),
    );

    final boxW = world.fieldWidth * 0.13;
    final boxH = world.fieldHeight * 0.40;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(boxW / 2, world.fieldHeight / 2),
        width: boxW,
        height: boxH,
      ),
      thin,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(world.fieldWidth - boxW / 2, world.fieldHeight / 2),
        width: boxW,
        height: boxH,
      ),
      thin,
    );
  }

  void _drawGoals(Canvas canvas) {
    final goalTop = world.fieldHeight * 0.5 - world.fieldHeight * 0.18;
    final goalBottom = world.fieldHeight * 0.5 + world.fieldHeight * 0.18;

    final redGoal = Paint()
      ..color = const Color(0xFFD84343)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final blueGoal = Paint()
      ..color = const Color(0xFF3F70C8)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, goalTop),
      Offset(0, goalBottom),
      redGoal,
    );

    canvas.drawLine(
      Offset(world.fieldWidth, goalTop),
      Offset(world.fieldWidth, goalBottom),
      blueGoal,
    );
  }

  void _drawScore(Canvas canvas) {
    final panel = Rect.fromCenter(
      center: Offset(world.fieldWidth / 2, world.fieldHeight * 0.075),
      width: world.fieldWidth * 0.20,
      height: world.fieldHeight * 0.080,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(panel, const Radius.circular(8)),
      Paint()..color = Colors.black.withOpacity(0.30),
    );

    _centerText(
      canvas,
      '${world.redScore}  -  ${world.blueScore}',
      panel.center,
      Colors.white,
      world.fieldHeight * 0.043,
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
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 4);

    canvas.drawCircle(p.pos + const Offset(2, 2), p.radius, shadow);

    final body = Paint()
      ..color = p.color;

    canvas.drawCircle(p.pos, p.radius, body);

    canvas.drawCircle(
      p.pos,
      p.radius,
      Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke,
    );

    if (world.holderId == p.id) {
      canvas.drawCircle(
        p.pos,
        p.radius + 3.5,
        Paint()
          ..color = Colors.yellowAccent.withOpacity(0.82)
          ..strokeWidth = 1.7
          ..style = PaintingStyle.stroke,
      );
    }

    _centerText(
      canvas,
      p.name,
      Offset(p.pos.dx, p.pos.dy - p.radius - 8),
      Colors.white,
      world.fieldHeight * 0.022,
      FontWeight.w800,
    );
  }

  void _drawBall(Canvas canvas) {
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.30)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 4);

    canvas.drawCircle(world.ball + const Offset(2, 2), world.ballRadius, shadow);

    canvas.drawCircle(
      world.ball,
      world.ballRadius,
      Paint()..color = const Color(0xFFECECEC),
    );

    canvas.drawCircle(
      world.ball,
      world.ballRadius,
      Paint()
        ..color = Colors.black.withOpacity(0.55)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawControls(Canvas canvas) {
    final joyCenter = world._joystickCenter();
    final joyRadius = world.fieldHeight * 0.105;

    canvas.drawCircle(
      joyCenter,
      joyRadius,
      Paint()..color = Colors.black.withOpacity(0.18),
    );

    canvas.drawCircle(
      joyCenter,
      joyRadius,
      Paint()
        ..color = Colors.white.withOpacity(0.22)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    Offset knob = joyCenter;

    if (world._length(world.joystickVector) > 0) {
      knob += world.joystickVector * (joyRadius * 0.60);
    }

    canvas.drawCircle(
      knob,
      joyRadius * 0.38,
      Paint()..color = Colors.white.withOpacity(0.34),
    );

    _drawButton(
      canvas,
      world.shootButton,
      'KICK',
      const Color(0xFFD84343),
      world.fieldHeight * 0.027,
    );

    _drawButton(
      canvas,
      world.passButton,
      'PASS',
      const Color(0xFF3F70C8),
      world.fieldHeight * 0.023,
    );

    _drawButton(
      canvas,
      world.powerButton,
      'POWER',
      const Color(0xFFE28A38),
      world.fieldHeight * 0.021,
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
      Paint()..color = Colors.black.withOpacity(0.20),
    );

    canvas.drawCircle(
      rect.center,
      rect.width / 2 - 2,
      Paint()..color = color.withOpacity(0.82),
    );

    canvas.drawCircle(
      rect.center,
      rect.width / 2 - 2,
      Paint()
        ..color = Colors.white.withOpacity(0.28)
        ..strokeWidth = 2
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
              blurRadius: 4,
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
