import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:webblen_web_app/constants/app_colors.dart';
import 'package:webblen_web_app/ui/views/onboarding/path_select/onboarding_path_select_view_model.dart';
import 'package:webblen_web_app/ui/widgets/common/buttons/custom_button.dart';
import 'package:webblen_web_app/ui/widgets/common/progress_indicator/custom_circle_progress_indicator.dart';
import 'package:webblen_web_app/ui/widgets/common/text_field/text_field_container.dart';

class OnboardingPathSelectView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingPathSelectViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      viewModelBuilder: () => OnboardingPathSelectViewModel(),
      builder: (context, model, child) => Scaffold(
        body: model.isBusy
            ? Center(
                child: CustomCircleProgressIndicator(size: 10, color: appActiveColor()),
              )
            : IntroductionScreen(
                globalBackgroundColor: appBackgroundColor,
                key: model.introKey,
                freeze: true,
                onDone: () {},
                onSkip: () => model.navigateToNextPage(),
                showSkipButton: false,
                showNextButton: model.showNextButton,
                skipFlex: 0,
                nextFlex: 0,
                skip: Text('Skip', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                next: Icon(FontAwesomeIcons.arrowRight, size: 24.0, color: Colors.black),
                done: Container(),
                dotsDecorator: DotsDecorator(
                  size: Size(0.0, 0.0),
                  color: Colors.white,
                  activeColor: Colors.white,
                  activeSize: Size(0.0, 0.0),
                ),
                pages: [
                  OnboardingPathSelectPages().initialPage(),
                  OnboardingPathSelectPages().associatedEmailPage(model),
                  OnboardingPathSelectPages().selectExperiencePage(model),
                ],
              ),
      ),
    );
  }
}

class _OnboardingImage extends StatelessWidget {
  final String assetName;
  _OnboardingImage({required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Image.asset(
          'assets/images/$assetName.png',
          height: 200,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

class OnboardingPathSelectPages {
  PageDecoration pageDecoration = PageDecoration(
    contentMargin: EdgeInsets.all(0),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 14.0),
    titlePadding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16, right: 16),
    imageFlex: 1,
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    //imagePadding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
  );

  PageViewModel initialPage() {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "We're Excited to Have You!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Text(
        "Let's answer a few questions to help get you going in your community",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, height: 1.5),
      ),
      image: _OnboardingImage(assetName: 'team_arrow'),
      decoration: pageDecoration,
    );
  }

  PageViewModel associatedEmailPage(OnboardingPathSelectViewModel model) {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "What's Your Email Address?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Text(
        "Just In Case You Lose Access to Your Account",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18.0, height: 1.5),
      ),
      footer: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFieldContainer(
              height: 50,
              width: 500,
              child: TextFormField(
                controller: null,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                validator: (val) => val!.isEmpty ? 'Field Cannot be Empty' : null,
                maxLines: null,
                onChanged: (val) => model.updateEmail(val),
                onFieldSubmitted: (val) => model.validateAndSubmitEmailAddress(),
                decoration: InputDecoration(
                  hintText: "Email Address",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          CustomButton(
            text: "Set Email Address",
            textColor: Colors.black,
            backgroundColor: Colors.white,
            width: 300.0,
            height: 45.0,
            onPressed: () => model.validateAndSubmitEmailAddress(),
            isBusy: false,
          ),
        ],
      ),
      image: _OnboardingImage(assetName: 'phone_email'),
      decoration: pageDecoration,
    );
  }

  PageViewModel selectExperiencePage(OnboardingPathSelectViewModel model) {
    return PageViewModel(
      titleWidget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "The Culture of ${model.areaName}\nis in Your Hands",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
      bodyWidget: Text(
        "How Would You Like to Be Involved?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.0, height: 1.5),
      ),
      image: _OnboardingImage(assetName: 'city_buildings'),
      decoration: pageDecoration,
      footer: Container(
        child: Column(
          children: [
            CustomButton(
              text: "Host Live & Virtual Events",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              width: 300.0,
              height: 40.0,
              onPressed: () => model.transitionToEventHostPath(),
              isBusy: false,
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "Livestream Video",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              width: 300.0,
              height: 40.0,
              onPressed: () => model.transitionToStreamerPath(),
              isBusy: false,
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "Explore Events, Streams, & Communities",
              textColor: Colors.black,
              backgroundColor: Colors.white,
              width: 300.0,
              height: 40.0,
              onPressed: () => model.transitionToExplorerPath(),
              isBusy: false,
            ),
          ],
        ),
      ),
    );
  }
}
