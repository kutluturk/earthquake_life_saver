import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.earthquakelifesaver/ble_advertising";
    private BLEAdvertiser bleAdvertiser;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        bleAdvertiser = new BLEAdvertiser(this);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("startAdvertising")) {
                        // Check if the call has an argument "data"
                        if (call.hasArgument("data")) {
                            String advertisementDataString = call.argument("data");
                            bleAdvertiser.startAdvertising(advertisementDataString);
                        } else {
                            bleAdvertiser.startAdvertising();
                        }
                        result.success(null);
                    } else if (call.method.equals("stopAdvertising")) {
                        bleAdvertiser.stopAdvertising();
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }
}
