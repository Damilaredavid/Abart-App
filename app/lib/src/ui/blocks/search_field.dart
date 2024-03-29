import 'package:app/src/models/app_state_model.dart';
import 'package:dunes_icons/dunes_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  width: 0.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

class SearchBarField extends StatefulWidget {
  final Function(String)? onChanged;
  final bool autofocus;
  final TextEditingController searchTextController;
  final String hintText;
  const SearchBarField({Key? key, required this.onChanged, required this.searchTextController, required this.hintText, required this.autofocus}) : super(key: key);
  @override
  _SearchBarFieldState createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {

  Color? fillColor;

  double borderRadius = AppStateModel().blocks.settings.appBarStyle.borderRadius;

  @override
  Widget build(BuildContext context) {


    if(Theme.of(context).appBarTheme.backgroundColor != null) {
      fillColor = Theme.of(context).appBarTheme.backgroundColor.toString().substring(Theme.of(context).appBarTheme.backgroundColor.toString().length - 7) == 'ffffff)' ? null : Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
    } else fillColor = Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black12;

    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return Container(
          padding: EdgeInsetsDirectional.fromSTEB( Navigator.of(context).canPop() ? 0 : 24, 0, 24, 0),
          child: CupertinoTextField(
            autofocus: true,
            controller: widget.searchTextController,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.titleMedium!.fontFamily,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null
            ),
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.withBrightness(
                color: CupertinoColors.white,
                darkColor: CupertinoColors.black,
              ),
              border: _kDefaultRoundedBorder,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
            prefix: Container(
              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: DunesIcon(iconString: model.blocks.settings.searchIcon, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : CupertinoColors.placeholderText),
            ),
            placeholder: widget.hintText,
            onChanged: widget.onChanged,
          ),
        );
      }
    );
  }
}