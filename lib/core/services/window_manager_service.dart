import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as acrylic;
import 'package:window_manager/window_manager.dart';

class WindowManagerService {
  WindowManagerService._();

  static Future<void> initialize() async {
    if (kIsWeb || !Platform.isWindows) return;

    // Initialize window_manager and flutter_acrylic
    WidgetsFlutterBinding.ensureInitialized();
    await acrylic.Window.initialize();
    await windowManager.ensureInitialized();

    // Configure window options
    const windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // Use custom title bar
      title: 'Aash Player',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    // Set Windows Fluent visual effect
    await acrylic.Window.setEffect(
      effect: acrylic.WindowEffect.mica,
      color: const Color(0x00000000), // Transparent to let mica show
      dark: true,
    );
  }
}
