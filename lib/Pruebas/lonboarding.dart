import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildPage(
                 // image: 'assets/images/onboarding1.png',
                  title: 'Bienvenido',
                  description: 'Esta es la descripción de la primera pantalla.',
                ),
                _buildPage(
                 // image: 'assets/images/onboarding2.png',
                  title: 'Funcionalidad 1',
                  description: 'Aquí puedes ver la funcionalidad 1 de la app.',
                ),
                _buildPage(
                 // image: 'assets/images/onboarding3.png',
                  title: 'Funcionalidad 2',
                  description: 'Aquí puedes ver la funcionalidad 2 de la app.',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  child: Text('SALTAR'),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: Colors.blue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_pageController.page!.toInt() == 2) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text('SIGUIENTE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    //required String image,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Image.asset(image, height: 300),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
