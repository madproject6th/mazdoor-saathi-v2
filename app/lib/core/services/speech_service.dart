import 'package:speech_to_text/speech_to_text.dart';

/// Urdu (ur_PK) + English speech-to-text for hands-free input.
class SpeechService {
  final SpeechToText _stt = SpeechToText();
  bool _ready = false;

  Future<bool> init() async {
    if (_ready) return true;
    try {
      _ready = await _stt.initialize();
    } catch (_) {
      _ready = false;
    }
    return _ready;
  }

  bool get isListening => _stt.isListening;

  /// Start listening. [urdu] uses ur_PK, otherwise en_US.
  Future<bool> listen({
    required bool urdu,
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!await init()) return false;
    try {
      await _stt.listen(
        localeId: urdu ? 'ur_PK' : 'en_US',
        onResult: (r) => onResult(r.recognizedWords, r.finalResult),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _stt.stop();
    } catch (_) {}
  }
}
