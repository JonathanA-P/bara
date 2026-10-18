import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/live_duration_selector.dart';
import 'package:bara/core/services/discussion_service.dart';

class AddDiscussionScreen extends StatefulWidget {
  const AddDiscussionScreen({super.key});

  @override
  State<AddDiscussionScreen> createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  String _selectedCategory = 'Algorithms';
  String _duration = '3 Hours';
  bool _hasAttachment = true; 
  final List<String> _categories = [
    'Algorithms',
    'Data Structures',
    'Database',
    'AI',
    'Mobile Dev'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBlue = Color(0xFF5382C1);
    const Color textColorDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 110, 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER TOP BAR
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.wifi_tethering_rounded,
                          color: Color(0xFF7C3AED), size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Live Discussion',
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: textColorDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ask questions, share ideas, and receive real-time responses from the community.',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: const Color(0xFF64748B),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded,
                            color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildSectionHeader('Discussion Title', '0/100'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _titleController,
                    onChanged: (val) => setState(() {}),
                    style: GoogleFonts.manrope(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: _inputDecoration(
                      'How do you optimize BFS traversal for large graphs?',
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Category',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: textColorDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        bool isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              cat,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: buttonBlue,
                            backgroundColor: Colors.white,
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? buttonBlue
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildSectionHeader('Description', '0/500'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    onChanged: (val) => setState(() {}),
                    style: GoogleFonts.manrope(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: _inputDecoration(
                      'Provide context, details, code snippets, questions, or discussion topics.',
                    ),
                  ),

                  const SizedBox(height: 20),

                  LiveDurationSelector(
                    onChanged: (val) => setState(() => _duration = val),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Icon(Icons.attach_file_rounded,
                          size: 16, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        'Attachments',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: textColorDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(Optional)',
                        style: GoogleFonts.manrope(
                            fontSize: 11, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildAttachmentButton(
                          Icons.insert_drive_file_outlined, 'Attach File'),
                      const SizedBox(width: 10),
                      _buildAttachmentButton(
                          Icons.image_outlined, 'Add Image'),
                      const SizedBox(width: 10),
                      _buildAttachmentButton(Icons.link_rounded, 'Add Link'),
                    ],
                  ),

                  if (_hasAttachment) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.picture_as_pdf_rounded,
                                color: Color(0xFFEF4444), size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Graph_Traversal_CheatSheet.pdf',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: textColorDark,
                                  ),
                                ),
                                Text(
                                  '2.4 MB',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded,
                                size: 18, color: Color(0xFF94A3B8)),
                            onPressed: () =>
                                setState(() => _hasAttachment = false),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  _buildSectionHeader('Tags', '0/30', isOptional: true),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _tagsController,
                    style: GoogleFonts.manrope(
                        fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: _inputDecoration(
                      'Provide context, details, code snippets, questions, or discussion topics.',
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'LIVE PREVIEW',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLivePreviewCard(),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final title = _titleController.text.trim();
                      final desc = _descriptionController.text.trim();
                      if (title.isNotEmpty && desc.isNotEmpty) {
                        try {
                          await DiscussionService().createDiscussion(
                            title: title,
                            content: desc,
                            tag: _selectedCategory,
                          );
                        } catch (_) {}
                      }
                      if (context.mounted) Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.wifi_tethering_rounded,
                        color: Colors.white, size: 20),
                    label: Text(
                      'Start Live Discussion',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count,
      {bool isOptional = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
            if (isOptional) ...[
              const SizedBox(width: 4),
              Text(
                '(Optional)',
                style: GoogleFonts.manrope(
                    fontSize: 11, color: const Color(0xFF94A3B8)),
              ),
            ],
          ],
        ),
        Text(
          count,
          style: GoogleFonts.manrope(
              fontSize: 10, color: const Color(0xFF94A3B8)),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.manrope(color: const Color(0xFFCBD5E1), fontSize: 12),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFCBD5E1),
              style: BorderStyle.solid), 
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF3B82F6), size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFCBD5E1),
                backgroundImage: AssetImage('assets/images/CloudArt_margin.png'),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Raven Sulistyo',
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B)),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEAB308), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LIVE • $_duration remaining',
                        style: GoogleFonts.manrope(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFEAB308)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _selectedCategory.toUpperCase(),
              style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2563EB)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _titleController.text.isEmpty
                ? 'Discussion Title'
                : _titleController.text,
            style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 2),
          Text(
            _descriptionController.text.isEmpty
                ? 'Discussion description preview...'
                : _descriptionController.text,
            style: GoogleFonts.manrope(
                fontSize: 11, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}