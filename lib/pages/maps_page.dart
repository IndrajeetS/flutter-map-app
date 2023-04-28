import 'package:flutter/material.dart';
import 'package:flutter_map_app/widgets/map_view_widget.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: MapViewWidget(),
    );
  }

  // Extract Appbar as method
  buildAppbar() {
    return AppBar(
      title: const Text("Maps"),
      centerTitle: true,
    );
  }
}
