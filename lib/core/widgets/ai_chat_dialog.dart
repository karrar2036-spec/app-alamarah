import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AiChatDialog extends StatefulWidget {
  const AiChatDialog({super.key});

  @override
  State<AiChatDialog> createState() => _AiChatDialogState();
}

class Message {
  final String text;
  final bool isUser;
  final String time;

  Message({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class _AiChatDialogState extends State<AiChatDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isLoading = false;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListeningInput = false;
  bool _isSpeechEngineReady = false;
  String _recordedVoiceText = '';

  // محرك الصوت المجاني المحلّي المحسّن
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlayingAudio = false;

  late AnimationController _callPulseController;

  static const Color navyBlue = Color(0xFF002366);
  static const Color goldenYellow = Color(0xFFD4AF37);
  static const Color lightBg = Color(0xFFF1F5F9);
  static const Color royalGreen = Color(0xFF00C853);

  @override
  void initState() {
    super.initState();
    _callPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _initSpeechEngine();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setSpeechRate(0.42);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(0.9);

    try {
      var voices = await _flutterTts.getVoices;
      for (var voice in voices) {
        if (voice['locale'] != null &&
            voice['locale'].toString().startsWith('ar')) {
          await _flutterTts
              .setVoice({"name": voice["name"], "locale": voice["locale"]});
          break;
        }
      }
    } catch (e) {
      debugPrint('Voice selection error: $e');
    }

    _flutterTts.setStartHandler(() {
      if (mounted) setState(() => _isPlayingAudio = true);
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
  }

  Future<void> _initSpeechEngine() async {
    try {
      _isSpeechEngineReady = await _speech.initialize(
        onError: (val) {
          if (mounted) setState(() => _isListeningInput = false);
        },
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            if (mounted) setState(() => _isListeningInput = false);
          }
        },
      );
    } catch (e) {
      debugPrint('Speech Init Error: $e');
    }
  }

  void _startHoldingVoice() async {
    if (_isLoading) return;
    if (!_isSpeechEngineReady) await _initSpeechEngine();
    if (_speech.isListening) await _speech.stop();

    _recordedVoiceText = '';
    _controller.clear();
    setState(() => _isListeningInput = true);

    await _speech.listen(
      localeId: 'ar-SA', // استخدام ar-SA بالشرطة العادية لكتابة الحروف العربية بدقة على الويب والـ APK
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: false,
      partialResults: true,
      onResult: (val) {
        _recordedVoiceText = val.recognizedWords;
        setState(() {
          _controller.text = val.recognizedWords;
        });
      },
    );
  }

  void _stopHoldingAndSend() async {
    if (!_isListeningInput && !_speech.isListening) return;

    setState(() => _isListeningInput = false);
    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 250));

    final textToSend = _recordedVoiceText.trim().isNotEmpty
        ? _recordedVoiceText.trim()
        : _controller.text.trim();

    if (textToSend.isNotEmpty) {
      _sendMessage(customText: textToSend);
    }
  }

  Future<void> _speakVoice(String text) async {
    if (_isPlayingAudio) {
      await _flutterTts.stop();
      setState(() => _isPlayingAudio = false);
      return;
    }

    String cleanText = text
        .replaceAll(RegExp(r'[*#_`~<>{}\[\]\\]'), '')
        .replaceAll(RegExp(r'https?:\/\/\S+'), '')
        .trim();

    if (cleanText.isNotEmpty) {
      await _flutterTts.speak(cleanText);
    }
  }

  @override
  void dispose() {
    _callPulseController.dispose();
    _speech.stop();
    _flutterTts.stop();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'م' : 'ص';
    return '$hour:$minute $period';
  }

  String _extractAnswer(dynamic data) {
    if (data == null) return 'لا توجد إجابة.';
    if (data is Map) {
      if (data['answer'] != null) return data['answer'].toString();
      if (data['text'] != null) return data['text'].toString();
      if (data['response'] != null) return data['response'].toString();
      if (data['message'] != null) return data['message'].toString();
      if (data['data'] != null && data['data'] is Map) {
        if (data['data']['answer'] != null) {
          return data['data']['answer'].toString();
        }
        if (data['data']['text'] != null) {
          return data['data']['text'].toString();
        }
      }
    }
    return data.toString();
  }

