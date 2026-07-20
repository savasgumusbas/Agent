import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

void main() {
  runApp(const AuraApp());
}

class AuraApp extends StatelessWidget {
  const AuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA Agent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0B12),
        primaryColor: const Color(0xFFC084FC),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC084FC),
          secondary: Color(0xFFA855F7),
          surface: Color(0xFF13111C),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TerminalScreen(),
    const ImageStudioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AGENT AURA // SPECIAL OPS AI',
          style: TextStyle(fontFamily: 'monospace', fontSize: 16, color: Color(0xFFC084FC)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF13111C),
        elevation: 2,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF13111C),
        selectedItemColor: const Color(0xFFC084FC),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.terminal),
            label: 'Terminal & Voice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Image Studio',
          ),
        ],
      ),
    );
  }
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);
  }

  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
      _isLoading = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(seconds: 1));

    String responseText = "AURA Komut alındı: '$text'. Sistem aktif ve işliyor.";

    setState(() {
      _messages.add({"sender": "aura", "text": responseText});
      _isLoading = false;
    });

    _speak(responseText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg["sender"] == "user";
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF2E1065) : const Color(0xFF13111C),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isUser ? const Color(0xFF7E22CE) : const Color(0xFF3B2063),
                    ),
                  ),
                  child: Text(
                    msg["text"] ?? "",
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFFA855F7),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading) const LinearProgressIndicator(color: Color(0xFFC084FC)),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF13111C),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                  decoration: const InputDecoration(
                    hintText: "Komut girin...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFFC084FC)),
                onPressed: () => _sendMessage(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageStudioScreen extends StatefulWidget {
  const ImageStudioScreen({super.key});

  @override
  State<ImageStudioScreen> createState() => _ImageStudioScreenState();
}

class _ImageStudioScreenState extends State<ImageStudioScreen> {
  final TextEditingController _promptController = TextEditingController();
  String? _imageUrl;
  bool _isGenerating = false;

  void _generateImage() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _imageUrl = null;
    });

    final encoded = Uri.encodeComponent(prompt);
    final url = "https://pollinations.ai/p/$encoded?width=512&height=512&seed=42&nologo=true";

    setState(() {
      _imageUrl = url;
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _promptController,
            style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
            decoration: InputDecoration(
              labelText: "Görsel Prompt",
              labelStyle: const TextStyle(color: Color(0xFFA855F7)),
              filled: true,
              fillColor: const Color(0xFF13111C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF3B2063)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A102F),
                foregroundColor: const Color(0xFFC084FC),
                side: const BorderSide(color: Color(0xFF7E22CE)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _isGenerating ? null : _generateImage,
              child: const Text("GÖRSEL ÜRET", style: TextStyle(fontFamily: 'monospace')),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: _isGenerating
                  ? const CircularProgressIndicator(color: Color(0xFFC084FC))
                  : _imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator(color: Color(0xFFC084FC));
                            },
                          ),
                        )
                      : const Text("Henüz bir görsel üretilmedi.", style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
