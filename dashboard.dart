import 'dart:async';
import 'dart:ui'; // Keep for potential future use with BackdropFilter etc.
import 'package:flutter/material.dart';

class SSClothingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SS Clothing',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "ONE LIFE ONE CHOICE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              AppBar(
                backgroundColor: Colors.white,
                elevation: 1,
                title: Row(
                  children: [
                    Text(
                      'SS Clothing',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    NavItem('CONTACT'),
                    NavItem('SALE', isHighlighted: true),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              AutoScrollingImageWindow(
                // IMPORTANT: Replace these with your actual asset paths
                imagePaths: [
                  'assets/images/1.jpg', // Example
                  'assets/images/2.jpg', // Example
                  'assets/images/3.jpg', // Example
                  // Add more asset paths as needed
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Explore our latest collection!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              // You can add more product grids, categories, etc. here
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                padding: EdgeInsets.all(16),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text("Featured Products Section", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final bool isHighlighted;

  const NavItem(
      this.title, {
        this.isHighlighted = false,
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text( // Simplified from Row as Text is sufficient
        title,
        style: TextStyle(
          color: isHighlighted ? Colors.redAccent : Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }
}

class AutoScrollingImageWindow extends StatefulWidget {
  final List<String> imagePaths; // Changed from imageUrls to imagePaths for clarity
  final Duration scrollInterval;
  final double height;

  const AutoScrollingImageWindow({
    Key? key,
    required this.imagePaths,
    this.scrollInterval = const Duration(seconds: 5), // Slightly longer interval
    this.height = 300.0, // Adjusted height
  })  : assert(imagePaths.length > 0, 'imagePaths cannot be empty'),
        super(key: key);

  @override
  _AutoScrollingImageWindowState createState() =>
      _AutoScrollingImageWindowState();
}

class _AutoScrollingImageWindowState extends State<AutoScrollingImageWindow> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    if (widget.imagePaths.length > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.scrollInterval, (timer) {
      if (!mounted) return;

      if (_currentPage < widget.imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 700), // Smoother, longer animation
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(child: Text("No images configured")),
      );
    }

    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 8.0), // Added some horizontal margin
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          final imagePath = widget.imagePaths[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for the images
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                // This errorBuilder is helpful for debugging missing assets
                print("Error loading asset image: $imagePath");
                print("Exception: $exception");
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image_outlined, size: 40, color: Colors.black54),
                        SizedBox(height: 8),
                        Text(
                          "Error: Image not found",
                          style: TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          imagePath, // Show the problematic path
                          style: TextStyle(color: Colors.black45, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        onPageChanged: (int page) {
          if (mounted) {
            setState(() {
              _currentPage = page;
            });
          }
        },
      ),
    );
  }
}