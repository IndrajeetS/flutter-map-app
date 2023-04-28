import 'package:flutter/material.dart';
import 'package:flutter_map_app/widgets/map_view_widget.dart';

class MapsPage extends StatelessWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maps"), centerTitle: true),
      body: MapViewWidget(),
    );
  }
}
