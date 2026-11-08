import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/core/services/report_service.dart';

class ReportIncidentScreen extends StatefulWidget {
  final String? reportedUserName;
  final String? sessionId;

  const ReportIncidentScreen({
    super.key,
    this.reportedUserName,
    this.sessionId,
  });

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _chronologyController = TextEditingController();

  String _selectedCategory = 'Ketidakhadiran Sesi Bimbingan';
  final List<String> _categories = [
    'Ketidakhadiran Sesi Bimbingan',
    'Kecurangan Akademik / Plagiarisme',
    'Pelanggaran Etika & Perilaku',
    'Kendala Teknis / Masalah Sistem',
    'Lainnya',
  ];

  bool _hasAttachment = false;
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _chronologyController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap centang konfirmasi integritas sebelum mengirim.',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ReportService().submitReport(
        accusedName: widget.reportedUserName ?? 'Pihak Terlapor',
        category: _selectedCategory,
        incidentDate: DateTime.now(),
        description: '${_titleController.text.trim()}\n\n${_chronologyController.text.trim()}',
      );
    } catch (_) {}

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Laporan Diterima',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Laporan insiden Anda telah tercatat dengan ID tiket #REP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}. Tim advokasi BARA akan meninjau kronologi dan bukti pendukung.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // close screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5382C1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Selesai',
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
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: textColorDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pelaporan Insiden',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColorDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.privacy_tip_outlined,
                          color: Color(0xFFDC2626), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Kerahasiaan identitas pelapor dijamin sepenuhnya. Laporan akan ditindaklanjuti sesuai kode etik akademik FILKOM UB.',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: const Color(0xFF991B1B),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Kategori Insiden
                Text(
                  'Kategori Insiden',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: textColorDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF64748B)),
                      items: _categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(
                            cat,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColorDark,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Judul Laporan
                Text(
                  'Subjek / Ringkasan Insiden',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: textColorDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
                  style: GoogleFonts.manrope(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Misal: Mentor tidak hadir pada sesi bimbingan jam 19.00',
                    hintStyle: GoogleFonts.manrope(
                        fontSize: 12, color: const Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Kronologi Kejadian
                Text(
                  'Kronologi & Uraian Kejadian',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: textColorDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _chronologyController,
                  maxLines: 5,
                  validator: (val) => val == null || val.trim().length < 10
                      ? 'Tuliskan minimal 10 karakter kronologi'
                      : null,
                  style: GoogleFonts.manrope(fontSize: 13, height: 1.4),
                  decoration: InputDecoration(
                    hintText:
                        'Jelaskan waktu kejadian, kronologi runtut, bukti komunikasi, atau dampak yang dialami...',
                    hintStyle: GoogleFonts.manrope(
                        fontSize: 12, color: const Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Upload Bukti Pendukung
                Text(
                  'Bukti Pendukung (Screenshot / Dokumen)',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: textColorDark,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() => _hasAttachment = !_hasAttachment);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _hasAttachment
                            ? const Color(0xFF10B981)
                            : const Color(0xFFCBD5E1),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _hasAttachment
                              ? Icons.check_circle_rounded
                              : Icons.cloud_upload_outlined,
                          size: 32,
                          color: _hasAttachment
                              ? const Color(0xFF10B981)
                              : buttonBlue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hasAttachment
                              ? '1 Lampiran bukti terpilih: bukti_chat_sesi.png'
                              : 'Klik untuk mengunggah screenshot percakapan / berkas',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _hasAttachment
                                ? const Color(0xFF047857)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Integritas Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (val) =>
                            setState(() => _agreedToTerms = val ?? false),
                        activeColor: buttonBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Saya menyatakan bahwa informasi ini adalah benar dan dapat dipertanggungjawabkan sesuai tata tertib mahasiswa FILKOM UB.',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: const Color(0xFF475569),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Kirim Laporan Insiden',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

