import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/optimization_bloc.dart';
import '../../bloc/optimization_event.dart';
import '../../bloc/optimization_state.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../shared/widgets/smart_image.dart';

class OptimizationSettingsPage extends StatelessWidget {
  const OptimizationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data & Storage Optimization"),
        elevation: 0,
      ),
      body: BlocBuilder<OptimizationBloc, OptimizationState>(
        builder: (context, state) {
          return ListView(
            children: [
              _buildNetworkStatusHeader(state.connectivityStatus),
              const Divider(),
              SwitchListTile(
                title: const Text("Auto-download on Wi-Fi"),
                subtitle: const Text("Download updates and resources automatically when connected to Wi-Fi."),
                value: state.autoDownloadOnWifi,
                onChanged: (val) {
                  context.read<OptimizationBloc>().add(ToggleAutoDownloadOnWifi(val));
                },
                secondary: const Icon(Icons.wifi_protected_setup),
              ),
              SwitchListTile(
                title: const Text("Data Saver Mode"),
                subtitle: const Text("Reduce data usage on cellular networks by pausing large image downloads."),
                value: state.dataSaverMode,
                onChanged: (val) {
                  context.read<OptimizationBloc>().add(ToggleDataSaverMode(val));
                },
                secondary: const Icon(Icons.data_saver_on),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Preview: Data-Conscious Image",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const SmartImage(
                    imageUrl: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800",
                    blurHash: "L6PZf6ayfQay~qj[fQayfQfQfQfQ", // Placeholder hash
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "If Data Saver is ON and you are on Cellular, the image will be dimmed and require a tap to load.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.blueGrey,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Storage Tip",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Images are cached locally to save data. You can clear the cache in system settings if needed.",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNetworkStatusHeader(ConnectionStatus status) {
    IconData icon;
    String text;
    Color color;

    switch (status) {
      case ConnectionStatus.wifi:
        icon = Icons.wifi;
        text = "Connected via Wi-Fi";
        color = Colors.green;
        break;
      case ConnectionStatus.cellular:
        icon = Icons.signal_cellular_alt;
        text = "Connected via Cellular";
        color = Colors.blue;
        break;
      case ConnectionStatus.none:
        icon = Icons.cloud_off;
        text = "No Internet Connection";
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
