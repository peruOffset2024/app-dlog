import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(2);
                  },
                  child: const Text('SALTAR'),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const WormEffect(
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
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: const Text('SIGUIENTE'),
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
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
