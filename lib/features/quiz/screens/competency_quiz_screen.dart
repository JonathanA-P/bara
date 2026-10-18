import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bara/core/services/quiz_service.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class CompetencyQuizScreen extends StatefulWidget {
  final String mentorName;
  final String topic;

  const CompetencyQuizScreen({
    super.key,
    this.mentorName = 'Farhan Maulana',
    this.topic = 'Struktur Data & Graf',
  });

  @override
  State<CompetencyQuizScreen> createState() => _CompetencyQuizScreenState();
}

class _CompetencyQuizScreenState extends State<CompetencyQuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;
  bool _isQuizFinished = false;

  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = [
      QuizQuestion(
        question:
            'Struktur data antrian (Queue) paling tepat digunakan untuk algoritma penelusuran graf mana?',
        options: [
          'Depth-First Search (DFS)',
          'Breadth-First Search (BFS)',
          'Dijkstra Shortest Path',
          'Kruskal Minimum Spanning Tree',
        ],
        correctIndex: 1,
      ),
      QuizQuestion(
        question:
            'Kompleksitas waktu rata-rata operasi pencarian pada Balanced Binary Search Tree (AVL / Red-Black) adalah:',
        options: ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
        correctIndex: 2,
      ),
      QuizQuestion(
        question:
            'Apa fungsi utama dari teknik Dynamic Programming dibanding Divide and Conquer biasa?',
        options: [
          'Memecah masalah menjadi sub-masalah acak',
          'Menghindari komputasi berulang dengan menyimpan sub-solusi (Memoization)',
          'Mempercepat kompilasi bahasa C++',
          'Mengurangi penggunaan memori RAM hingga 90%',
        ],
        correctIndex: 1,
      ),
    ];
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final list = await QuizService().getQuizQuestions();
      if (list.isNotEmpty && mounted) {
        setState(() {
          _questions = list.map((q) {
            return QuizQuestion(
              question: q['question'] as String? ?? '',
              options: (q['options'] is List)
                  ? List<String>.from(q['options'])
                  : ['Option A', 'Option B', 'Option C', 'Option D'],
              correctIndex: (q['correct_index'] as num?)?.toInt() ?? 0,
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('[Quiz] Load questions error: $e');
    }
  }

  void _submitAnswer() {
    if (_selectedAnswerIndex == null) return;

    if (_selectedAnswerIndex ==
        _questions[_currentQuestionIndex].correctIndex) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
      });
    } else {
      setState(() {
        _isQuizFinished = true;
      });
      try {
        QuizService().submitQuizAttempt(
          score: _score,
          diagnosticSummary: 'Validasi ${widget.topic}: Skor $_score/${_questions.length}',
        );
      } catch (_) {}
    }
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
          icon: const Icon(Icons.close_rounded,
              color: textColorDark, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Validasi Kompetensi Awal',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: textColorDark,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isQuizFinished
              ? _buildQuizResultView()
              : _buildQuizQuestionView(buttonBlue, textColorDark),
        ),
      ),
    );
  }

  Widget _buildQuizQuestionView(Color buttonBlue, Color textColorDark) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Topic and mentor badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school_rounded,
                  size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 6),
              Text(
                'Topik: ${widget.topic} • ${widget.mentorName}',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Progress bar and counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pertanyaan ${_currentQuestionIndex + 1} dari ${_questions.length}',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: textColorDark,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Selesai',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(buttonBlue),
            minHeight: 8,
          ),
        ),

        const SizedBox(height: 24),

        // Question box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            question.question,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              height: 1.45,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Options
        Expanded(
          child: ListView.separated(
            itemCount: question.options.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final isSelected = _selectedAnswerIndex == index;
              final optionLetter = String.fromCharCode(65 + index);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAnswerIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          optionLetter,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          question.options[index],
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF1E3A8A)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Next / Finish button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _selectedAnswerIndex != null ? _submitAnswer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBlue,
              disabledBackgroundColor: const Color(0xFFCBD5E1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              _currentQuestionIndex < _questions.length - 1
                  ? 'Pertanyaan Selanjutnya'
                  : 'Selesaikan Validasi',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResultView() {
    final percent = ((_score / _questions.length) * 100).toInt();
    final isPassed = percent >= 66;

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isPassed
                    ? const Color(0xFFECFDF5)
                    : const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPassed ? Icons.verified_rounded : Icons.info_outline_rounded,
                color: isPassed
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                size: 56,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isPassed
                  ? 'Kompetensi Tervalidasi!'
                  : 'Perlu Penguatan Materi Dasar',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Skor Pemahaman: $percent% ($_score/${_questions.length} benar)',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isPassed
                    ? const Color(0xFF059669)
                    : const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isPassed
                  ? 'Luar biasa! Pemahaman dasarmu sudah solid untuk memulai sesi bimbingan bersama ${widget.mentorName}.'
                  : 'Hasil kuis ini akan dirangkum untuk ${widget.mentorName} agar sesi bimbingan fokus pada bagian yang belum kamu kuasai.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5382C1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Kembali ke Beranda',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
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
}

