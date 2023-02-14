import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //statusBarColor: Colors.transparent,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController = TextEditingController();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
     _lastWords += result.recognizedWords; // concatenate new text with previous text
       _textController.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Convertify',style: TextStyle(fontFamily: GoogleFonts.comfortaa().fontFamily,color: Colors.black,fontWeight: FontWeight.w200) ,),
        backgroundColor: Colors.white,
        elevation: 0,
         systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0,fontFamily: GoogleFonts.comfortaa().fontFamily,fontWeight: FontWeight.w100),
              ),
            ),
           Flexible(
            flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      maxLines: 50000,
                      controller: _textController,
                      enabled: true,
                      style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,fontWeight: FontWeight.normal,fontSize: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: _speechToText.isListening
                            ? 'Recognized words'
                            : _speechEnabled
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                                hintStyle:  TextStyle(fontFamily: GoogleFonts.poppins().fontFamily,fontWeight: FontWeight.normal,fontSize: 16)
                      ),
                    ),
                  ),),
         
          _speechToText.isListening? Flexible(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child:Lottie.asset('assets/images/wave.json',fit: BoxFit.cover)
            ),
          ):Flexible(
            child: Container(
              child: Lottie.asset('assets/images/sleep.json',fit: BoxFit.cover),
            ),
          ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: _speechToText.isNotListening ? Lottie.asset('assets/images/micoff2.json', height: 30,) : Lottie.asset('assets/images/mic.json',)
      ),
    );
  }
}