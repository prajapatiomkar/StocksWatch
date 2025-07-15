import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import '../widgets/stock_tile.dart';
import '../models/stock.dart';
import '../main.dart'; // Import themeNotifier

class MarketWatchPage extends StatefulWidget {
  @override
  _MarketWatchPageState createState() => _MarketWatchPageState();
}

class _MarketWatchPageState extends State<MarketWatchPage> with WidgetsBindingObserver {
  final WebSocketService _service = WebSocketService();

  List<Stock> allStocks = [];
  List<Stock> filteredStocks = [];
  String _searchQuery = '';

  void _filterStocks(String query) {
    _searchQuery = query;
    final lowerQuery = query.toLowerCase();

    setState(() {
      filteredStocks = allStocks.where((stock) {
        return stock.symbol.toLowerCase().contains(lowerQuery) ||
            stock.name.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _service.getStockStream().listen((stocks) {
      setState(() {
        allStocks = stocks;
        if (_searchQuery.isEmpty) {
          filteredStocks = stocks;
        } else {
          _filterStocks(_searchQuery);
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _service.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App is back to foreground -> reconnect socket
      _service.reconnect();
    } else if (state == AppLifecycleState.paused) {
      // Optional: Close socket to save battery
      _service.disconnect();
    }
  }

  void _toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Market Watch'),
        actions: [
          IconButton(
            icon: themeNotifier.value ==ThemeMode.dark ?Icon(Icons.light_mode): Icon(Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: _filterStocks,
                decoration: InputDecoration(
                  hintText: 'Search Script Here',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: filteredStocks.isEmpty
                  ? Center(child: Text('No matching stocks'))
                  : Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(overscroll: false),
                        child: ListView.builder(
                          itemCount: filteredStocks.length,
                          itemBuilder: (context, index) {
                            return StockTile(stock: filteredStocks[index]);
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // Match background!
        type: BottomNavigationBarType.fixed, // Prevent shifting/opacity
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Market Watch',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Charts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {},
      ),
    );
  }
}
