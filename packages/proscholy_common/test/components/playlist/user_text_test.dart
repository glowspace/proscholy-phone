import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proscholy_common/components/playlist/user_text.dart';

void main() {
  test('content of user text is kept', () {
    final document = Document()..insert(0, 'Otče náš');

    expect(decodeUserText(encodeUserText(document)).toPlainText(), 'Otče náš\n');
    expect(decodeUserText('').toPlainText(), '\n');
  });

  testWidgets('changed content of user text is shown', (tester) async {
    Widget userTextContent(String text) => MaterialApp(
      localizationsDelegates: const [FlutterQuillLocalizations.delegate],
      home: Scaffold(
        body: UserTextContent(content: encodeUserText(Document()..insert(0, text)), padding: EdgeInsets.zero),
      ),
    );

    await tester.pumpWidget(userTextContent('Otče náš'));
    expect(find.textContaining('Otče náš', findRichText: true), findsOneWidget);

    await tester.pumpWidget(userTextContent('Zdrávas Maria'));
    expect(find.textContaining('Zdrávas Maria', findRichText: true), findsOneWidget);
    expect(find.textContaining('Otče náš', findRichText: true), findsNothing);
  });
}
