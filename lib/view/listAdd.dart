import 'package:example/database/belajar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getwidget/getwidget.dart';
import 'package:example/database/sql_helper.dart';
import 'package:example/repository/register_repository.dart';
import 'package:example/view/InputPage.dart';

Map<String, String> subjectImages = {
  "Ilmu Pengetahuan Alam": "assets/subject_1.jpg",
  "Ilmu Pengetahuan Sosial": "assets/subject_2.jpg",
  "Pengolahan Bahasa Alami": "assets/subject_3.jpg",
  "Pemrograman Berbasis Platform": "assets/subject_4.jpg",
  "Penjaminan Mutu Perangkat Lunak": "assets/subject_5.jpg",
};

//variabel global
List<Map<String,dynamic>> matapelajaran = [];

class listAdd extends StatefulWidget {
  const listAdd({Key? key}) : super(key: key);

  @override
  State<listAdd> createState() => _listAddState();
}

class _listAddState extends State<listAdd> {
  final formKey = GlobalKey<FormState>();

  @override
  void refresh() async {
    final data = await SQLBelajar.getmatapelajaran();
    setState(() {
      matapelajaran = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  Widget build(BuildContext context) => Scaffold(
        backgroundColor: GFColors.LIGHT,
        appBar: AppBar(
          title: Text("Materi Pembelajaran"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InputPage(
                      title: 'INPUT ',
                      id: null,
                      name: null,
                      guru: null,
                      deskripsi: null,
                    ),
                  ),
                ).then((_) => refresh());
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: matapelajaran.length,
          itemBuilder: (context, index) {
            int displayIndex = index + 1;
            String subjectName = matapelajaran[index]['nama'];
            String guruName = matapelajaran[index]['guru'];
            String deskripsi = matapelajaran[index]['deskripsi'];
            String imageAsset = subjectImages[subjectName] ?? "assets/default_image.jpg";

            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0) + EdgeInsets.only(top: 28.0, bottom: 5.0),
                  child: Text("Materi Pelajaran - Item #$displayIndex", style: TextStyle(fontSize: 18)),
                ),
                GFCard(
                  boxFit: BoxFit.cover,
                  titlePosition: GFPosition.end,
                  image: Image.asset(
                    imageAsset,
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  padding: EdgeInsets.only(bottom: 9),
                  showImage: true,
                  title: GFListTile(
                    avatar: GFAvatar(
                      backgroundImage: AssetImage('assets/app_icon.png'),
                    ),
                    titleText: subjectName,
                    subTitleText: guruName,
                  ),
                  content: Column(
                    children: <Widget>[
                      Container(
                        width: 330.0,
                        alignment: Alignment.center,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                        child: Text(
                          deskripsi,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                 buttonBar: GFButtonBar(
                    padding: EdgeInsets.only(top: 12),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                               await deletePelajaran(matapelajaran[index]['id']);
                            },
                            child: GFAvatar(
                              backgroundColor: GFColors.DANGER,
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InputPage(
                                    title: 'Input Mata Pelajaran', 
                                    id: matapelajaran[index]['id'], 
                                    name: matapelajaran[index]['nama'], 
                                    guru: matapelajaran[index]['guru'],
                                    deskripsi: matapelajaran[index]['deskripsi'])),
                              ).then((_) => refresh());
                            },
                            child: GFAvatar(
                              backgroundColor: GFColors.SUCCESS,
                              child: Icon(
                                Icons.update,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

  Future<void> deletePelajaran(int id) async {
    await SQLBelajar.deleteUser(id);
    refresh();
  }
}