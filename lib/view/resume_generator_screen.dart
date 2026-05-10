
 import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_markdown/flutter_markdown.dart';


 class ResumeGeneratorScreen extends StatefulWidget {
   const ResumeGeneratorScreen({super.key});

   @override
   State<ResumeGeneratorScreen> createState() =>
       _ResumeGeneratorScreenState();
 }

 class _ResumeGeneratorScreenState
     extends State<ResumeGeneratorScreen> {

   final nameController = TextEditingController();
   final skillsController = TextEditingController();
   final experienceController = TextEditingController();
   final roleController = TextEditingController();

   bool isLoading = false;

   String generatedResume = "";

   Widget buildField(
       TextEditingController controller,
       String hint,
       IconData icon,
       ) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 18),
       child: TextField(
         controller: controller,
         style: const TextStyle(color: Colors.white),

         decoration: InputDecoration(
           prefixIcon: Icon(
             icon,
             color: Colors.greenAccent,
           ),

           hintText: hint,

           hintStyle: const TextStyle(
             color: Colors.white60,
           ),

           filled: true,
           fillColor: Colors.white.withOpacity(0.08),

           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(18),
             borderSide: BorderSide.none,
           ),
         ),
       ),
     );
   }


   Future<void> generateResume() async {
     final name = nameController.text.trim();
     final skills = skillsController.text.trim();
     final experience = experienceController.text.trim();
     final role = roleController.text.trim();

     List<String> errors = [];

     if (name.isEmpty) {
       errors.add("Full Name is required");
     } else if (skills.isEmpty) {
       errors.add("Skills are required");
     } else if (experience.isEmpty) {
       errors.add("Experience is required");
     } else if (role.isEmpty) {
       errors.add("Target Role is required");
     }

     if (errors.isNotEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: Colors.redAccent,
           behavior: SnackBarBehavior.floating,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(14),
           ),
           content: Text(
             errors.first,
             style: const TextStyle(color: Colors.white),
           ),
         ),
       );
       return;
     }

     setState(() {
       isLoading = true;
     });

     try {
       final model = FirebaseAI.googleAI().generativeModel(
         model: 'gemini-2.5-flash-lite',
       );

       final prompt = """
Create a simple professional resume. Don't include phone,email and social media link.

Name: $name
Target Role: $role
Skills: $skills
Experience: $experience

Generate:
- Professional Summary
- Skills
- Experience
- Career Objective

Keep the resume simple and easy to understand.
""";

       final response = await model.generateContent([
         Content.text(prompt),
       ]);

       setState(() {
         generatedResume =
             response.text ?? "No resume generated.";
       });
     } catch (e) {
       setState(() {
         generatedResume = "Error: $e";
       });
     } finally {
       setState(() {
         isLoading = false;

         nameController.clear();
         skillsController.clear();
         experienceController.clear();
         roleController.clear();
       });
     }
   }

   Widget resumeCard() {
     return Container(
       width: double.infinity,
       constraints: const BoxConstraints(
         maxHeight: 350,
       ),

       padding: const EdgeInsets.all(20),

       decoration: BoxDecoration(
         color: Colors.white.withOpacity(0.08),
         borderRadius: BorderRadius.circular(25),
         border: Border.all(
           color: Colors.white.withOpacity(0.15),
         ),
       ),

       child:SingleChildScrollView(
         child: MarkdownBody(
           data: generatedResume,
         )

       ),
     );
   }

   @override
   Widget build(BuildContext context) {

     return Scaffold(
       body: Container(
         width: double.infinity,
         height: double.infinity,

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
           child: SingleChildScrollView(
             padding: const EdgeInsets.all(22),

             child: Column(
               crossAxisAlignment:
               CrossAxisAlignment.start,

               children: [

                 Row(
                   children: [

                     InkWell(
                       onTap: (){
                         Navigator.pop(context);
                       },
                       child: Container(
                         padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.08),
                           borderRadius:
                           BorderRadius.circular(14),
                         ),
                         child: const Icon(Icons.arrow_back),
                       ),
                     ),

                     const SizedBox(width: 15),

                     const Text(
                       "Resume Builder",
                       style: TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ],
                 ),

                 const SizedBox(height: 35),

                 buildField(
                   nameController,
                   "Full Name",
                   Icons.person,
                 ),

                 buildField(
                   skillsController,
                   "Skills",
                   Icons.psychology,
                 ),

                 buildField(
                   experienceController,
                   "Experience",
                   Icons.work,
                 ),

                 buildField(
                   roleController,
                   "Target Role",
                   Icons.badge,
                 ),

                 const SizedBox(height: 10),

                 SizedBox(
                   width: double.infinity,
                   height: 58,

                   child: ElevatedButton(
                     onPressed:
                     isLoading ? null : generateResume,

                     style: ElevatedButton.styleFrom(
                       backgroundColor:
                       Colors.greenAccent,

                       foregroundColor: Colors.black,

                       shape: RoundedRectangleBorder(
                         borderRadius:
                         BorderRadius.circular(18),
                       ),
                     ),

                     child: isLoading
                         ? const CircularProgressIndicator(
                       color: Colors.black,
                     )
                         : const Text(
                       "Generate Resume",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 17,
                       ),
                     ),
                   ),
                 ),

                 const SizedBox(height: 30),

                 if (generatedResume.isNotEmpty)
                   resumeCard(),
               ],
             ),
           ),
         ),
       ),
     );
   }
 }