  Future<void> _sendMessage({String? customText}) async {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    final currentTime = _formatCurrentTime();

    setState(() {
      _messages.add(Message(text: text, isUser: true, time: currentTime));
      _isLoading = true;
      _controller.clear();
      _recordedVoiceText = '';
      _isListeningInput = false;
    });
    _scrollToBottom();

    try {
      final url = Uri.parse(
        'https://app-alamarah.com/api/ai?question=${Uri.encodeComponent(text)}',
      );
      final response = await http.get(
        url,
        headers: {
          'Accept-Charset': 'utf-8',
          'Content-Type': 'application/json; charset=utf-8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final rawData = json.decode(utf8.decode(response.bodyBytes));
        String botReply = _extractAnswer(rawData);

        setState(() {
          _messages.add(Message(
            text: botReply,
            isUser: false,
            time: _formatCurrentTime(),
          ));
        });
      } else {
        setState(() {
          _messages.add(Message(
            text:
                'حدث خطأ في الاتصال بالخادم (رمز الاستجابة: ${response.statusCode})',
            isUser: false,
            time: _formatCurrentTime(),
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(
          text: 'تعذر الاتصال بالسيرفر! يرجى التأكد من اتصال الإنترنت.',
          isUser: false,
          time: _formatCurrentTime(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _openVoiceCallPage() async {
    if (_speech.isListening) await _speech.stop();
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => VoiceCallScreen(
          onNewMessageReceived: (userText, botText) {
            setState(() {
              _messages.add(Message(
                  text: userText, isUser: true, time: _formatCurrentTime()));
              _messages.add(Message(
                  text: botText, isUser: false, time: _formatCurrentTime()));
            });
            _scrollToBottom();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: navyBlue,
        foregroundColor: goldenYellow,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('photo/chat.png'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 10),
            Text(
              'المساعد الذكي',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 10.0),
            child: AnimatedBuilder(
              animation: _callPulseController,
              builder: (context, child) {
                final double anim = _callPulseController.value;
                final Color blendedColor =
                    Color.lerp(royalGreen, goldenYellow, anim)!;

                return Center(
                  child: GestureDetector(
                    onTap: _openVoiceCallPage,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(royalGreen, goldenYellow, anim)!,
                            Color.lerp(goldenYellow, royalGreen, anim)!,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                blendedColor.withOpacity(0.4 + (anim * 0.45)),
                            blurRadius: 10 + (anim * 8),
                            spreadRadius: 2 + (anim * 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildGreetingWidget()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildChatBubble(_messages[index]);
                    },
                  ),
          ),
          if (_isLoading) _buildThinkingIndicator(),
          _buildBottomInputArea(),
        ],
      ),
    );
  }

  Widget _buildGreetingWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: goldenYellow, width: 2),
              ),
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('photo/chat.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'أهلاً بك في خدمة المساعد الذكي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: navyBlue,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'اكتب سؤالك أو اضغط مطولاً على الميكروفون للتحدث، أو اضغط زر الاتصال المباشر بالأعلى.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(Message message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage('photo/chat.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? navyBlue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser
                      ? const Radius.circular(16)
                      : const Radius.circular(3),
                  bottomRight: isUser
                      ? const Radius.circular(3)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: isUser ? Colors.white60 : Colors.black38,
                        ),
                      ),
                      if (!isUser) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _speakVoice(message.text),
                          child: Icon(
                            _isPlayingAudio
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            size: 17,
                            color: navyBlue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 6),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: goldenYellow,
                border: Border.all(color: navyBlue, width: 1.5),
              ),
              child: const Center(
                child: Text(
                  '👨‍🎓',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('photo/chat.png'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: navyBlue),
                ),
                SizedBox(width: 8),
                Text(
                  'جاري المعالجة...',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lightBg,
                  borderRadius: BorderRadius.circular(22),
                  border: _isListeningInput
                      ? Border.all(color: Colors.redAccent, width: 1.5)
                      : null,
                ),
                child: TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: _isListeningInput
                        ? '🎙️ جاري الاستماع... ارفع إصبعك للإرسال'
                        : 'اكتب سؤالك أو اضغط مطولاً للتحدث...',
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: _isListeningInput ? Colors.redAccent : Colors.grey,
                      fontWeight: _isListeningInput
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTapDown: (_) => _startHoldingVoice(),
              onTapUp: (_) => _stopHoldingAndSend(),
              onTapCancel: () => _stopHoldingAndSend(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _isListeningInput
                      ? Colors.redAccent
                      : navyBlue.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListeningInput ? Icons.mic : Icons.mic_none_rounded,
                  color: _isListeningInput ? Colors.white : navyBlue,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Material(
              color: navyBlue,
              shape: const CircleBorder(),
              elevation: 1.5,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _isLoading ? null : () => _sendMessage(),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.send_rounded,
                    color: goldenYellow,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// شاشة المكالمة الحية - الصوت المحلي المحسّن
// ----------------------------------------------------
class VoiceCallScreen extends StatefulWidget {
  final Function(String userText, String botText) onNewMessageReceived;

  const VoiceCallScreen({super.key, required this.onNewMessageReceived});

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _callSpeech;
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;
  bool _isCallActive = true;
  String _statusText = 'جاري الاتصال...';
  String _liveTranscript = '';

  Timer? _silenceTimer;
  Timer? _watchdogTimer;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _callSpeech = stt.SpeechToText();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _initCallEngine();
  }

  Future<void> _initCallEngine() async {
    await _initCallTts();

    _flutterTts.setCompletionHandler(() {
      if (mounted && _isCallActive) {
        setState(() {
          _isSpeaking = false;
          _liveTranscript = '';
        });
        _safeStartListening();
      }
    });

    bool available = await _resetAndInitializeSpeech();
    if (mounted && _isCallActive) {
      if (available) _safeStartListening();
      _startKeepAliveWatchdog();
    }
  }

  Future<void> _initCallTts() async {
    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setSpeechRate(0.42);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(0.9);
  }

  Future<bool> _resetAndInitializeSpeech() async {
    try {
      await _callSpeech.cancel();
      bool available = await _callSpeech.initialize(
        onError: (val) {
          debugPrint('Speech Error: ${val.errorMsg}');
          if (mounted && _isCallActive && !_isSpeaking && !_isProcessing) {
            Future.delayed(
                const Duration(milliseconds: 250), _safeStartListening);
          }
        },
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            if (_isListening &&
                !_isProcessing &&
                !_isSpeaking &&
                _isCallActive) {
              if (_liveTranscript.trim().isNotEmpty) {
                _triggerResponse();
              } else {
                Future.delayed(
                    const Duration(milliseconds: 150), _safeStartListening);
              }
            }
          }
        },
      );
      return available;
    } catch (e) {
      return false;
    }
  }

  void _startKeepAliveWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (!_isCallActive) {
        timer.cancel();
        return;
      }
      if (!_isSpeaking && !_isProcessing && !_callSpeech.isListening) {
        _safeStartListening();
      }
    });
  }

  void _safeStartListening() async {
    if (!mounted || !_isCallActive || _isSpeaking || _isProcessing) return;

    try {
      if (!_callSpeech.isAvailable) {
        await _resetAndInitializeSpeech();
      }
      if (_callSpeech.isListening) {
        await _callSpeech.stop();
      }

      _liveTranscript = '';
      _silenceTimer?.cancel();

      setState(() {
        _isListening = true;
        _statusText = 'أنا أستمع إليك...';
      });

      await _callSpeech.listen(
        localeId: 'ar-SA', // استخدام ar-SA لضمان كتابة الكلمات بالحروف العربية الصحيحة في الويب والموبايل
        listenMode: stt.ListenMode.dictation,
        pauseFor: const Duration(seconds: 3),
        cancelOnError: false,
        partialResults: true,
        onResult: (result) {
          if (mounted && !_isSpeaking && !_isProcessing && _isCallActive) {
            setState(() {
              _liveTranscript = result.recognizedWords;
            });

            _silenceTimer?.cancel();
            if (result.recognizedWords.trim().isNotEmpty) {
              _silenceTimer = Timer(const Duration(milliseconds: 650), () {
                if (mounted &&
                    !_isProcessing &&
                    !_isSpeaking &&
                    _isCallActive) {
                  _triggerResponse();
                }
              });
            }
          }
        },
      );
    } catch (e) {
      debugPrint('Error starting listening: $e');
    }
  }

  String _extractAnswer(dynamic data) {
    if (data == null) return 'لا توجد إجابة.';
    if (data is Map) {
      if (data['answer'] != null) return data['answer'].toString();
      if (data['text'] != null) return data['text'].toString();
      if (data['response'] != null) return data['response'].toString();
      if (data['message'] != null) return data['message'].toString();
      if (data['data'] != null && data['data'] is Map) {
        if (data['data']['answer'] != null) {
          return data['data']['answer'].toString();
        }
        if (data['data']['text'] != null) {
          return data['data']['text'].toString();
        }
      }
    }
    return data.toString();
  }

  void _triggerResponse() async {
    _silenceTimer?.cancel();

    if (_liveTranscript.trim().isEmpty ||
        _isProcessing ||
        _isSpeaking ||
        !_isCallActive) {
      if (!_isSpeaking && !_isProcessing && _isCallActive) {
        _safeStartListening();
      }
      return;
    }

    final query = _liveTranscript.trim();

    setState(() {
      _isListening = false;
      _isProcessing = true;
      _statusText = 'جاري التفكير...';
    });

    try {
      await _callSpeech.stop();
    } catch (_) {}

    try {
      final url = Uri.parse(
        'https://app-alamarah.com/api/ai?question=${Uri.encodeComponent(query)}',
      );
      final response = await http.get(
        url,
        headers: {
          'Accept-Charset': 'utf-8',
          'Content-Type': 'application/json; charset=utf-8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final rawData = json.decode(utf8.decode(response.bodyBytes));
        String botReply = _extractAnswer(rawData);

        widget.onNewMessageReceived(query, botReply);
        await _speakDirectly(botReply);
      } else {
        const errorReply = 'حدث خطأ أثناء الاتصال بالسيرفر.';
        widget.onNewMessageReceived(query, errorReply);
        await _speakDirectly(errorReply);
      }
    } catch (e) {
      const connError = 'تعذر الاتصال بالسيرفر.';
      widget.onNewMessageReceived(query, connError);
      await _speakDirectly(connError);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _speakDirectly(String replyText) async {
    if (!mounted || !_isCallActive) return;

    setState(() {
      _isSpeaking = true;
      _isListening = false;
      _statusText = 'المساعد يتحدث...';
      _liveTranscript = replyText;
    });

    try {
      final cleanText = replyText
          .replaceAll(RegExp(r'[*#_`~<>{}\[\]\\]'), '')
          .replaceAll(RegExp(r'https?:\/\/\S+'), '')
          .trim();

      if (cleanText.isEmpty) {
        _safeStartListening();
        return;
      }

      await _flutterTts.speak(cleanText);
    } catch (e) {
      _safeStartListening();
    }
  }

  @override
  void dispose() {
    _isCallActive = false;
    _watchdogTimer?.cancel();
    _silenceTimer?.cancel();
    _callSpeech.cancel();
    _flutterTts.stop();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070F1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white70, size: 32),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.white38, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'مكالمة ذكية مباشرة',
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'المساعد الذكي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _statusText,
                      key: ValueKey<String>(_statusText),
                      style: TextStyle(
                        color: _isSpeaking
                            ? const Color(0xFFD4AF37)
                            : (_isProcessing
                                ? Colors.lightBlueAccent
                                : Colors.white70),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 140),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _liveTranscript.isEmpty
                            ? 'تحدث بشكل طبيعي، سيتم الرد عليك صوتياً...'
                            : _liveTranscript,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _liveTranscript.isEmpty
                              ? Colors.white30
                              : Colors.white,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  double scale = 1.0;
                  if (_isListening) {
                    scale = 1.0 + (_animController.value * 0.10);
                  }
                  if (_isSpeaking) {
                    scale = 1.0 + (_animController.value * 0.18);
                  }

                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 175,
                      height: 175,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _isSpeaking
                                ? const Color(0xFFD4AF37).withOpacity(0.45)
                                : (_isProcessing
                                    ? Colors.blueAccent.withOpacity(0.45)
                                    : const Color(0xFF002366).withOpacity(0.6)),
                            blurRadius: 35,
                            spreadRadius: 10,
                          )
                        ],
                        gradient: LinearGradient(
                          colors: _isSpeaking
                              ? [const Color(0xFFD4AF37), Colors.amber]
                              : (_isProcessing
                                  ? [Colors.blueAccent, Colors.lightBlue]
                                  : [
                                      const Color(0xFF002366),
                                      const Color(0xFF003F9E)
                                    ]),
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('photo/chat.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent,
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}