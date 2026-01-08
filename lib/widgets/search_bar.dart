import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/utils/widgets/speech_mic_service.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchBar({super.key, required this.controller, this.onChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  final SpeechMicService _micService = SpeechMicService();
  bool _isListening = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0.9,
      upperBound: 1.1,
    );
  }

  @override
  void dispose() {
    _micService.stopListening();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    debugPrint("MIC BUTTON PRESSED");

    if (_isListening) {
      _micService.stopListening();
      _animationController.stop();
      setState(() => _isListening = false);
    } else {
      bool started = await _micService.startListening(
        onResult: (text) {
          setState(() {
            widget.controller.text = text;
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length),
            );
          });
          widget.onChanged?.call(text);
        },
      );

      if (started) {
        _animationController.repeat(reverse: true);
        setState(() => _isListening = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SEARCH BAR BUILD ACTIVE");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              decoration: const InputDecoration(
                hintText: "Search here",
                border: InputBorder.none,
              ),
            ),
          ),

          ScaleTransition(
            scale: _animationController,
            child: IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.redAccent : Colors.black54,
              ),
              onPressed: _toggleMic,
            ),
          ),
        ],
      ),
    );
  }
}
