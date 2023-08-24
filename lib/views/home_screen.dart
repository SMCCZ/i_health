import 'package:flutter/material.dart';
import 'package:vital_health/vital_health.dart';

import '../services/tryvital_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    TryVital().initTryVital();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          StreamBuilder<SyncStatus>(
            stream: TryVital().tryVitalHealthService.status,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error Syncing Data");
              }
              if (snapshot.hasData) {
                return Container();
              } else {
                return const Text("No Data Found");
              }
            },
          )
        ],
      ),
    );
  }
}
