import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:leos/services/web_service.dart';
import 'package:leos/widgets/feature_button.dart';
import 'package:leos/utils/app_styles.dart';


class TransmissionLog {
  final bool? isSuccess; // Nullable for receive logs
  final String timestamp;
  final String description;

  TransmissionLog({
    this.isSuccess,
    required this.timestamp,
    required this.description,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _version = '';
  int _signalValue = 0;
  final WebService _webService = WebService();

  final List<TransmissionLog> _transmitLogs = [
    TransmissionLog(
      isSuccess: true,
      timestamp: '27thJune, 2024, 14:00',
      description: 'Mineral data; 41.40338, 2.17403',
    ),
    TransmissionLog(
      isSuccess: false,
      timestamp: '26thJune, 2024, 11:00',
      description: 'Soil data; 41.40338, 2.17403',
    ),
    TransmissionLog(
      isSuccess: true,
      timestamp: '27thJune, 2024, 14:00',
      description: 'Mineral data; 41.40338, 2.17403',
    ),
    TransmissionLog(
      isSuccess: false,
      timestamp: '26thJune, 2024, 11:00',
      description: 'Soil data; 41.40338, 2.17403',
    ),
  ];

  final List<TransmissionLog> _receiveLogs = [
    TransmissionLog(
      timestamp: '27thJune, 2024, 14:00',
      description: 'Mineral data; 41.40338, 2.17403',
    ),
    TransmissionLog(
      timestamp: '26thJune, 2024, 11:00',
      description: 'Soil data; 41.40338, 2.17403',
    ),
    TransmissionLog(
      timestamp: '27thJune, 2024, 14:00',
      description: 'Mineral data; 41.40338, 2.17403',
    ),
    TransmissionLog(
      timestamp: '26thJune, 2024, 11:00',
      description: 'Soil data; 41.40338, 2.17403',
    ),
  ];

  late final ScrollController _transmitScrollController;
  late final ScrollController _receiveScrollController;

  @override
  void initState() {
    super.initState();
    _transmitScrollController = ScrollController();
    _receiveScrollController = ScrollController();
    _loadVersionInfo();
    _startWebService();
  }

  @override
  void dispose() {
    _transmitScrollController.dispose();
    _receiveScrollController.dispose();
    _stopWebService();
    super.dispose();
  }

  void _onSignalChanged() {
    setState(() {
      _signalValue = _webService.signalNotifier.value;
    });
  }

  Future<void> _startWebService() async {
     _webService.startServer();
     _webService.signalNotifier.addListener(_onSignalChanged);
  }

  void _stopWebService() async {
    _webService.signalNotifier.removeListener(_onSignalChanged);
    _webService.stopServer();
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'Ver.${packageInfo.version}';
    });
  }

  void _sendSOS() {
    // TODO: Implement actual SOS logic
    print('SOS Sent from HomePage!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_main.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildFeatureButtons(context),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data transmission information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDataTransmissionInfo(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppStyles.appBarHeight),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppStyles.appBarPaddingLeft),
          child: Center(child: Image.asset('assets/images/ic_logo.png')),
        ),
        leadingWidth: 360,
        // Adjust width for the logo
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_toolbar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // TODO: Handle Settings tap
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ic_settings.png',
                        height: AppStyles.appBarIconSize,
                        width: AppStyles.appBarIconSize,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Setting',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 48),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ic_signal_$_signalValue.png',
                      height: AppStyles.appBarIconSize,
                      width: AppStyles.appBarIconSize,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Iridium',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '\$ 0.00',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    _version,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(width: AppStyles.appBarPaddingRight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          FeatureButton(iconAsset: 'assets/images/ic_text.png', label: 'Text'),
          const SizedBox(width: 8),
          FeatureButton(
            iconAsset: 'assets/images/ic_data_stream.png',
            label: 'Data Stream',
          ),
          const SizedBox(width: 8),
          FeatureButton(
            iconAsset: 'assets/images/ic_emergency.png',
            label: 'Emergency',
            isEmergency: true,
            onSosTriggered: _sendSOS,
          ),
          const SizedBox(width: 8),
          FeatureButton(
            iconAsset: 'assets/images/ic_history.png',
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(TransmissionLog log, int index) {
    final backgroundColor = index.isEven
        ? const Color.fromRGBO(0, 0, 0, 0.1)
        : const Color.fromRGBO(0, 0, 0, 0.3);

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          if (log.isSuccess != null)
            Icon(
              log.isSuccess! ? Icons.check_circle : Icons.cancel,
              color: log.isSuccess! ? Colors.greenAccent : Colors.redAccent,
              size: 20,
            ),
          if (log.isSuccess != null) const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${log.timestamp}; ${log.description}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTransmissionInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 32.0,
          top: 8.0,
          right: 32,
          bottom: 8,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transmit :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _transmitScrollController,
                        child: ListView.builder(
                          controller: _transmitScrollController,
                          itemCount: _transmitLogs.length,
                          itemBuilder: (context, index) =>
                              _buildLogItem(_transmitLogs[index], index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Receive :',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _receiveScrollController,
                        child: ListView.builder(
                          controller: _receiveScrollController,
                          itemCount: _receiveLogs.length,
                          itemBuilder: (context, index) =>
                              _buildLogItem(_receiveLogs[index], index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


