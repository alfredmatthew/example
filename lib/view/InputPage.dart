import 'package:example/database/belajar.dart';
import 'package:flutter/material.dart';
import 'package:example/database/sql_helper.dart';
import 'package:example/model/user.dart';

class InputPage extends StatefulWidget {
  const InputPage({
    super.key,
    required this.title,
    required this.id,
    required this.name,
    required this.guru,
    required this.deskripsi,
  });

  final String? title, name, guru, deskripsi;
  final int? id;

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController controllerGuru = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  String selectedSubject = "Ilmu Pengetahuan Alam"; // Default subject

  // Map subjects to corresponding images
  Map<String, String> subjectImages = {
    "Ilmu Pengetahuan Alam": "assets/subject_1.jpg",
    "Ilmu Pengetahuan Sosial": "assets/subject_2.jpg",
    "Pengolahan Bahasa Alami": "assets/subject_3.jpg",
    "Pemrograman Berbasis Platform": "assets/subject_4.jpg",
    "Penjaminan Mutu Perangkat Lunak": "assets/subject_5.jpg",
  };

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerGuru.text = widget.guru!;
      controllerDeskripsi.text = widget.deskripsi!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Mata Pelajaran"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          Image.asset(
            subjectImages[selectedSubject] ?? "assets/default_image.jpg",
            width: 200,
            height: 200,
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  iconSize: 0.0,
                  value: selectedSubject,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubject = newValue!;
                    });
                  },
                  items: <String>[
                    "Ilmu Pengetahuan Alam",
                    "Ilmu Pengetahuan Sosial",
                    "Pengolahan Bahasa Alami",
                    "Pemrograman Berbasis Platform",
                    "Penjaminan Mutu Perangkat Lunak",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Icon(Icons.arrow_drop_down), // This is the dropdown icon
            ],
          ),
          SizedBox(height: 12),
          TextField(
            controller: controllerGuru,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Guru',
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: controllerDeskripsi,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Deskripsi',
            ),
          ),
          SizedBox(height: 48),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () async {
              if (widget.id == null) {
                await addMataPelajaran();
              } else {
                await editMataPelajaran(widget.id!);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> addMataPelajaran() async {
    await SQLBelajar.addmatapelajaran(
        selectedSubject, controllerGuru.text, controllerDeskripsi.text);
  }

  Future<void> editMataPelajaran(int id) async {
    await SQLBelajar.editmatapelajaran(
        id, selectedSubject, controllerGuru.text, controllerDeskripsi.text);
  }
}