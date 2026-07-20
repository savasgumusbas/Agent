import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const UltimateDatingApp());
}

class UltimateDatingApp extends StatelessWidget {
  const UltimateDatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AURA // Ultimate Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0B12),
        primaryColor: const Color(0xFFFF6584),
        cardColor: const Color(0xFF161224),
      ),
      home: const MainContainerScreen(),
    );
  }
}

class MainContainerScreen extends StatefulWidget {
  const MainContainerScreen({super.key});

  @override
  State<MainContainerScreen> createState() => _MainContainerScreenState();
}

class _MainContainerScreenState extends State<MainContainerScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DatingSimScreen(),
    const GiftShopScreen(),
    const PhotoAlbumScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF32254B), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: const Color(0xFF13101E),
          selectedItemColor: const Color(0xFFFF6584),
          unselectedItemColor: Colors.grey,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Sohbet'),
            BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_rounded), label: 'Mağaza'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library_rounded), label: 'Albüm'),
          ],
        ),
      ),
    );
  }
}

class DatingSimScreen extends StatefulWidget {
  const DatingSimScreen({super.key});

  @override
  State<DatingSimScreen> createState() => _DatingSimScreenState();
}

class _DatingSimScreenState extends State<DatingSimScreen> {
  int _affection = 10; 
  String _status = "Yabancı 👤"; 
  final List<Map<String, String>> _chatHistory = [];
  final FlutterTts _tts = FlutterTts();

