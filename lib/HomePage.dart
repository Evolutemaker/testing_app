import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:testing_app/MedicineInfo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? textName;
  String? text;
  bool isTranslated = false;
  GoogleTranslator translator = GoogleTranslator();
  String buttonName = 'Translate';

  void translate() {
    if (isTranslated == false) {
      translator.translate(textName!, to: "ru").then((value) => setState(() {
            textName = value as String?;
          }));

      translator.translate(text!, to: "ru").then((value) => setState(() {
            text = value as String?;
          }));
      isTranslated == true;

      translator.translate(buttonName, to: "ru").then((value) => setState(() {
            buttonName = value as String;
          }));
      isTranslated == true;
    } else {
      translator.translate(textName!, to: "en").then((value) => setState(() {
            textName = value as String?;
          }));
      translator.translate(text!, to: "en").then((value) => setState(() {
            text = value as String?;
          }));
      translator.translate(buttonName, to: "en").then((value) => setState(() {
            buttonName = value as String;
          }));
      isTranslated == true;
      isTranslated == false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getUser(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingAnimationWidget.prograssiveDots(
                color: Colors.grey, size: 100.0);
          } else {
            return Scaffold(
              //TODO: backgroundColor based on Theme
              body: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                              child: FadeInAnimation(
                            child: widget,
                          )),
                      children: [
                        Center(
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 64.0, bottom: 25.0),
                            child: Text(
                              textName == null ? 'Text name' : textName!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //TODO: SwitchThemeButton
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 40.0, right: 40.0, bottom: 20),
                          child: const Divider(),
                        ),
                        GestureDetector(
                          onTap: () {
                            translate();

                            //TODO: Translate the text into Russian
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 120.0, left: 120, bottom: 20),
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Color(0xFFFE9870),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 1,
                                    blurRadius: 20,
                                    //offset: Offset(0, 3),
                                  )
                                ]),
                            child: Center(
                              child: Text(
                                buttonName,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'OpenSans',
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 40.0, right: 40.0, bottom: 30),
                            child: ReadMoreText(
                              text == null ? 'Text name' : text!,
                              trimLines: 10,
                              textAlign: TextAlign.justify,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: " Show More ",
                              colorClickableText: Colors.red,
                              trimExpandedText: " Show Less ",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Inter',
                                  height: 1.5),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future getUser(BuildContext context) async {
    final file = await rootBundle.loadString('jsonFile/sample.json');

    final json = jsonDecode(file);

    MedicineInfo info = MedicineInfo.fromJson(json);

    textName = info.textName;
    text = info.text;
  }
}
