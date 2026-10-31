import 'package:flutter/material.dart';
import 'add_course_rating_screen.dart';

typedef ReviewData = Map<String, String>;

class CourseRatingScreen extends StatelessWidget {
  final double rating;
  final int totalRating;

  const CourseRatingScreen({Key? key, this.rating = 4.2, this.totalRating = 48})
    : super(key: key);

  static final List<ReviewData> _dummyReviews = [
    {
      'username': 'A**** P*******',
      'comment':
          'So farr matkulnya sulit, khususnya waktu ngerjain proyeeek plsss',
      'score': '4.2',
    },
    {
      'username': 'A**** P*******',
      'comment':
          'So farr matkulnya sulit, khususnya waktu ngerjain proyeeek plsss',
      'score': '4.2',
    },
    {
      'username': 'A**** P*******',
      'comment':
          'So farr matkulnya sulit, khususnya waktu ngerjain proyeeek plsss',
      'score': '4.2',
    },
  ];

  static void showPreviewBottomSheet(
    BuildContext context, {
    double rating = 4.2,
    int totalRating = 48,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildRatingHeader(rating, totalRating),
              const Divider(height: 24, color: Color(0xFFF1F5F9)),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _dummyReviews.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    return _buildReviewTile(_dummyReviews[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Rating Kesulitan',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildRatingHeader(rating, totalRating),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCourseRatingScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFCBD5E1),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Berapa rating kesulitan matkul ini',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ulasan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _dummyReviews.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        return _buildReviewTile(_dummyReviews[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRatingHeader(double score, int total) {
    return Row(
      children: [
        const Text('🧠 ', style: TextStyle(fontSize: 32)),
        Text(
          '$score',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFFED8936),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating Kesulitan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$total mahasiswa telah memberi rating',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildReviewTile(ReviewData review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFF3882C5)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review['username']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  review['comment']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Text('🧠 ', style: TextStyle(fontSize: 12)),
              Text(
                review['score']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFFED8936),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