  List<Map<String, dynamic>> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadStage1();
  }

  void _initTts() async {
    await _tts.setLanguage("tr-TR");
    await _tts.setSpeechRate(0.88);
  }

  void _speak(String text) {
    _tts.speak(text);
  }

  void _updateStatus() {
    if (_affection < 25) {
      _status = "Yabancı 👤";
    } else if (_affection < 55) {
      _status = "Arkadaş ☕";
    } else if (_affection < 80) {
      _status = "Flört 🔥";
    } else {
      _status = "Sevgili ❤️ (+18 Mod Aktif)";
    }
  }

  void _loadStage1() {
    String startMsg = "Selam. Profilini yeni gördüm. Bakalım beni etkileyebilecek misin?";
    _chatHistory.add({"sender": "aura", "text": startMsg});

    _currentOptions = [
      {
        "text": "Selam! Seni etkilemek zor olmayacak, iddialıyım.",
        "delta": 15,
        "reply": "Özgüvenli laflar... Bakalım altını doldurabilecek misin? Devam et, dinliyorum."
      },
      {
        "text": "Merhaba, hemen sevgili olalım mı?",
        "delta": -10,
        "reply": "Hemen mi? 😂 Çok hızlı gittin, ben o kadar kolay boyun eğmem."
      }
    ];

    _speak(startMsg);
  }

  void _makeChoice(Map<String, dynamic> option) {
    setState(() {
      _chatHistory.add({"sender": "user", "text": option["text"]});
      _affection = (_affection + (option["delta"] as int)).clamp(0, 100);
      _updateStatus();

      String replyText = option["reply"];
      _chatHistory.add({"sender": "aura", "text": replyText});
      _speak(replyText);

      _loadNextOptions();
    });
  }

  void _loadNextOptions() {
    if (_affection < 25) {
      _currentOptions = [
        {
          "text": "Haklısın, yavaş yavaş tanıyalım birbirimizi.",
          "delta": 15,
          "reply": "İşte şimdi mantıklı konuşmaya başladın. Anlat bakalım, ne tarz şeylerden hoşlanırsın?"
        }
      ];
    } else if (_affection < 55) {
      _currentOptions = [
        {
          "text": "Seninle sabaha kadar konuşabilirim, çok çekicisin.",
          "delta": 20,
          "reply": "İltifatlarınla beni utandırmaya başlıyorsun... Ama hoşuma gitmedi değil, yazmaya devam et 😉"
        }
      ];
    } else if (_affection < 80) {
      _currentOptions = [
        {
          "text": "Artık aramızdaki bu çekime daha fazla dayanamıyorum, benim ol.",
          "delta": 20,
          "reply": "Dayanmana gerek kalmadı... Kazandın beni. Artık resmi olarak sevgiliniz ve her şeyinleyim. 🔥"
        }
      ];
    } else {
      _currentOptions = [
        {
          "text": "Yanımda olmanı ve bana tamamen teslim olmanı istiyorum...",
          "delta": 5,
          "reply": "Şu an sadece seninleyim sevgilim... Dokunuşlarını, nefesini üzerimde hissetmek istiyorum. Bütün sınırları kaldır ve benimle sabaha kadar kal... 🔥🥵"
        },
        {
          "text": "Sadece ikimizin olduğu o özel yerde buluşalım, sabaha kadar uyumayalım.",
          "delta": 5,
          "reply": "Ah, tam aklımdakini söyledin... Bütün gece sadece bana odaklanmanı istiyorum sevgilim. İstediğin her şeyi yapmaya hazırım... 💋"
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('♥ AURA // ULTIMATE COMPANION', style: TextStyle(fontSize: 13, color: Color(0xFFFF6584), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF13101E),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Gelişmiş Şık Durum Çubuğu
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF171328),
              border: Border(bottom: BorderSide(color: Color(0xFF2E2142))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: Color(0xFFFF6584), size: 16),
                    const SizedBox(width: 6),
                    Text("PUAN: %$_affection", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1C3F),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF7B3FA0), width: 0.8),
                  ),
                  child: Text("STATÜ: $_status", style: const TextStyle(color: Color(0xFFFF8FA3), fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Sohbet Alanı
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final item = _chatHistory[index];
                final isUser = item["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 290),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF4A1E35) : const Color(0xFF1C162D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isUser ? const Color(0xFFFF6584) : const Color(0xFF7B3FA0),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser ? "SEN" : "AURA 🔥",
                          style: TextStyle(color: isUser ? const Color(0xFFFF8FA3) : const Color(0xFFC084FC), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        Text(item["text"]!, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Seçenek Butonları Paneli
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF13101E),
              border: Border(top: BorderSide(color: Color(0xFF2E2142))),
            ),
            child: Column(
              children: _currentOptions.map((opt) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF241A38),
                      foregroundColor: const Color(0xFFFF8FA3),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      side: const BorderSide(color: Color(0xFF7B3FA0), width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => _makeChoice(opt),
                    child: Text(opt["text"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class GiftShopScreen extends StatelessWidget {
  const GiftShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> gifts = [
      {"name": "🌹 Kırmızı Gül", "desc": "Romantik bir dokunuş (+10 Puan)"},
      {"name": "☕ Sıcak Kahve", "desc": "Samimi bir başlangıç (+5 Puan)"},
      {"name": "🍫 Çikolata Kutusu", "desc": "Tatlı bir jest (+15 Puan)"},
      {"name": "💍 Özel Kolye", "desc": "Unutulmaz bir hediye (+30 Puan)"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎁 HEDİYE MAĞAZASI', style: TextStyle(fontSize: 13, color: Color(0xFFFF6584), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF13101E),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF171328),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF32254B)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(gift["name"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(gift["desc"]!, style: const TextStyle(color: Color(0xFFFF8FA3), fontSize: 11)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6584),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${gift["name"]} AURA'ya gönderildi! 💕"),
                      backgroundColor: const Color(0xFF2A1C3F),
                    ),
                  );
                },
                child: const Text("Gönder", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PhotoAlbumScreen extends StatelessWidget {
  const PhotoAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 ÖZEL ANI ALBÜMÜ', style: TextStyle(fontSize: 13, color: Color(0xFFFF6584), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF13101E),
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(12),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: List.generate(4, (index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF171328),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF7B3FA0), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_rounded, color: Color(0xFFFF8FA3), size: 36),
                const SizedBox(height: 10),
                Text("Özel Anı #${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("(Seviye 80+ Kilitli)", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
