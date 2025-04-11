import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:video_player/video_player.dart';
import 'dart:io';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.grey[800]!,
    secondary: Colors.grey[600]!,
    surface: Colors.grey[300]!,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 45, color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.purple,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[900]!,
    secondary: Colors.grey[700]!,
    surface: Colors.grey[800]!,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 45, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, // Red background
      foregroundColor: Colors.white, // White text
    ),
  ),
);
final appTitle = "Katit";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle(appTitle);
  fvp.registerWith(
    options: {
      'video.decoders': ['D3D11', 'NVDEC', 'FFmpeg'],
      'platforms': ['windows'],
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String currentFilePath = "";
  void _changeCurrentFilePath(String filePath) {
    setState(() {
      currentFilePath = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katit',
      theme: lightTheme, // Light theme applied by default
      darkTheme: darkTheme, // Dark theme configuration
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: TopBar(changeCurrentFilePath: _changeCurrentFilePath),
                ),
                Expanded(flex: 7, child: PlayerArea(filePath: currentFilePath)),
                Expanded(flex: 2, child: BottomBar()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final ValueChanged<String> changeCurrentFilePath;

  const TopBar({super.key, required this.changeCurrentFilePath});

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        print('Selected file path: $filePath');
        changeCurrentFilePath(filePath);
      } else {
        print('File selection canceled');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          Container(
            // color: Colors.red,
            child: Center(
              child: Text(
                'Katit',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _pickFile,
                child: Text("Select Source"),
              ),
            ),
          ),
          ElevatedButton(onPressed: () => {}, child: Text("Clear")),
        ],
      ),
    );
  }
}

class PlayerArea extends StatefulWidget {
  final String filePath;
  const PlayerArea({super.key, required this.filePath});

  @override
  State<PlayerArea> createState() => _PlayerAreaState();
}

class _PlayerAreaState extends State<PlayerArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[600],
      alignment: Alignment.center,
      child: _LocalAssetVideo(filePath: widget.filePath),
    );
  }
}

class _LocalAssetVideo extends StatefulWidget {
  final String filePath;

  const _LocalAssetVideo({required this.filePath});

  @override
  _LocalAssetVideoState createState() => _LocalAssetVideoState();
}

class _LocalAssetVideoState extends State<_LocalAssetVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeController(widget.filePath);
  }

  @override
  void didUpdateWidget(covariant _LocalAssetVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filePath != oldWidget.filePath && widget.filePath.isNotEmpty) {
      _initializeController(widget.filePath);
    }
  }

  Future<void> _initializeController(String path) async {
    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
    }

    setState(() {
      _controller = VideoPlayerController.file(File(path));
    });

    await _controller!.initialize();
    _controller!.setLooping(true);
    _controller!.play();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filePath.isEmpty) {
      return const Text("No file selected");
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const CircularProgressIndicator();
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoPlayer(_controller!),
          _ControlsOverlay(controller: _controller!),
          VideoProgressIndicator(_controller!, allowScrubbing: true),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child:
              controller.value.isPlaying
                  ? const SizedBox.shrink()
                  : Container(
                    color: Colors.black26,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  ),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(value: speed, child: Text('${speed}x')),
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Text('Bottom Bar', style: TextStyle(color: Colors.white)),
    );
  }
}
