import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import '../core/services/window_manager_service.dart';

Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize media_kit engine
  MediaKit.ensureInitialized();

  // Initialize Custom Window decorations on Windows
  await WindowManagerService.initialize();

  // Return Riverpod configuration container
  return ProviderContainer();
}
