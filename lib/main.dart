import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const JobMarketApp());
}

class JobMarketApp extends StatelessWidget {
  const JobMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Market',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const JobListPage(),
    );
  }
}

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Market')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final jobs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index].data();
              return ListTile(
                title: Text(job['title'] ?? 'No title'),
                subtitle: Text(job['description'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
