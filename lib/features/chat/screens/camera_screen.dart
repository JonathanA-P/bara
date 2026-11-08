import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isFrontCamera = true;
  int _flashMode = 0; // 0: Off, 1: On, 2: Auto
  double _zoomLevel = 1.0;
  bool _showShutterFlash = false;
  bool _isCapturedPreview = false;
  int _selectedPresetIndex = 0;

  final List<Map<String, String>> _photoPresets = const [
    {
      'asset': 'assets/images/userLogo.png',
      'label': 'Kamera Depan (Potret)',
    },
    {
      'asset': 'assets/images/CloudArt_margin.png',
      'label': 'Kamera Belakang (Catatan & Grafik)',
    },
    {
      'asset': 'assets/images/Home1.png',
      'label': 'Suasana Kelas FILKOM',
    },
    {
      'asset': 'assets/images/BannerMatkul1.png',
      'label': 'Materi & Buku Kuliah',
    },
  ];

  String get _currentAsset => _photoPresets[_selectedPresetIndex]['asset']!;

  void _toggleCameraDirection() {
    HapticFeedback.selectionClick();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _selectedPresetIndex = _isFrontCamera ? 0 : 1;
      _zoomLevel = 1.0;
    });
  }

  void _cycleFlashMode() {
    HapticFeedback.selectionClick();
    setState(() {
      _flashMode = (_flashMode + 1) % 3;
    });
  }

  Future<void> _capturePhoto() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _showShutterFlash = true;
    });
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() {
      _showShutterFlash = false;
      _isCapturedPreview = true;
    });
  }

  void _openGallerySheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Pilih dari Galeri Perangkat',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _photoPresets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final item = _photoPresets[index];
                    final isSelected = _selectedPresetIndex == index;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedPresetIndex = index;
                          _isCapturedPreview = true;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF60A5FA)
                                : Colors.white24,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              item['asset']!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                color: Colors.black.withValues(alpha: 0.6),
                                child: Text(
                                  item['label']!,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData get _flashIcon {
    switch (_flashMode) {
      case 1:
        return Icons.flash_on_rounded;
      case 2:
        return Icons.flash_auto_rounded;
      default:
        return Icons.flash_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 1. Camera Viewfinder with live zoom & flip animation
            Positioned.fill(
              child: AnimatedScale(
                scale: _zoomLevel,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  child: Image.asset(
                    _currentAsset,
                    key: ValueKey(_currentAsset),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1E293B),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.white30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Slight overlay gradient for UI controls visibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.38),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.68),
                    ],
                    stops: const [0.0, 0.2, 0.68, 1.0],
                  ),
                ),
              ),
            ),

            // White Shutter Flash Effect
            if (_showShutterFlash)
              Positioned.fill(
                child: Container(color: Colors.white.withValues(alpha: 0.85)),
              ),

            // 2. Top Bar (Back Button + Flash Toggle)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_isCapturedPreview) {
                        setState(() => _isCapturedPreview = false);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                  if (!_isCapturedPreview)
                    GestureDetector(
                      onTap: _cycleFlashMode,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _flashMode > 0
                              ? const Color(0xFFF59E0B)
                              : Colors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _flashIcon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 3. Bottom Controls Area (Live Camera Controls OR Post-Capture Confirm)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: _isCapturedPreview
                  ? _buildCapturedConfirmBar()
                  : _buildLiveCameraControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveCameraControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom selector pills (1x / 1.5x / 2x)
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [1.0, 1.3, 1.8].map((z) {
              final isSelected = _zoomLevel == z;
              final label = z == 1.0 ? '1x' : (z == 1.3 ? '1.5x' : '2x');
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _zoomLevel = z);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFF60A5FA)
                          : Colors.white70,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gallery Icon Button
              GestureDetector(
                onTap: _openGallerySheet,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              // Shutter Button (White circle with outer border)
              GestureDetector(
                onTap: _capturePhoto,
                child: Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.5,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // Flip Camera Button
              GestureDetector(
                onTap: _toggleCameraDirection,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cameraswitch_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Bottom Mode Label (Foto)
        Text(
          'Foto',
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF60A5FA),
          ),
        ),
      ],
    );
  }

  Widget _buildCapturedConfirmBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white70, width: 1.4),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => _isCapturedPreview = false);
              },
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              label: Text(
                'Ulangi',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C7BB8),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context, _currentAsset);
              },
              icon: const Icon(Icons.check, color: Colors.white, size: 18),
              label: Text(
                'Gunakan Foto',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
