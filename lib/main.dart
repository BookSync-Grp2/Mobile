import 'package:flutter/material.dart';
import 'package:mobile/screens/home_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookSync',
      home: HomeScreen(),
      /*onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            return NoTransitionPageRoute(
                page: const HomeScreen(),
                settings: const RouteSettings(name: "/home"));
          case '/explore':
            String currentText = settings.arguments as String;
            return NoTransitionPageRoute(
                page: ExploreScreen(currentText: currentText),
                settings: const RouteSettings(name: "/explore"));
          case '/library':
            return NoTransitionPageRoute(
                page: const LibraryScreen(),
                settings: const RouteSettings(name: "/library"));
          case '/profile':
            return NoTransitionPageRoute(
                page: const ProfileScreen(),
                settings: const RouteSettings(name: "/profile"));
          case '/song':
            return SlideUpTransitionPageRoute(
                page: const SongScreen(),
                settings: const RouteSettings(name: "/song"));
          case '/playlist':
            Playlist playlist = settings.arguments as Playlist;
            return NoTransitionPageRoute(
              page: PlaylistScreen(
                playlist: playlist,
              ),
              settings: const RouteSettings(name: "/playlist"),
            );
        }
        return null;
      },*/
    );
  }
}
