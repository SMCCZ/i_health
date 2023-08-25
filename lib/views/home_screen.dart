import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/health.dart';
import 'package:vital_health/vital_health.dart';

import '../services/tryvital_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final health = HealthFactory(useHealthConnectIfAvailable: true);
  final _startDate = DateTime.now().subtract(const Duration(days: 1));
  final _endDate = DateTime.now();
  bool _isPermissionGranted = false;

  int? _stepCount;
  @override
  void initState() {
    TryVital().initTryVital();
    _getStepsCount();
    super.initState();
  }

  _getStepsCount() async {
    _isPermissionGranted =
        await health.hasPermissions([HealthDataType.STEPS]) ?? false;
    _stepCount = await health.getTotalStepsInInterval(_startDate, _endDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "iHealth",
        ),
      ),
      body: ListView(
        children: [
          StreamBuilder<SyncStatus>(
            stream: TryVital().tryVitalHealthService.status,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error Syncing Data");
              }
              if (snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                      snapshot.data?.status.name.toUpperCase() ?? "NO Data"),
                );
              } else {
                return const Text("No Data Found");
              }
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black26,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "STEPS COUNT",
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_walk_outlined,
                      color: Colors.green,
                    ),
                    Text(
                      "${_stepCount ?? 'NILL'}",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!_isPermissionGranted)
            CupertinoButton(
              child: Text("Ask permission"),
              onPressed: () {
                TryVital().requestHealthPermissions(context);
              },
            )
        ],
      ),
    );
  }
}
