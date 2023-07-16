import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

import 'lugares_cercanos.dart';

class BusquedaVoz extends StatefulWidget {
  const BusquedaVoz({Key? key}) : super(key: key);

  @override
  State<BusquedaVoz> createState() => _BusquedaVozState();
}

class _BusquedaVozState extends State<BusquedaVoz> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  bool _showResultButton = false;
  bool _showRejectButton = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            if (result.finalResult) {
              setState(() {
                _isListening = false;
                _showResultButton = true;
                _showRejectButton = true;
              });
            }
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
        _showResultButton = false;
        _showRejectButton = false;
      });
    }
  }

  void _navigateToResultPage(String searchText) {
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LugaresCercanos(searchText: searchText),
      ),
    );
  }

  void _reset() {
    setState(() {
      _text = '';
      _showResultButton = false;
      _showRejectButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text("Búsqueda por voz"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text),
            const SizedBox(
              height: 10,
              width: 40,
            ),
            AvatarGlow(
              animate: _isListening,
              glowColor: Colors.amber,
              endRadius: 75.0,
              duration: const Duration(milliseconds: 2000),
              repeatPauseDuration: const Duration(milliseconds: 100),
              repeat: true,
              child: FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
            if (_showResultButton)
              ElevatedButton(
                onPressed: () => _navigateToResultPage(_text),
                child: const Text('Ver resultado'),
              ),
            if (_showRejectButton)
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Rechazar'),
              ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String searchText;

  const ResultPage({Key? key, required this.searchText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: Text('Texto buscado: $searchText'),
      ),
    );
  }
}
