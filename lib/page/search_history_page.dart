import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart'; // Đảm bảo đã nhập theme của bạn
import '../page/search_result_page.dart'; // Nhập SearchResultsPage

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: appTheme, // Thiết lập theme ở đây
      home: const SearchHistoryPage(),
    );
  }
}

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  final List<String> searchHistory = ["Vợt", "Balo", "Bóng", "Phụ kiện"];
  String searchQuery = "";

  final Color insideColorIconOnColor = const Color(0xFFCC7861);

  void _removeItem(int index) {
    setState(() {
      searchHistory.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      searchHistory.clear();
    });
  }

  void _onSearchItemSelected(String query) {
    final List<Map<String, String>> searchResults = [];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          searchQuery: query,
          searchResults: searchResults,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredHistory = searchHistory
        .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch sử tìm kiếm",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: whiteColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              "Xóa tất cả",
              style: GoogleFonts.firaSans(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Thanh tìm kiếm cải tiến
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // Điều hướng tới trang tìm kiếm khi người dùng nhấn vào thanh tìm kiếm
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.search,
                          color: insideColorIconOnColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm...",
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _onSearchItemSelected(value);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please enter a search term!')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Danh sách lịch sử tìm kiếm
            filteredHistory.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Không có lịch sử tìm kiếm.",
                  style: GoogleFonts.firaSans(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredHistory.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () =>
                      _onSearchItemSelected(filteredHistory[index]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      leading: Icon(
                        Icons.history,
                        color: insideColorIconOnColor,
                      ),
                      title: Text(
                        filteredHistory[index],
                        style: GoogleFonts.firaSans(
                          color:
                          Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color:
                          Theme.of(context).scaffoldBackgroundColor,
                        ),
                        onPressed: () => _removeItem(searchHistory
                            .indexOf(filteredHistory[index])),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
