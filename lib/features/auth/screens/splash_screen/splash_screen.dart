import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../onboarding/onboarding_screen.dart';
import 'widgets/bara_text.dart';
import 'widgets/circle_reveal_clipper.dart';

const _kPrimaryBlue = Color(0xFF2163AE);
const _kStarOrange = Color(0xFFE57C35);
const _kStarYellow = Color(0xFFFDA63F);

/// SVG of the HiGavi mascot without the background rectangle, in the exact
/// 241x241 coordinate space so it fades in seamlessly around the animated eyes.
const String _kMascotBodySvg = '''
<svg width="241" height="241" viewBox="0 0 241 241" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M23.6152 146.07L41.6902 148.962" stroke="white" stroke-width="7.712" stroke-linecap="round"/>
<path d="M27.7129 165.738L44.9937 159.701" stroke="white" stroke-width="7.712" stroke-linecap="round"/>
<path d="M222.37 146.07L204.295 148.962" stroke="white" stroke-width="7.712" stroke-linecap="round"/>
<path d="M218.274 165.738L200.994 159.701" stroke="white" stroke-width="7.712" stroke-linecap="round"/>
<path d="M169.528 118.523C168.552 116.838 165.978 117.497 165.932 119.443L165.719 128.391C165.706 128.941 165.458 129.46 165.038 129.816L158.372 135.469C157.146 136.509 157.656 138.505 159.232 138.828L168.159 140.659C168.476 140.724 168.772 140.868 169.019 141.077L173.063 144.507C174.157 145.434 175.845 144.885 176.183 143.491L177.242 139.129C177.338 138.732 177.558 138.377 177.869 138.113L184.717 132.306C185.943 131.266 185.432 129.27 183.857 128.947L175.294 127.191C174.755 127.08 174.289 126.744 174.013 126.268L169.528 118.523Z" fill="#FDA63F"/>
<path d="M75.951 118.523C76.9267 116.838 79.5006 117.497 79.5469 119.443L79.7596 128.391C79.7727 128.941 80.0203 129.46 80.44 129.816L87.1065 135.469C88.3329 136.509 87.8221 138.505 86.2468 138.828L77.3197 140.659C77.0026 140.724 76.7069 140.868 76.46 141.077L72.4159 144.507C71.3218 145.434 69.6337 144.885 69.2953 143.491L68.2363 139.129C68.1401 138.732 67.9208 138.377 67.6098 138.113L60.762 132.306C59.5355 131.266 60.0464 129.27 61.6217 128.947L70.1846 127.191C70.7238 127.08 71.19 126.744 71.4658 126.268L75.951 118.523Z" fill="#FDA63F"/>
<path d="M170.185 46.7786C178.203 46.9474 196.421 51.4771 205.556 68.47C208.599 73.4291 208.51 84.6881 193.225 96.8509C201.029 109.069 212.702 137.816 203.803 167.352C200.094 180.03 179.079 203.567 125.581 204.151H125.56C112.798 204.151 95.0404 202.709 79.0789 197.476C63.1617 192.258 48.608 183.12 43.0095 167.444C38.9259 156.008 37.9622 142.118 40.114 128.802C42.2655 115.49 47.5601 102.575 56.1775 93.1917C64.5167 84.1114 86.6226 70.2806 117.606 68.6887V81.9632H105.075C102.413 81.9632 100.255 84.1217 100.255 86.7835C100.255 89.4454 102.413 91.6037 105.075 91.6038H117.606V100.521H111.82C109.158 100.521 107 102.679 107 105.341C107 108.003 109.158 110.161 111.82 110.161H117.606V113.776C117.606 116.97 120.196 119.56 123.39 119.56C126.585 119.56 129.174 116.97 129.175 113.776V110.161H134.961C137.623 110.161 139.781 108.003 139.781 105.341C139.781 102.679 137.623 100.521 134.961 100.521H129.175V91.6038H141.707C144.369 91.6038 146.527 89.4455 146.527 86.7835C146.527 84.1217 144.369 81.9632 141.707 81.9632H129.175V68.677C136.198 69.0173 143.596 70.0018 151.321 71.7952C151.41 67.4078 152.203 61.8405 154.384 57.0735C155.707 54.1807 157.584 51.4884 160.218 49.5706C162.868 47.6402 166.176 46.5775 170.185 46.7786ZM123.15 152.818C121.157 152.818 119.54 154.431 119.535 156.423L119.293 156.433C119.293 157.263 119.291 158.457 119.371 159.795C119.217 163.206 118.233 164.482 117.739 164.851C117.26 165.209 115.889 165.634 113.213 164.148C111.351 163.114 109.003 163.784 107.969 165.646C106.934 167.507 107.605 169.856 109.467 170.89C113.297 173.018 118.313 174.046 122.352 171.031C122.626 170.826 122.886 170.607 123.135 170.377C124.145 171.376 125.44 172.194 127.086 172.61C129.978 173.339 133.145 172.616 136.441 170.968C138.346 170.016 139.118 167.699 138.166 165.794C137.213 163.89 134.897 163.117 132.992 164.07C130.505 165.313 129.334 165.223 128.972 165.132C128.763 165.079 128.442 164.944 128.051 164.153C127.622 163.287 127.325 162.023 127.164 160.504C127.133 160.213 127.109 159.924 127.089 159.638C127.12 158.512 127.088 157.34 126.993 156.131L126.752 156.14C126.602 154.281 125.048 152.818 123.15 152.818ZM81.1111 111.247C69.7212 107.839 56.9879 116.771 52.6707 131.199C48.3535 145.626 59.2379 139.79 70.6277 143.199C82.0175 146.607 89.5995 157.968 93.9168 143.541C98.2339 129.114 92.5009 114.656 81.1111 111.247ZM193.277 131.199C188.96 116.771 176.227 107.839 164.837 111.247C153.447 114.656 147.714 129.114 152.031 143.541C156.348 157.968 163.93 146.607 175.32 143.199C186.71 139.79 197.594 145.626 193.277 131.199Z" fill="white"/>
<path d="M27.3088 42.8412C20.5201 64.9047 37.0924 71.19 46.5149 71.3718C46.5149 71.3718 51.3588 70.7618 54.4407 69.4307C59.0651 67.4334 62.9309 64.2816 62.9309 64.2816C79.9465 44.907 58.1358 28.6917 45.1322 23.0722C47.2462 27.9668 47.9709 32.4444 46.9361 36.953C47.5101 30.328 42.5651 27.5401 40.2302 26.4609C31.5204 22.4349 30.0288 17.5624 29.8085 14.6588C23.4059 23.2546 26.6392 28.922 28.8524 30.6729C34.2158 34.9158 33.1795 41.7882 32.0515 45.1603C32.9191 41.3693 27.6323 39.1713 27.6323 39.1713C27.6323 39.1713 27.7533 41.3966 27.3088 42.8412Z" fill="#FDA63F"/>
<path d="M36.4933 89.756C39.7266 94.9806 46.957 95.8876 51.3806 91.6236L66.9263 76.6389C70.1945 73.4886 70.8222 68.4852 68.4334 64.6253L61.5064 53.4323C58.3098 48.2671 51.1905 47.3098 46.7431 51.4473L30.9922 66.1006C27.6218 69.2361 26.9386 74.3171 29.3611 78.2316L36.4933 89.756Z" fill="white"/>
<path d="M71.2896 41.6789C75.589 40.0933 80.4112 41.753 82.8228 45.6496L89.939 57.1486C93.1853 62.3941 90.7373 69.2967 84.9117 71.3254L65.6392 78.0373C61.3736 79.5227 56.648 77.8468 54.271 74.006L47.355 62.8302C44.1465 57.6458 46.496 50.8217 52.2163 48.7121L67.5708 43.05L67.4302 43.13L78.3726 62.3927L78.1773 65.214C78.0873 66.5096 79.4332 67.4167 80.6001 66.8468L83.2261 65.5646C84.3928 64.9947 84.505 63.3762 83.4283 62.6506L81.0054 61.0177C80.9609 60.9877 80.9154 60.9599 80.8697 60.9347L70.1665 42.092L71.2896 41.6789Z" fill="white"/>
<path d="M34.1451 175.603C37.8391 175.266 43.8894 175.533 47.6543 175.876C68.3688 177.76 90.1652 184.836 107.255 196.832C111.696 199.95 119.437 206.699 120.175 212.123C120.313 213.133 120.465 220.049 120.087 220.563C119.446 220.455 118.205 219.029 117.626 218.483C116.092 217.034 114.503 215.746 112.838 214.453C91.9274 198.582 65.3118 193.884 39.5638 193.15C33.2288 192.971 27.4885 193.351 21.2075 193.68L25.9776 176.358C28.6895 176.003 31.4139 175.752 34.1451 175.603Z" fill="#FDA63F"/>
<path d="M205.813 175.451C210.354 175.412 214.892 175.719 219.387 176.373C220.775 181.945 222.613 188.109 224.143 193.706C218.036 193.577 212.604 192.977 206.272 193.139C181.858 193.762 156.211 198.205 135.716 212.166C131.08 215.462 129.383 217.22 125.306 220.879C125.295 220.691 125.285 220.501 125.278 220.313C125.01 212.522 124.612 209.611 130.31 203.745C143.421 190.248 165.97 181.527 183.979 177.899C191.167 176.423 198.475 175.603 205.813 175.451Z" fill="#FDA63F"/>
</svg>
''';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const int _kTotalDurationMs = 6200;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kTotalDurationMs),
    );

    // Wait until the first Flutter frame is rendered AND the Android native
    // launch screen has completely faded out before starting the animation,
    // so the eye-glancing sequence is never missed on cold start.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 420), () {
        if (mounted) {
          _controller.forward();
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 450),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _segment(double startMs, double endMs) {
    final tMs = _controller.value * _kTotalDurationMs;
    if (tMs <= startMs) return 0.0;
    if (tMs >= endMs) return 1.0;
    return (tMs - startMs) / (endMs - startMs);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = screenSize.longestSide * 1.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // 1. Pupil glancing:
          //    0ms - 320ms: Hold at bottom-right so user clearly sees the initial pose
          //    320ms - 880ms: Glance left
          //    880ms - 1080ms: Hold at left
          //    1080ms - 1600ms: Glance back to center
          final glanceLeft = Curves.easeInOutCubic.transform(_segment(320, 880));
          final glanceCenter = Curves.easeInOutCubic.transform(_segment(1080, 1600));

          double pupilDx = 6.5 * (1.0 - glanceLeft) + (-8.0 * glanceLeft);
          pupilDx = ui.lerpDouble(pupilDx, 0.0, glanceCenter)!;

          double pupilDy = 4.5 * (1.0 - glanceLeft) + (2.0 * glanceLeft);
          pupilDy = ui.lerpDouble(pupilDy, 0.0, glanceCenter)!;

          // 2. Eye bottom lid squinting (happy smile curve matching logo.svg)
          final squintProgress = Curves.easeInOutCubic.transform(_segment(1800, 2200));

          // 3. Star morphing from 4-point orange star to 3-point yellow star
          final starMorph = Curves.easeInOut.transform(_segment(2150, 2550));

          // 4. Screen background crossfades smoothly from White to Primary Blue
          final bgBlueFade = Curves.easeInOut.transform(_segment(2350, 2880));

          // 5. Mascot body fades in at full zoomed-in scale around the yellow stars
          final mascotFade = Curves.easeInOut.transform(_segment(3250, 3580));

          // 6. Mascot zooms out from large scale (2.22x) to normal center scale (1.0x)
          final zoomOut = Curves.easeInOutCubic.transform(_segment(3540, 3950));
          final currentScale = ui.lerpDouble(2.22, 1.0, zoomOut)!;

          // 7. "HiGavi" text fades in at bottom
          final textFade = Curves.easeOut.transform(_segment(4600, 5050));

          // 8. White circular wipe expanding from bottom-left corner to transition out
          final whiteWipe = Curves.easeInOutCubic.transform(_segment(5450, 5950));

          final bgColor = Color.lerp(Colors.white, _kPrimaryBlue, bgBlueFade)!;

          return Stack(
            children: [
              // Layer 1: Background transitioning from White to Blue
              Container(color: bgColor),

              // Layer 2: Centered 241x241 Mascot & Eyes Canvas
              Positioned.fill(
                child: Center(
                  child: Transform.scale(
                    scale: currentScale,
                    child: SizedBox(
                      width: 185,
                      height: 185,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Animated Eyes & Stars (in exact 241x241 coordinates)
                          CustomPaint(
                            painter: _MascotEyesPainter(
                              squint: squintProgress,
                              pupilOffset: Offset(pupilDx, pupilDy),
                              starMorph: starMorph,
                            ),
                          ),

                          // Full Mascot Body fading in around the eyes
                          if (mascotFade > 0)
                            Opacity(
                              opacity: mascotFade,
                              child: SvgPicture.string(
                                _kMascotBodySvg,
                                width: 185,
                                height: 185,
                                fit: BoxFit.contain,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Layer 3: Bottom "HiGavi" Text
              Positioned(
                bottom: 58,
                left: 0,
                right: 0,
                child: Center(
                  child: BaraText(opacity: textFade),
                ),
              ),

              // Layer 4: White Circle Reveal Wipe from Bottom-Left Corner
              if (whiteWipe > 0)
                ClipPath(
                  clipper: CircleRevealClipper(
                    center: Offset(0, screenSize.height),
                    progress: whiteWipe,
                    maxRadius: maxRadius,
                  ),
                  child: Container(color: Colors.white),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MascotEyesPainter extends CustomPainter {
  final double squint;
  final Offset pupilOffset;
  final double starMorph;

  const _MascotEyesPainter({
    required this.squint,
    required this.pupilOffset,
    required this.starMorph,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Scale canvas to the 241x241 coordinate system of logo.svg
    final sx = size.width / 241.0;
    final sy = size.height / 241.0;
    canvas.scale(sx, sy);

    final eyePaint = Paint()
      ..color = _kPrimaryBlue
      ..style = PaintingStyle.fill;

    // --- LEFT EYE PATH (Morphs from open oval to squinting smile curve) ---
    final leftEye = Path()
      ..moveTo(81.1111, 111.247)
      ..cubicTo(69.7212, 107.839, 56.9879, 116.771, 52.6707, 131.199)
      ..cubicTo(
        48.3535,
        145.626,
        ui.lerpDouble(55.0, 59.2379, squint)!,
        ui.lerpDouble(158.0, 139.790, squint)!,
        ui.lerpDouble(69.0, 70.6277, squint)!,
        ui.lerpDouble(160.0, 143.199, squint)!,
      )
      ..cubicTo(
        ui.lerpDouble(83.0, 82.0175, squint)!,
        ui.lerpDouble(161.5, 146.607, squint)!,
        89.5995,
        157.968,
        93.9168,
        143.541,
      )
      ..cubicTo(98.2339, 129.114, 92.5009, 114.656, 81.1111, 111.247)
      ..close();

    // --- RIGHT EYE PATH (Morphs from open oval to squinting smile curve) ---
    final rightEye = Path()
      ..moveTo(193.277, 131.199)
      ..cubicTo(188.960, 116.771, 176.227, 107.839, 164.837, 111.247)
      ..cubicTo(153.447, 114.656, 147.714, 129.114, 152.031, 143.541)
      ..cubicTo(
        156.348,
        157.968,
        ui.lerpDouble(162.95, 163.930, squint)!,
        ui.lerpDouble(161.5, 146.607, squint)!,
        ui.lerpDouble(176.95, 175.320, squint)!,
        ui.lerpDouble(160.0, 143.199, squint)!,
      )
      ..cubicTo(
        ui.lerpDouble(190.95, 186.710, squint)!,
        ui.lerpDouble(158.0, 139.790, squint)!,
        197.594,
        145.626,
        193.277,
        131.199,
      )
      ..close();

    canvas.drawPath(leftEye, eyePaint);
    canvas.drawPath(rightEye, eyePaint);

    final starColor = Color.lerp(_kStarOrange, _kStarYellow, starMorph)!;

    // Draw Left Pupil Star clipped to Left Eye
    canvas.save();
    canvas.clipPath(leftEye);
    _drawPupilStars(
      canvas: canvas,
      center: const Offset(74.0, 131.5) + pupilOffset,
      isLeft: true,
      starColor: starColor,
    );
    canvas.restore();

    // Draw Right Pupil Star clipped to Right Eye
    canvas.save();
    canvas.clipPath(rightEye);
    _drawPupilStars(
      canvas: canvas,
      center: const Offset(171.4, 131.5) + pupilOffset,
      isLeft: false,
      starColor: starColor,
    );
    canvas.restore();

    canvas.restore();
  }

  void _drawPupilStars({
    required Canvas canvas,
    required Offset center,
    required bool isLeft,
    required Color starColor,
  }) {
    // 1. 4-point star (visible when starMorph < 1)
    if (starMorph < 1.0) {
      final paint4 = Paint()
        ..color = starColor.withValues(alpha: 1.0 - starMorph)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      final s4 = _buildFourPointStarPath(radiusX: 13.5, radiusY: 14.5);
      canvas.drawPath(s4, paint4);
      canvas.restore();
    }

    // 2. Exact 3-point star from logo.svg (visible when starMorph > 0)
    if (starMorph > 0.0) {
      final paint3 = Paint()
        ..color = starColor.withValues(alpha: starMorph)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(pupilOffset.dx, pupilOffset.dy);
      final s3 = isLeft ? _buildExactLeftStar3() : _buildExactRightStar3();
      canvas.drawPath(s3, paint3);
      canvas.restore();
    }
  }

  Path _buildFourPointStarPath({required double radiusX, required double radiusY}) {
    final p = Path();
    const double inner = 4.2;
    p.moveTo(0, -radiusY);
    p.quadraticBezierTo(inner * 0.4, -inner * 0.4, radiusX, 0);
    p.quadraticBezierTo(inner * 0.4, inner * 0.4, 0, radiusY);
    p.quadraticBezierTo(-inner * 0.4, inner * 0.4, -radiusX, 0);
    p.quadraticBezierTo(-inner * 0.4, -inner * 0.4, 0, -radiusY);
    p.close();
    return p;
  }

  /// Exact path of the Left Eye Star from logo.svg (line 8)
  Path _buildExactLeftStar3() {
    return Path()
      ..moveTo(75.951, 118.523)
      ..cubicTo(76.9267, 116.838, 79.5006, 117.497, 79.5469, 119.443)
      ..lineTo(79.7596, 128.391)
      ..cubicTo(79.7727, 128.941, 80.0203, 129.46, 80.44, 129.816)
      ..lineTo(87.1065, 135.469)
      ..cubicTo(88.3329, 136.509, 87.8221, 138.505, 86.2468, 138.828)
      ..lineTo(77.3197, 140.659)
      ..cubicTo(77.0026, 140.724, 76.7069, 140.868, 76.46, 141.077)
      ..lineTo(72.4159, 144.507)
      ..cubicTo(71.3218, 145.434, 69.6337, 144.885, 69.2953, 143.491)
      ..lineTo(68.2363, 139.129)
      ..cubicTo(68.1401, 138.732, 67.9208, 138.377, 67.6098, 138.113)
      ..lineTo(60.762, 132.306)
      ..cubicTo(59.5355, 131.266, 60.0464, 129.27, 61.6217, 128.947)
      ..lineTo(70.1846, 127.191)
      ..cubicTo(70.7238, 127.08, 71.19, 126.744, 71.4658, 126.268)
      ..lineTo(75.951, 118.523)
      ..close();
  }

  /// Exact path of the Right Eye Star from logo.svg (line 7)
  Path _buildExactRightStar3() {
    return Path()
      ..moveTo(169.528, 118.523)
      ..cubicTo(168.552, 116.838, 165.978, 117.497, 165.932, 119.443)
      ..lineTo(165.719, 128.391)
      ..cubicTo(165.706, 128.941, 165.458, 129.46, 165.038, 129.816)
      ..lineTo(158.372, 135.469)
      ..cubicTo(157.146, 136.509, 157.656, 138.505, 159.232, 138.828)
      ..lineTo(168.159, 140.659)
      ..cubicTo(168.476, 140.724, 168.772, 140.868, 169.019, 141.077)
      ..lineTo(173.063, 144.507)
      ..cubicTo(174.157, 145.434, 175.845, 144.885, 176.183, 143.491)
      ..lineTo(177.242, 139.129)
      ..cubicTo(177.338, 138.732, 177.558, 138.377, 177.869, 138.113)
      ..lineTo(184.717, 132.306)
      ..cubicTo(185.943, 131.266, 185.432, 129.27, 183.857, 128.947)
      ..lineTo(175.294, 127.191)
      ..cubicTo(174.755, 127.08, 174.289, 126.744, 174.013, 126.268)
      ..lineTo(169.528, 118.523)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _MascotEyesPainter oldDelegate) {
    return oldDelegate.squint != squint ||
        oldDelegate.pupilOffset != pupilOffset ||
        oldDelegate.starMorph != starMorph;
  }
}
