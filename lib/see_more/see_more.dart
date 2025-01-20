import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_widgets/app_string/app_string.dart';

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('See More'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SeeMoreText(text: AppString.text400)],
          ),
        ),
      ),
    );
  }
}

class SeeMoreText extends StatefulWidget {
  const SeeMoreText({super.key, required this.text});

  final String text;

  @override
  State<SeeMoreText> createState() => _SeeMoreTextState();
}

class _SeeMoreTextState extends State<SeeMoreText> {
  bool _isExpanded = false;
  int _characterLimit = 200;

  @override
  Widget build(BuildContext context) {
    bool isTextOverFlow = widget.text.length > _characterLimit;
    String displayedText = _isExpanded || !isTextOverFlow
        ? widget.text
        : "${widget.text.substring(0, _characterLimit)}...";

    return RichText(
      text: TextSpan(children: [
        TextSpan(text: displayedText,style: const TextStyle(color: Colors.black)),
        if (isTextOverFlow) ...[
          const TextSpan(text: ' '),
          TextSpan(
            text: _isExpanded ? 'SeeLess' : 'SeeMore',
            style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
            recognizer: TapGestureRecognizer()..onTap = () {
              setState(() {
                _isExpanded=!_isExpanded;
              });
            },
          )
        ]
      ]),
    );
  }
}

/// if i don't use spread operator
/*List<TextSpan> textSpans = [
  TextSpan(text: displayedText),
];
if (isTextOverFlow) {
  textSpans.add(
    TextSpan(
      text: _isExpanded ? " See Less" : " See More",
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
    ),
  );
}
return RichText(text: TextSpan(children: textSpans));
*/
