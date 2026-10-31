import 'package:flutter/material.dart';

typedef SearchItemData = Map<String, dynamic>;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<SearchItemData> _historyItems = [
    {
      'title': 'Algoritma & Pemrograman',
      'subtitle': '284 post minggu ini',
      'type': 'course',
      'icon': Icons.show_chart,
      'isHistory': true,
    },
    {
      'title': 'Basis Data',
      'subtitle': '192 post minggu ini',
      'type': 'course',
      'icon': Icons.book_outlined,
      'isHistory': false,
    },
    {
      'title': 'Kehidupan Kampus',
      'subtitle': '156 post minggu ini',
      'type': 'course',
      'icon': Icons.chat_bubble_outline,
      'isHistory': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isSearching ? _buildSearchAppBar() : _buildHeaderBanner(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isSearching) ...[
                      const SizedBox(height: 4),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      _buildTopTopicsSection(),
                      const SizedBox(height: 24),
                      _buildForYouSection(),
                    ] else ...[
                      _buildSearchContent(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF5A7FBA)),
      padding: const EdgeInsets.only(left: 20, top: 40),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 64, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'HI! GAVI SIAP MENEMANIMU',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    height: 1.5,
                    letterSpacing: 1,
                    color: Color(0xFF273856),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 210,
                  child: Text(
                    'Temukan obrolan yang relevan untukmu.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      height: 1.35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: Image.asset(
              'assets/images/bara_naik_pesawat.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.pets, size: 80, color: Colors.white54);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1E293B),
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            },
          ),
          const Expanded(
            child: Text(
              'Cari',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        onTap: () {
          setState(() {
            _isSearching = true;
          });
        },
        onChanged: (value) {
          setState(() {});
        },
        decoration: const InputDecoration(
          hintText: 'Cari user atau postingan...',
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTopTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Topik populer',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              'Lihat semua',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF3182CE),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._historyItems.map((item) => _buildItemTile(item)),
      ],
    );
  }

  Widget _buildForYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Untuk Anda',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFCBD5E1),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Chen',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        '2j lalu',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: [
                  _buildTagChip('SISTEM INFOR...', isOrange: true),
                  _buildTagChip('PROBABILITAS ...', isOrange: false),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Besok aku UTS, ada yang punya materi atau catetan gaa? Dosenku AFK :(',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Aku baru masuk materi modul 1, tapi kaya ini susah banget gilakh!!! Kalau ada yang mau belajar barng sokk kita ke CW',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '124',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '32',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
    bool isEmpty = _historyItems.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Histori',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            if (!isEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _historyItems.clear();
                  });
                },
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3182CE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (isEmpty)
          _buildEmptyHistoryState()
        else
          ..._historyItems.map((item) => _buildItemTile(item)),
      ],
    );
  }

  Widget _buildEmptyHistoryState() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/bara_tidur.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.nightlight_round,
                  size: 80,
                  color: Color(0xFF94A3B8),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada histori pencarian',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTile(SearchItemData item) {
    bool isHistory = item['isHistory'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF5A7FBA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item['icon'] ?? Icons.book_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['subtitle'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isHistory ? Icons.close : Icons.chevron_right,
                color: const Color(0xFF94A3B8),
                size: 18,
              ),
              onPressed: () {
                if (isHistory) {
                  setState(() {
                    _historyItems.remove(item);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String label, {bool isOrange = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOrange ? const Color(0xFFFFEDD5) : const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOrange ? const Color(0xFFEA580C) : const Color(0xFF0369A1),
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
