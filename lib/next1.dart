import 'package:fitnationsgym/register.dart';
import 'package:fitnationsgym/getstarted.dart'; // Import GetstartedPage
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Next1Page extends StatefulWidget {
  const Next1Page({super.key});

  @override
  State<Next1Page> createState() => _Next1PageState();
}

class _Next1PageState extends State<Next1Page> {
  // List of images and texts
  final List<Map<String, String>> data = [
    {
      'image': 'assets/next1.png',
      'text': 'Track Your Goal',
      'description':
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals"
    },
    {
      'image': 'assets/next2.png',
      'text': 'Get Burn',
      'description':
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
    },
    {
      'image': 'assets/next3.png',
      'text': 'Eat Well',
      'description':
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
    },
    {
      'image': 'assets/next4.png',
      'text': 'Improve Sleep Quality',
      'description':
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
    },
  ];

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _next() {
    setState(() {
      if (_currentIndex == data.length - 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const RegisterPage(), // Go to RegisterPage when finished
          ),
        );
      } else {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _previous() {
    setState(() {
      if (_currentIndex == 0) {
        // If it's the first page, navigate back to GetstartedPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetstartedPage()),
        );
      } else {
        _currentIndex--;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(image: AssetImage(data[index]['image']!)),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index]['text']!,
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              data[index]['description']!,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Buttons at the bottom
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 24.0, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xddF1EF6D),
                    shape: BoxShape.circle,
                  ),
                  child: TextButton(
                    onPressed: _previous,
                    child: const FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Next Button
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xddF1EF6D),
                    shape: BoxShape.circle,
                  ),
                  child: TextButton(
                    onPressed: _next,
                    child: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
