import 'package:flutter/material.dart';
import '../widgets/student_videos_tab.dart';

class StudentPostsScreen extends StatefulWidget {
  const StudentPostsScreen({super.key});

  @override
  State<StudentPostsScreen> createState() => _StudentPostsScreenState();
}

class _StudentPostsScreenState extends State<StudentPostsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFD4AF37),
      end: const Color(0xFF002366),
    ).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mediaList = [
      {'type': 'video', 'path': 'photo/s1.mp4'},
      {'type': 'video', 'path': 'photo/s2.mp4'},
      {'type': 'video', 'path': 'photo/s3.mp4'},
      {'type': 'image', 'path': 'photo/n1.jpg'},
      {'type': 'image', 'path': 'photo/n2.jpg'},
      {'type': 'image', 'path': 'photo/n3.jpg'},
      {'type': 'image', 'path': 'photo/n4.jpg'},
      {'type': 'image', 'path': 'photo/n5.jpg'},
      {'type': 'image', 'path': 'photo/n6.jpg'},
      {'type': 'image', 'path': 'photo/n7.jpg'},
      {'type': 'image', 'path': 'photo/n8.jpg'},
      {'type': 'image', 'path': 'photo/n9.jpg'},
      {'type': 'image', 'path': 'photo/n10.jpg'},
      {'type': 'image', 'path': 'photo/n11.jpg'},
      {'type': 'image', 'path': 'photo/n12.jpg'},
      {'type': 'image', 'path': 'photo/n13.jpg'},
      {'type': 'image', 'path': 'photo/n14.jpg'},
      {'type': 'image', 'path': 'photo/n15.jpg'},
      {'type': 'image', 'path': 'photo/n16.jpg'},
      {'type': 'image', 'path': 'photo/n17.jpg'},
      {'type': 'image', 'path': 'photo/n18.jpg'},
      {'type': 'image', 'path': 'photo/n19.jpg'},
      {'type': 'image', 'path': 'photo/n20.jpg'},
    ];

    final imageList = mediaList.where((m) => m['type'] == 'image').toList();
    final videoList = mediaList.where((m) => m['type'] == 'video').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 0,
          toolbarHeight: 48,
          title: const Text(
            'المنشورات الطلابية',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return TabBar(
                  indicatorColor: _colorAnimation.value,
                  labelColor: _colorAnimation.value,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.image,
                          size: 20, color: _colorAnimation.value),
                      text: 'الصور',
                      iconMargin: const EdgeInsets.only(bottom: 4),
                    ),
                    Tab(
                      icon: Icon(Icons.videocam,
                          size: 20, color: _colorAnimation.value),
                      text: 'الفيديوهات',
                      iconMargin: const EdgeInsets.only(bottom: 4),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildPostList(imageList),
            _buildPostList(videoList),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(List<Map<String, String>> items) {
    if (items.isEmpty) {
      return const Center(child: Text('لا توجد عناصر'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      cacheExtent: 300,
      itemBuilder: (context, index) {
        final media = items[index];
        final bool isVideo = media['type'] == 'video';

        return Card(
          key: ValueKey(media['path']),
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: ClipOval(
                  child: Image.asset(
                    'photo/1.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
                title: Text('نشاط طلابي رقم ${index + 1}'),
                subtitle: const Text('جامعة العمارة الأهلية'),
              ),
              if (isVideo)
                GestureDetector(
                  onTap: () {
                    _openFullScreenVideo(context, media['path']!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF002366),
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        VideoPostWidget(
                          key: ValueKey('video_${media['path']}'),
                          videoPath: media['path']!,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 30,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                            ),
                            onPressed: () {
                              _openFullScreenVideo(context, media['path']!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 3,
                    ),
                  ),
                  child: Image.asset(
                    media['path']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('جامعة العمارة الأهلية (الجامعة تزهو بطلابها)'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openFullScreenVideo(BuildContext context, String videoPath) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullScreenVideoPage(
          key: ValueKey('fullscreen_$videoPath'),
          videoPath: videoPath,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class FullScreenVideoPage extends StatelessWidget {
  final String videoPath;

  const FullScreenVideoPage({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: VideoPostWidget(
                key: ValueKey('video_$videoPath'),
                videoPath: videoPath,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
