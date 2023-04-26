import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextW extends StatelessWidget {
  final String data;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration? decoration;
  final bool is_bold;
  final bool is_italic;
  final bool is_white;
  final bool? is_auto_expnd;
  final double? textScaleFactor;
  final bool is_heading;
  final bool is_subtitle;
  final double? minFontSize;

  final EdgeInsetsGeometry? padding;
  final double? height;

  //
  const TextW(
    this.data, {
    this.fontSize,
    this.minFontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textAlign,
    this.textDirection,
    this.decoration,
    this.is_bold = false,
    this.is_italic = false,
    this.is_white = false,
    this.is_auto_expnd = false,
    this.textScaleFactor,
    this.is_heading = false,
    this.is_subtitle = false,
    this.padding,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var autoW = AutoSizeText(data,
        textAlign: textAlign,
        textDirection: textDirection,
        softWrap: softWrap,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines ?? 1,
        minFontSize: minFontSize ?? 12,
        textScaleFactor:
            textScaleFactor ?? (is_heading ? 1.1 : (is_subtitle ? 0.9 : null)),
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: is_bold ? FontWeight.w500 : fontWeight,
            color: color ?? (is_white ? Colors.white : null),
            decoration: decoration,
            fontStyle: is_italic ? FontStyle.italic : FontStyle.normal));

    //
    Widget finalText() {
      if (overflow != null || is_auto_expnd == false) {
        return Text(
          data,
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          textScaleFactor: textScaleFactor ??
              (is_heading ? 1.1 : (is_subtitle ? 0.9 : null)),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: is_bold ? FontWeight.w500 : fontWeight,
            color: color ?? (is_white ? Colors.white : null),
            decoration: decoration,
            fontStyle: is_italic ? FontStyle.italic : FontStyle.normal,
          ),
        );
      }

      return autoW;
    }

    if (height != null) {
      return SizedBox(
        height: height,
        child: Align(alignment: Alignment.centerLeft, child: finalText()),
      );
    }

    if (padding != null) {
      return Padding(
        padding: padding!,
        child: finalText(),
      );
    } else {
      return finalText();
    }
  }
}
