import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:last_answer/abstract/HiveBoxes.dart';
import 'package:last_answer/abstract/NamedLocale.dart';
import 'package:last_answer/shared_utils_models/locales_model.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

const double AppBarHeight = 48;

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box<bool>(HiveBoxes.darkMode);
    var isDark = box.get(BoxDarkMode.isDark, defaultValue: false) ?? false;
    var size = MediaQuery.of(context).size;
    var localeModel = Provider.of<LocaleModel>(context);
    return Material(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'appBarMenuButton',
              child: Material(
                shape: CircleBorder(),
                color: Colors.transparent,
                child: SizedBox(
                  height: AppBarHeight,
                  width: 56,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        SafeArea(
            child: Stack(
          children: [
            Hero(
              tag: 'appBarBackground',
              child: Container(
                height: size.height - AppBarHeight,
                color: Theme.of(context).canvasColor,
                child: Material(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    padding: EdgeInsets.all(20.0),
                    children: [
                      Center(
                        child: Column(children: [
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await box.put(BoxDarkMode.isDark, !isDark);
                              },
                              icon: AnimatedSwitcher(
                                duration: Duration(milliseconds: 400),
                                child: isDark
                                    ? Icon(Icons.wb_sunny_outlined)
                                    : Icon(Icons.wb_sunny),
                              ),
                            ),
                          ),
                          Text(
                            'Dark mode',
                            textAlign: TextAlign.center,
                          ),
                          Consumer<LocaleModel>(
                              builder: (context, locale, child) {
                            final textStyle =
                                TextStyle(fontSize: 14.0, color: Colors.white);
                            return DropdownButton<NamedLocale>(
                              value: locale.currentNamedLocale,
                              style: textStyle,
                              items: LocaleModelConsts.namedLocales
                                  .map<DropdownMenuItem<NamedLocale>>(
                                      (namedLocale) {
                                return DropdownMenuItem<NamedLocale>(
                                  value: namedLocale,
                                  child: Text(
                                    namedLocale.name,
                                    style: textStyle,
                                  ),
                                );
                              }).toList(),
                              onChanged: (NamedLocale? namedLocale) async {
                                await localeModel
                                    .switchLang(namedLocale?.locale);
                              },
                            );
                          })
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ],
    ));
  }
}
