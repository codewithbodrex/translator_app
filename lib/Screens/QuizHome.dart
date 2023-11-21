import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:translator_app/Screens/NewQuiz.dart';
// import 'package:translator_app/Screens/QuizDetails.dart';
import 'package:translator_app/model/QuizModels.dart';
import 'package:translator_app/utils/AppWidget.dart';
import 'package:translator_app/utils/QuizColors.dart';
import 'package:translator_app/utils/QuizDataGenerator.dart';
import 'package:translator_app/utils/QuizStrings.dart';
import 'package:translator_app/utils/QuizWidget.dart';
import 'package:translator/translator.dart';
import 'package:flutter/services.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
// import 'QuizNewList.dart';
// import 'QuizSearch.dart';

class QuizHome extends StatefulWidget {
  static String tag = '/QuizHome';

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  final openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      enableLog: true);
  String _dropdownFrom = 'id';
  String _dropdownTo = 'id';
  String _translation = '';
  final translator = GoogleTranslator();
  String searchText = '';

  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  void _translateText(String from, String to) {
    if (searchText != '') {
      translator.translate(searchText, from: '$from', to: '$to').then((result) {
        setState(() {
          _translation = result.text;
        });
      }).catchError((error) {
        setState(() {
          _translation = 'Terjadi kesalahan saat menerjemahkan';
        });
      });
    }
  }

  void _translateTextLive(String text) {
    if (text.isEmpty) {
      // Jika input teks kosong, atur _translation menjadi kosong
      setState(() {
        _translation = '';
      });
    } else {
      // Jika input teks tidak kosong, lakukan permintaan terjemahan
      setState(() {
        _translation = "Sedang translate...";
      });

      translator
          .translate(text, from: '$_dropdownFrom', to: '$_dropdownTo')
          .then((result) {
        // Setelah terjemahan selesai, perbarui hasil terjemahan
        setState(() {
          _translation = result.text;
        });
      }).catchError((error) {
        // Tangani kesalahan dan tampilkan pesan kesalahan jika diperlukan
        setState(() {
          _translation = 'Terjadi kesalahan saat menerjemahkan';
        });
      });
    }
  }

  void _translateGPT(String text) {
    final request = CompleteText(
        prompt:
            text + " translate from " + _dropdownFrom + " to " + _dropdownTo,
        maxTokens: 200,
        model: TextDavinci3Model());
    openAI.onCompletionSSE(request: request).listen((it) {
      setState(() {
        _translation += it.choices.last.text;
      });
    });
  }

  late List<NewQuizModel> mListings;

  @override
  void initState() {
    super.initState();
    mListings = getQuizData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            32.height,
            Text(quiz_lbl_hi_antonio, style: boldTextStyle(size: 24)),
            8.height,
            Text(
              quiz_lbl_what_would_you_like_to_learn_n_today_search_below,
              style: primaryTextStyle(color: quiz_textColorSecondary),
              textAlign: TextAlign.center,
            ),
            24.height,
            Container(
              margin: EdgeInsets.all(16.0),
              child: LanguagePickerDropdown(
                  initialValue: Languages.indonesian,
                  onValuePicked: (Language language) {
                    _dropdownFrom = language.isoCode;
                    _translateText(_dropdownFrom, _dropdownTo);
                  }),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: boxDecoration(
                  radius: 10, showShadow: true, bgColor: context.cardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  quizEditTextStyle(
                    "Translate",
                    isPassword: false,
                    onChanged: (value) {
                      searchText = value;
                      _translateTextLive(value);
                    },
                  ).expand(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: boxDecoration(
                        radius: 10,
                        showShadow: false,
                        bgColor: quiz_colorPrimary),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.content_copy, color: quiz_white),
                  ).onTap(
                    () {
                      copyToClipboard(_translation);
                    },
                  )
                ],
              ),
            ),
            24.height,
            8.height,
            // Text(
            //   _translation,
            //   style: primaryTextStyle(color: quiz_textColorSecondary),
            //   textAlign: TextAlign.center,
            // ),
            8.height,
            Container(
              margin: EdgeInsets.all(16.0),
              child: LanguagePickerDropdown(
                  initialValue: Languages.indonesian,
                  onValuePicked: (Language language) {
                    _dropdownTo = language.isoCode;
                    _translateText(_dropdownFrom, _dropdownTo);
                  }),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: boxDecoration(
                  radius: 10, showShadow: true, bgColor: context.cardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  quizEditTextStyle(_translation, isPassword: false).expand(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: boxDecoration(
                        radius: 10,
                        showShadow: false,
                        bgColor: quiz_colorPrimary),
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.content_copy, color: quiz_white),
                  ).onTap(
                    () {
                      copyToClipboard(_translation);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
