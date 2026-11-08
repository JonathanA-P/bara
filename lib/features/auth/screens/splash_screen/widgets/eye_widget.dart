import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EyeWidget extends StatelessWidget {
  final double size;
  final String pupilAsset;
  final String? nextPupilAsset;
  final double crossfade;
  final Alignment pupilAlignment;
  final bool mirror;
  final Color eyeColor;

  const EyeWidget({
    super.key,
    required this.size,
    required this.pupilAsset,
    required this.pupilAlignment,
    required this.eyeColor,
    this.nextPupilAsset,
    this.crossfade = 0,
    this.mirror = false,
  });

  @override
  Widget build(BuildContext context) {
    final pupilSize = size * 0.5;

    return Transform(
      alignment: Alignment.center,
      transform: mirror ? (Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0)) : Matrix4.identity(),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(color: eyeColor, shape: BoxShape.circle),
            ),
            Align(
              alignment: pupilAlignment,
              child: SizedBox(
                width: pupilSize,
                height: pupilSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 1 - crossfade,
                      child: SvgPicture.asset(pupilAsset, fit: BoxFit.contain),
                    ),
                    if (nextPupilAsset != null)
                      Opacity(
                        opacity: crossfade,
                        child: SvgPicture.asset(nextPupilAsset!, fit: BoxFit.contain),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}