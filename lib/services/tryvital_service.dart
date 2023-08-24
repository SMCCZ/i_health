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
   var response=await client.userService.createUser("000-0000-4567-2344-777");
    tryVitalHealthService.setUserId(response.bodyString);
    //ask for permissions
    tryVitalHealthService.syncData();
  }
}
