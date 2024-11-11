// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import, non_constant_identifier_names, avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dashboard/pages/categories/categories.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/pages/config.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import '../components/progres.dart';
import '../function.dart';
import 'package:path/path.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController txtcat_name = TextEditingController();

  saveData(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtcat_name.text.isNotEmpty && myvalid) {
      isloading = true;
      load.add_loading();
      Map arr = {"cat_name": txtcat_name.text};
      bool res = await uploadImageWithData(_image, arr,
          "categories/insert_cat.php", context, () => Categories(), "insert");
      /*await createData(
          arr, "category/insert_category.php", context, () => Category());*/
        

      isloading = res;
      load.add_loading();
    } else {
      Toast.show("Please fill data", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    txtcat_name.dispose();
  }

  File? _image;
  final picker = ImagePicker();
  Future getImageGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        // print('No image selected.');
      }
    });
  }

  // Future getImageCamera() async {
  //   var image = await picker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     if (image != null) {
  //       _image = File(image.path);
  //     } else {
  //       // print('No image selected.');
  //     }
  //   });
  // }

  void showSheetGallery(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("معرض الصور"),
                onTap: () {
                  getImageGallery();
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.camera),
              //   title: const Text("كاميرا"),
              //   onTap: () {
              //     getImageCamera();
              //   },
              // ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pcWhite,

        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          // backgroundColor: pcPink,
          title: const Text("اضافة نوع جديد"),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Consumer<LoadingControl>(builder: (context, load, child) {
                  return Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                color: Color.fromARGB(255, 231, 219, 182),
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtcat_name,
                              decoration: const InputDecoration(
                                  hintText: "اسم التصنيف",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // print("enter name");
                                  return "الرجاء ادخال الاسم ";
                                }
                                return null;
                              },
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              showSheetGallery(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 35.0,
                                  color: Colors.orange[400],
                                ),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                Expanded(
                                  child: _image == null
                                      ? Text("الصورة غير محددة")
                                      : Image.file(
                                          _image!,
                                          width: 80.0,
                                          height: 150.0,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          isloading
                              ? circularProgress()
                              : MaterialButton(
                                  onPressed: () {
                                    saveData(context, load);
                                            log('immmmm: $_image');

                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "حفظ",
                                      style: TextStyle(
                                          // color: Colors.white
                                          color: Color.fromARGB(
                                              255, 231, 219, 182),
                                          fontSize: 30.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        bottom: 10.0, top: 10.0),
                                    padding: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        color: pcPink,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                  )),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
