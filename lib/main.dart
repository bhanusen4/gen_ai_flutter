 import 'package:flutter/material.dart';
 import 'package:genaiflutter/view/resume_generator_screen.dart';
import 'dart:ui';
 import 'package:genaiflutter/widget/feature_title.dart';
 import 'package:firebase_core/firebase_core.dart';
 import 'firebase_options.dart'; //
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Resume Builder",
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget glassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          child: const Column(
            children: [
              FeatureTile(Icons.auto_awesome, "AI Powered Resume"),
              SizedBox(height: 18),
               FeatureTile(Icons.speed, "Fast & Smart Generator"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f0c29),
              Color(0xff302b63),
              Color(0xff24243e),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.greenAccent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      "Flutter GEN AI",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 40),

                const Text(
                  "Build Your\nDream Resume",
                  style: TextStyle(
                    height: 1.2,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Create stunning professional resumes using Flutter + AI in seconds.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),

                glassCard(),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {


                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ResumeGeneratorScreen()));

                    },
                    child: const Text(
                      "Generate Resume",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


