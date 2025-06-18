import 'package:flutter/material.dart';

class NewsItem {
  final String title;
  final String subtitle;
  final String time;
  final String type;
  final Color color;

  NewsItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.color,
  });
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final List<NewsItem> _allNews = [
    NewsItem(
      title: 'ক্রাইম রেট ১৫% কমেছে ধানমন্ডি এলাকায়',
      subtitle: 'স্থানীয় পুলিশ জানায়, সম্প্রদায়ের নিরাপত্তা অনেক উন্নত হয়েছে',
      time: '২ ঘন্টা আগে',
      type: 'SAFETY',
      color: const Color(0xFF10B981),
    ),
    NewsItem(
      title: 'নতুন ইমার্জেন্সি রেসপন্স সিস্টেম চালু',
      subtitle: 'নতুন প্রযুক্তিতে রেসপন্স টাইম ৩০% কমেছে',
      time: '৪ ঘন্টা আগে',
      type: 'UPDATE',
      color: const Color(0xFF3B82F6),
    ),
    NewsItem(
      title: 'কমিউনিটি ওয়াচ প্রোগ্রাম বিস্তৃত',
      subtitle: 'আরও পাড়া-মহল্লা নিরাপত্তা উদ্যোগে যোগ দিয়েছে',
      time: '৬ ঘন্টা আগে',
      type: 'COMMUNITY',
      color: const Color(0xFF8B5CF6),
    ),
    NewsItem(
      title: 'মিরপুর রোডে ট্রাফিক দুর্ঘটনা',
      subtitle: 'রোড সাময়িক বন্ধ, বিকল্প রুট ব্যবহার করুন',
      time: '৮ ঘন্টা আগে',
      type: 'TRAFFIC',
      color: const Color(0xFFF59E0B),
    ),
    NewsItem(
      title: 'নিরাপত্তা সতর্কতা: গুলশান এলাকা',
      subtitle: 'বাণিজ্যিক এলাকায় পুলিশের উপস্থিতি বাড়ানো হয়েছে',
      time: '১২ ঘন্টা আগে',
      type: 'ALERT',
      color: const Color(0xFFEF4444),
    ),
  ];

  List<NewsItem> _filteredNews = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _filteredNews = _allNews;
  }

  void _filterNews(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'All') {
        _filteredNews = _allNews;
      } else {
        _filteredNews = _allNews
            .where((item) => item.type == filter.toUpperCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        title:
            const Text('News & Updates', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _filterNews(_selectedFilter);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFF1F2937),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', _selectedFilter == 'All'),
                _buildFilterChip('Safety', _selectedFilter == 'Safety'),
                _buildFilterChip('Update', _selectedFilter == 'Update'),
                _buildFilterChip('Community', _selectedFilter == 'Community'),
                _buildFilterChip('Traffic', _selectedFilter == 'Traffic'),
                _buildFilterChip('Alert', _selectedFilter == 'Alert'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredNews.length,
              itemBuilder: (context, index) {
                final item = _filteredNews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: item.color, width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.type,
                              style: TextStyle(
                                color: item.color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            item.time,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _filterNews(label),
        backgroundColor: const Color(0xFF374151),
        selectedColor: const Color(0xFF06B6D4),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                isSelected ? const Color(0xFF06B6D4) : const Color(0xFF374151),
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}
