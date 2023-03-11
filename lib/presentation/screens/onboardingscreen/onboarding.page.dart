import 'package:flutter/material.dart';
import 'package:gabi/presentation/app/constant/appcolors.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';
import 'package:lottie/lottie.dart';
import 'package:onboarding/onboarding.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              width: 0.0,
              color: AppColors.black,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    //horizontal: 45.0,
                    vertical: 95.0,
                  ),
                  child: Lottie.asset(
                    'assets/lottie/livestreaming.json',
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                const Text(
                  'Live Streaming',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  'Best Streams In One Place',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    PageModel(
      widget: SizedBox(
        height: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              width: 0.0,
              color: AppColors.black,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    //horizontal: 45.0,
                    top: 90.0,
                  ),
                  child: Lottie.asset(
                    'assets/lottie/music.json',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Dowload Music',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    // PageModel(
    //   widget: SizedBox(
    //     height: double.infinity,
    //     child: DecoratedBox(
    //       decoration: BoxDecoration(
    //         color: AppColors.black,
    //         border: Border.all(
    //           width: 0.0,
    //           color: AppColors.black,
    //         ),
    //       ),
    //       child: SingleChildScrollView(
    //         controller: ScrollController(),
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 45.0,
    //                 vertical: 90.0,
    //               ),
    //               child: Image.asset(
    //                 'assets/images/onboarding/UTCI.png',
    //               ),
    //             ),
    //             const SizedBox(
    //               height: 25.0,
    //             ),
    //             Image.asset(
    //               'assets/images/onboarding/UTCI2.jpg',
    //             ),
    //             const SizedBox(
    //               height: 25.0,
    //             ),
    //             Image.asset(
    //               'assets/images/onboarding/UTCI3.png',
    //             ),
    //             const SizedBox(
    //               height: 25.0,
    //             ),
    //             const Text(
    //               'GABRIEL KATRIB',
    //               style: pageTitleStyle,
    //               textAlign: TextAlign.left,
    //             ),
    //             const Text(
    //               'U-T-S-I',
    //               style: pageInfoStyle,
    //               textAlign: TextAlign.left,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
  ];
  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: Colors.amber,
      shadowColor: Colors.red,
      surfaceTintColor: Colors.amberAccent,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 1;
            setIndex(1);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get _signin {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: Colors.amber,
      shadowColor: Colors.red,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Sign in',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                width: 0.0,
                color: Colors.black,
              ),
            ),
            child: ColoredBox(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        indicatorDesign: IndicatorDesign.line(
                          lineDesign: LineDesign(
                            lineType: DesignType.line_uniform,
                          ),
                        ),
                      ),
                    ),
                    index == pagesLength - 1
                        ? _signin
                        : _skipButton(setIndex: setIndex)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
