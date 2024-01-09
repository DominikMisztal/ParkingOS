import 'package:flutter/material.dart';
import 'package:parking_system/components/myCustomTextField.dart';

class Parkfinder extends StatefulWidget {
  const Parkfinder({super.key});

  @override
  State<Parkfinder> createState() => _ParkfinderState();
}

class _ParkfinderState extends State<Parkfinder> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        color: Colors.white,
      ),
      Container(
        width: width * 3 / 5,
        color: Colors.black87,
      ),
      Container(
        width: width / 3,
        child: Column(
          children: [
            Text('Search for your Parking'),
            MyCustomTextField(
              controller: controller,
              labelText: 'Find parking',
              obscureText: false,
            ),

            const SizedBox(
              height: 64,
            ),
            //Todo - spytać chlopakow, jak to robimy

            SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'Parking $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
          ],
        ),
      ),
    ]);
  }
}
