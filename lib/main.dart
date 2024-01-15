import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rickmorty/layers/presentation/app_root.dart';
import 'package:rickmorty/layers/presentation/using_get_it/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StateManagementOptions {
  bloc,
  cubit,
  provider,
  riverpod,
  getIt,
  mobX,
  favqs,
}

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  await initializeGetIt();
  Animate.restartOnHotReload = true;

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 1));

  runApp(const ProviderScope(child: AppRoot()));
}
