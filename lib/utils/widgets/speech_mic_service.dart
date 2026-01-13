import 'package:speech_to_text/speech_to_text.dart';

class SpeechMicService {
  final SpeechToText _speech = SpeechToText();
  bool isListening = false;

  Future<bool> startListening({required Function(String text) onResult}) async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          isListening = false;
        }
      },
      onError: (_) => isListening = false,
    );

    if (!available) return false;

    isListening = true;

    _speech.listen(
      listenMode: ListenMode.confirmation,
      onResult: (result) {
        onResult(result.recognizedWords);
      },
    );

    return true;
  }

  void stopListening() {
    _speech.stop();
    isListening = false;
  }
}
