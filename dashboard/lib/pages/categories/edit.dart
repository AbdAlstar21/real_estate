// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import, must_be_immutable, non_constant_identifier_names

import 'package:dashboard/pages/categories/category_data.dart';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/function.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'categories.dart';

class EditCategory extends StatefulWidget {
  int cat_index;
  CategoryData mycategory;

  EditCategory({Key? key, required this.cat_index, required this.mycategory})
      : super(key: key);
  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController txtcat_name = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  Future getImageGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        // ignore: avoid_print
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
  //       print('No image selected.');
  //     }
  //   });
  // }

  updateCategory(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtcat_name.text.isNotEmpty && myvalid) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "cat_id": widget.mycategory.cat_id,
        "cat_name": txtcat_name.text,
      };
      bool res = await uploadImageWithData(_image, arr,
          "categories/update_cat.php", context, () => Categories(), "update");
      categoryList![widget.cat_index].cat_name = txtcat_name.text;

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

  String imageEdit = "";
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    txtcat_name.text = widget.mycategory.cat_name;
    imageEdit = widget.mycategory.cat_thumbnail == ""
        ? ""
        : images_path + "categories/" + widget.mycategory.cat_thumbnail;
  }

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
              // new ListTile(
              //   leading: new Icon(Icons.camera),
              //   title: new Text("كاميرا"),
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
        // backgroundColor: Colors.grey[100],
        backgroundColor: pcWhite,
        appBar: AppBar(
          backgroundColor: pcPink,
          title: const Text("تعديل بيانات نوع"),
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
                                color: pcGrey,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: txtcat_name,
                              decoration: const InputDecoration(
                                  hintText: "اسم المستخدم",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // print("enyter name");
                                  return "الرجاء ادخال الاسم ";
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.image,
                                      size: 60.0,
                                      color: Colors.orange[400],
                                    ),
                                    onPressed: () {
                                      showSheetGallery(context);
                                    }),
                              ),
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                child: _image == null
                                    ? (imageEdit == ""
                                        ? const Text("الصورة غير محددة")
                                        : ImageNetwork(
                                            image: imageEdit,
                                            height: 200,
                                            width: 300,
                                            onLoading:
                                                CircularProgressIndicator(
                                              color: pcPinkLight,
                                            ),
                                            onError: const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          ))
                                    : Image.file(
                                        _image!,
                                        width: 200.0,
                                        height: 300.0,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          ),
                          isloading
                              ? circularProgress()
                              : MaterialButton(
                                  onPressed: () {
                                    updateCategory(context, load);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "حفظ",
                                      style: TextStyle(
                                          color: pcGrey, fontSize: 30.0),
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
