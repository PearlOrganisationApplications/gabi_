import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gabi/app/constants/app_images.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';
import 'package:lottie/lottie.dart';
import 'package:onboarding/onboarding.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/preferences/app_preferences.dart';
import '../../../utils/systemuioverlay/full_screen.dart';

class OnBoardingScreen extends StatelessWidget {

  int index = 0;


  List<PageModel> _onboardingPagesList({required BuildContext context}){
    return [
      PageModel(
        widget: Container(
          color: Colors.green,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.boxDecorationColor2,
              border: Border.all(
                width: 0.0,
                color: Colors.black,
              ),
            ),
            child: Column(
              children: [
                Spacer(flex: 1,),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/onboarding/img.png',
                      height: 140.0,
                      width: 140.0,
                    ),
                  ),
                ),
                /*const SizedBox(
                height: 50.0,
              ),*/
                const Text(
                  'Gabeveli Makaveli\naka\n"trump g"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.textColor3,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Spacer(flex: 1,),
              ],
            ),
          ),
        ),
      ),
      PageModel(
        widget: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.boxDecorationColor2,
              border: Border.all(
                width: 0.0,
                color: Colors.black,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 120.0,
                    right: 120.0,

                    //top: 90.0,
                  ),
                  child: Lottie.asset(
                    'assets/lottie/live_streaming.json',
                  ),
                ),
                /*const SizedBox(
                height: 20.0,
              ),*/
                /*const Text(
                //'Enjoy Live Streaming!',
                'GABI',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),*/
                const SizedBox(
                  height: 50.0,
                ),
                const Text(
                  'G7LUME7INATI7',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.textColor3,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                /*const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: const Text(
                  'GO LIVE | GET LIFE',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),*/
                Spacer(flex: 1,),

              ],
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

  Material _signin({required BuildContext context}) {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: Colors.amber,
      shadowColor: Colors.red,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          AppPreferences.setOnBoardShow(false);
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
    FullScreen.color(color: Colors.black);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Image.asset(EVERY_WHERE_ICON)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Onboarding(
          pages: _onboardingPagesList(context: context),
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
                          ? _signin(context: context)
                          : _skipButton(setIndex: setIndex)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}