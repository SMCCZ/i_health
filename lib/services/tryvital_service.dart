// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';
import 'package:i_health/config.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health/vital_health.dart';

class TryVital {
  final client = VitalClient();

  final tryVitalHealthService = HealthServices(
    apiKey: tryVitalapiKey,
    region: Region.us,
    environment: Environment.sandbox,
  );

  Future initTryVital() async {
    // final tryVitalHealthService = HealthServices(
    //   apiKey: tryVitalapiKey,
    //   region: Region.us,
    //   environment: Environment.sandbox,
    // );

    await tryVitalHealthService.configureClient();

    await tryVitalHealthService.configureHealth(
      config: const HealthConfig(
        iosConfig: IosHealthConfig(
          backgroundDeliveryEnabled: true,
        ),
      ),
    );
    // var response=await client.userService.createUser("b199a85f-f76a-4932-abdf-4a0146acca9b");
    tryVitalHealthService.setUserId("b199a85f-f76a-4932-abdf-4a0146acca9b");
    //ask for permissions
    // requestHealthPermissions();
    tryVitalHealthService.syncData();
  }

  Future<void> requestHealthPermissions(BuildContext context) async {
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [...HealthDataType.values.map((e) => e)];
    var result = await health.requestAuthorization(types);
    if (result) {
      print("Health permissions granted.");
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Health permissions granted.",
                ),
              ),
              actions: [
                CupertinoButton(
                  child: const Text("Ok"),
                  onPressed: () {
                   // fetchData();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      print("Health permissions denied.");
    }
  }

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  fetchData() async {
    var data = await health.getHealthDataFromTypes(
        DateTime.now().subtract(Duration(hours: 1)),
        DateTime.now(),
        [...HealthDataType.values]);
    for (var i = 0; i < data.length; i++) {
      try {
        if (health.isDataTypeAvailable(HealthDataType.values[i])) {
          print("${data[i].sourceName} ${data[i].value}");
        }
      } catch (e) {}
    }

    var counts = await health.getTotalStepsInInterval(
        DateTime.now().subtract(Duration(hours: 1)), DateTime.now());
    print(counts);
  }

  getDataByTypes() async {
    try {
      var data = await health.getHealthDataFromTypes(
          DateTime.now().subtract(Duration(hours: 1)),
          DateTime.now(),
          [...HealthDataType.values]);

      print("${data.first.sourceName} ${data.first.value}");
      return data.first;
    } catch (e) {
      return null;
    }
  }

  
}
