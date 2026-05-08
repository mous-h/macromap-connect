import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Added
import 'firebase_options.dart';
import 'auth_gate.dart';
import 'feed_provider.dart'; // Added

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MacroMapApp());
}

class MacroMapApp extends StatelessWidget {
  const MacroMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrapped in MultiProvider so all teammates can add their logic here
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FeedProvider())],
      child: MaterialApp(
        title: 'MacroMap Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E8E3E),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        ),
        home: const AuthGate(),
      ),
    );
  }
}
