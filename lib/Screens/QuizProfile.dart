import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:translator_app/Screens/QuizEditProfile.dart';
import 'package:translator_app/Screens/QuizSettings.dart';
import 'package:translator_app/main.dart';
import 'package:translator_app/model/QuizModels.dart';
import 'package:translator_app/utils/AppWidget.dart';
import 'package:translator_app/utils/QuizColors.dart';
import 'package:translator_app/utils/QuizConstant.dart';
import 'package:translator_app/utils/QuizDataGenerator.dart';
import 'package:translator_app/utils/QuizImages.dart';
import 'package:translator_app/utils/QuizStrings.dart';

class QuizProfile extends StatefulWidget {
  static String tag = '/QuizProfile';

  @override
  _QuizProfileState createState() => _QuizProfileState();
}

class _QuizProfileState extends State<QuizProfile> {
  late List<QuizBadgesModel> mList;
  late List<QuizScoresModel> mList1;

  @override
  void initState() {
    super.initState();
    mList = quizBadgesData();
    mList1 = quizScoresData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final imgview = Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              64.height,
              Container(
                height: width * 0.35,
                width: width * 0.35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: quiz_white, width: 4)),
                child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(quiz_img_People2),
                    radius: MediaQuery.of(context).size.width / 8.5),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: quiz_white, width: 2),
                    color: context.cardColor),
                child: Icon(Icons.edit, size: 20).onTap(() {
                  QuizEditProfile().launch(context);
                  setState(() {});
                }),
              ).paddingOnly(right: 16, top: 16).onTap(() {
                print("Edit profile");
              })
            ],
          ),
          Text(
            quiz_lbl_Antonio_Perez,
            style: boldTextStyle(
                color: appStore.isDarkModeOn ? white : quiz_textColorPrimary),
          ).paddingOnly(top: 24),
          Text(quiz_lbl_Xp,
                  style: secondaryTextStyle(color: quiz_textColorSecondary))
              .paddingOnly(top: 8),
          SizedBox(height: 30),
        ],
      ),
    ).center();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings,
                  color: appStore.isDarkModeOn ? white : black),
              color: blackColor,
              onPressed: () => QuizSettings().launch(context),
            ),
          ],
          leading: Container(),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(color: context.cardColor, child: imgview),
        ),
      ),
    );
  }
}
