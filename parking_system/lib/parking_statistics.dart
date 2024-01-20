import 'package:flutter/material.dart';

class ParkingStatistics extends StatefulWidget {
  const ParkingStatistics(
      {super.key,
      required this.category,
      required this.parkingName,
      required this.spotId,
      required this.vehicleReg});

  final String category;
  final String parkingName;
  final String spotId;
  final String vehicleReg;
  @override
  State<ParkingStatistics> createState() => _ParkingStatisticsState(
      selectedCategory: category,
      selectedParking: parkingName,
      selectedSpot: spotId,
      selectedVehicle: vehicleReg);
}

class _ParkingStatisticsState extends State<ParkingStatistics> {
  String selectedParking;
  String selectedVehicle;
  String selectedSpot;
  String selectedCategory;
  List<String> categories = ['Parkings', 'Vehicles'];
  List<String> spotIds = [];
  List<String> cars = [];

  List<String> parkingNames = [];
  _ParkingStatisticsState(
      {required this.selectedCategory,
      required this.selectedParking,
      required this.selectedSpot,
      required this.selectedVehicle}) {
    getParkingData();
  }

  void getParkingData() {
    //DB connection TO DO
    parkingNames.add("Parking 1");
    parkingNames.add("Parking 2");
    parkingNames.add("Parking 3");
    for (var i = 0; i < 100; i++) {
      spotIds.add(i.toString());
      cars.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (selectedCategory == 'Parkings') {
      return Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: height - 30,
          width: width - 30,
          color: Colors.white60,
        ),
        Row(children: [
          Material(
              child: Container(
                  width: width / 2,
                  child: Form(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      DropdownButton<String>(
                        value: selectedCategory,
                        style: TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return parkingNames.where((String parking) {
                            return parking
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String value) {
                          setState(() {
                            selectedParking = value;
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          textEditingController.text = selectedParking ?? '';
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            style: TextStyle(color: Colors.white),
                            onFieldSubmitted: (_) => onFieldSubmitted(),
                            decoration: InputDecoration(
                              labelText: 'Select parking',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: SizedBox(
                                height: 200.0,
                                width: width / 2,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      child: ListTile(
                                        title: Text(
                                          option,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return spotIds.where((String spot) {
                            return spot
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String value) {
                          setState(() {
                            selectedSpot = value;
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          textEditingController.text = selectedSpot ?? '';
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onFieldSubmitted: (_) => onFieldSubmitted(),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Select spot',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: SizedBox(
                                height: 200.0,
                                width: width / 2,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      child: ListTile(
                                        title: Text(option),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
                  )))),
          Container(
            width: (width / 2),
            child: Scaffold(
                body: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Text(
                    'Parking data',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Parking spots: ',
                        style: TextStyle(color: Colors.white)),
                    Text('100', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Free spots: ', style: TextStyle(color: Colors.white)),
                    Text('50', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Occupied spots: ',
                        style: TextStyle(color: Colors.white)),
                    Text('50', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Current income: ',
                        style: TextStyle(color: Colors.white)),
                    Text('250 zł', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Average daily income: ',
                        style: TextStyle(color: Colors.white)),
                    Text('245.88 zł', style: TextStyle(color: Colors.white))
                  ]),
                ),
                // Parking spot data -------------------------------------
                SizedBox(
                  height: 100,
                  child: Text(
                    'Parking spot data',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Parking spot ID: ',
                        style: TextStyle(color: Colors.white)),
                    Text('5', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Currently occupied by: ',
                        style: TextStyle(color: Colors.white)),
                    Text('n/a', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Occupied since: ',
                        style: TextStyle(color: Colors.white)),
                    Text('n/a', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Income from current reservation: ',
                        style: TextStyle(color: Colors.white)),
                    Text('n/a', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Average daily income: ',
                        style: TextStyle(color: Colors.white)),
                    Text('45.65 zł', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('History: ', style: TextStyle(color: Colors.white)),
                  ]),
                )
              ],
            )),
          )
        ])
      ]);
    } else {
      return Stack(alignment: AlignmentDirectional.center, children: [
        Container(
          height: height - 30,
          width: width - 30,
          color: Colors.white60,
        ),
        Row(children: [
          Material(
              child: Container(
                  width: width / 2,
                  child: Form(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      DropdownButton<String>(
                        value: selectedCategory,
                        style: TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return parkingNames.where((String parking) {
                            return parking
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String value) {
                          setState(() {
                            selectedParking = value;
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          textEditingController.text = selectedParking ?? '';
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            style: TextStyle(color: Colors.white),
                            onFieldSubmitted: (_) => onFieldSubmitted(),
                            decoration: InputDecoration(
                              labelText: 'Select parking',
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              child: SizedBox(
                                height: 200.0,
                                width: width / 2,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(8.0),
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final String option =
                                        options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      child: ListTile(
                                        title: Text(
                                          option,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
                  )))),
          Container(
            width: (width / 2),
            child: Scaffold(
                body: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Text(
                    'Parking data',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Parking spots: ',
                        style: TextStyle(color: Colors.white)),
                    Text('100', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Free spots: ', style: TextStyle(color: Colors.white)),
                    Text('50', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Occupied spots: ',
                        style: TextStyle(color: Colors.white)),
                    Text('50', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Current income: ',
                        style: TextStyle(color: Colors.white)),
                    Text('250 zł', style: TextStyle(color: Colors.white))
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text('Average daily income: ',
                        style: TextStyle(color: Colors.white)),
                    Text('245.88 zł', style: TextStyle(color: Colors.white))
                  ]),
                ),
              ],
            )),
          )
        ])
      ]);
    }
  }
}
