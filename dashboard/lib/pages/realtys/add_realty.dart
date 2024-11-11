// ignore_for_file: non_constant_identifier_names, duplicate_ignore
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/pages/realtys/realtys.dart';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/provider/loading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';
import '../function.dart';
import 'realtys_cat.dart';

class AddRealtys extends StatefulWidget {
  AddRealtys({
    Key? key,
  }) : super(key: key);

  @override
  _AddRealtysState createState() => _AddRealtysState();
}

// ignore: duplicate_ignore
class _AddRealtysState extends State<AddRealtys> {
  String? initialValue_type;
  String? initialValue_cat;

  String selected_type = "اختر صفة العقار";
  String selected_cat = "اختر نوع العقار";
  var itemList = ["بيع", "آجار", "غير ذلك"];

  var cat_id_list = catNIList!.map((e) {
    return e.cat_id;
  }).toList();
  var cat_id;

  var cat_nameList = catNIList!.map((e) {
    return e.cat_name;
  });

  var cat_name_list = catNIList!.map((e) {
    return e.cat_name;
  }).toList();
  void getNI() {
    for (int i = 0; i < catNIList!.length; i++) {
      if (cat_name_list[i] == initialValue_cat) {
        cat_id = cat_id_list[i];
      }
    }
  }

  bool isloading = false;
  bool checkActive = false;
  final _formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  TextEditingController txtrealty_short_title = TextEditingController();
  TextEditingController txtrealty_number_phone = TextEditingController();
  TextEditingController txtrealty_type = TextEditingController();
  TextEditingController txtrealty_summary = TextEditingController();
  TextEditingController txtrealty_price = TextEditingController();

  saveRealy(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("المعلومات غير صحيحة", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtrealty_short_title.text.isNotEmpty
        // &&
        //     initialValue_type != null &&
        //     initialValue_type != "غير ذلك" &&
        //     txtrealty_number_phone.text.isNotEmpty &&
        //     // fileUrl != null &&
        //     // fileUrl != "" &&
        //     myvalid ||
        // txtrealty_short_title.text.isNotEmpty &&
        //     txtrealty_type.text.isNotEmpty
        ) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "cat_id": cat_id,
        "realty_short_title": txtrealty_short_title.text,
        "realty_type": initialValue_type == "غير ذلك"
            ? txtrealty_type.text
            : initialValue_type,
        "number_phone": txtrealty_number_phone.text,
        "realty_block": checkActive ? "1" : "0",
        "realty_summary": txtrealty_summary.text,
        "realty_token": token,
        "realty_price": txtrealty_price.text,
      };

      bool res = await uploadImageWithData(_image, arr,
          "realtys/insert_realty.php", context, () => Realtys(), "insert");
      isloading = res;
      load.add_loading();
    } else {
      Toast.show('المعلومات غير صحيحة', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getNI();
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    txtrealty_short_title.dispose();
    txtrealty_number_phone.dispose();
    txtrealty_type.dispose();
    txtrealty_summary.dispose();
    txtrealty_price.dispose();
  }

  File? _image;
  final picker = ImagePicker();
  Future getImageGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
        getNI();

  }

  // var fileUrl;
  // Future selectFile() async {
  //   getNI();
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'pdf'
  //       //,'doc' , 'docx', 'ppt', 'pptx'
  //     ],
  //   );

  //   if (result != null) {
  //     PlatformFile file = result.files.first;

  //     print(file.name);
  //     print(file.bytes);
  //     print(file.size);
  //     print(file.extension);
  //     print(file.path);
  //     setState(() {
  //       fileUrl = file.path;
  //     });
  //     print(fileUrl);
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  Future getImageCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
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
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("كاميرا"),
                onTap: () {
                  getImageCamera();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pcWhite,
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: pcPink,
        elevation: 0.0,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'إضافة عقار جديد',
            style: TextStyle(
              fontSize: 30, fontFamily: "Cairo",
              // color: Colors.tealAccent
            ),
          ),
        ),
        // centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     size: 30,
        //     color: Colors.tealAccent,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Consumer<LoadingControl>(builder: (context, load, child) {
              return Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: txtrealty_short_title,
                        decoration: const InputDecoration(
                            hintText: "عنوان وتوصيف قصير للعقار",
                            border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء الإدخال بشكل صحيح';
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton(
                        hint:
                            Text(selected_type, style: TextStyle(fontSize: 18)),
                        isExpanded: true,

                        //iconEnabledColor: Colors.white,
                        // style: TextStyle(color: Colors.black, fontSize: 16),
                        // dropdownColor: Colors.green,
                        // focusColor: Colors.black,
                        value: initialValue_type,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: itemList.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selected_type = "";
                            initialValue_type = newValue!;
                          });
                        },
                      ),
                    ),
                    initialValue_type == "غير ذلك"
                        ? Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: txtrealty_type,
                              decoration: const InputDecoration(
                                  hintText: "اختر صفة العقار",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء الاختيار بشكل صحيح';
                                }
                                return null;
                              },
                            ),
                          )
                        : Container(),
//////////////////////////begin

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: DropdownButton(
                        hint:
                            Text(selected_cat, style: TextStyle(fontSize: 18)),
                        isExpanded: true,

                        //iconEnabledColor: Colors.white,
                        // style: TextStyle(color: Colors.black, fontSize: 16),
                        // dropdownColor: Colors.green,
                        // focusColor: Colors.black,
                        value: initialValue_cat,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cat_nameList.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selected_cat = "";
                            initialValue_cat = newValue!;
                          });
                        },
                      ),
                    ),

/////////
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: txtrealty_number_phone,
                        decoration: const InputDecoration(
                            hintText: "رقم الجوال",
                             border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم صحيح';
                          }

                          return null;
                        },
                      ),
                    ),

                    // CheckboxListTile(
                    //   title: const Text('العقار مجاني'),
                    //   value: checkActive,
                    //   onChanged: (value) => setState(() => {
                    //         checkActive = value!,
                    //         if (value == true)
                    //           {visible_enable = true, visible_text_price = false}
                    //         else
                    //           {visible_enable = false, visible_text_price = true}
                    //       }),
                    // ),
                    // Visibility(
                    //   visible: visible_text_price,
                    //   child: Container(
                    //     margin: const EdgeInsets.all(10.0),
                    //     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    //     decoration: BoxDecoration(
                    //       color: pcGrey,
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //     child: TextFormField(
                    //       readOnly: visible_enable,
                    //       keyboardType: TextInputType.number,
                    //       decoration: const InputDecoration(
                    //           hintText: "سعر العقار (بالدولار)",
                    //           border: InputBorder.none),
                    //       validator: (value) {
                    //         if (value == null || value.isEmpty) {
                    //           return 'الرجاء إدخال سعر العقار';
                    //         }
                    //         if (value.length >= 6) {
                    //           return 'لا يمكن أن يكون بهذا السعر';
                    //         }
                    //         return null;
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: txtrealty_price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "سعر العقار (بالدولار)",
                            border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال سعر العقار';
                          }
                          if (value.length >= 12) {
                            return 'لا يمكن أن يكون بهذا السعر';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MaterialButton(
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
                            Expanded(
                              child: _image == null
                                  ? Text("الصورة غير محددة")
                                  : Image.file(
                                      _image!,
                                      width: 150.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //// file
                    // Container(
                    //   margin: const EdgeInsets.all(10.0),
                    //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    //   decoration: BoxDecoration(
                    //     color: pcGrey,
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       // selectFile();
                    //     },
                    //     child: Row(
                    //       children: [
                    //         // Expanded(
                    //         //     child: fileUrl == null
                    //         //         ? Text("العقار غير محمل")
                    //         //         : Text(fileUrl)),
                    //         // Icon(
                    //         //   Icons.upload_file,
                    //         //   size: 35.0,
                    //         //   color: Colors.green,
                    //         // )
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // // CheckboxListTile(
                    // //   title: const Text('free'),
                    // //   value: checkActive,
                    // //   onChanged: (newvalue) => setState(() => {
                    // //         checkActive = newvalue!,
                    // //         // if (value == true)
                    // //         //   {
                    // //         //     visible_enable = true,
                    // //         //     visible_text_price = false
                    // //         //   }
                    // //         // else
                    // //         //   {
                    // //         //     visible_enable = false,
                    // //         //     visible_text_price = true
                    // //         //   }
                    // //       }),
                    // // ),


                    Container(
                      height: MediaQuery.of(context).size.width / 2.7,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: pcGrey,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: txtrealty_summary,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                            hintText: 'ملخص عن العقار', border: InputBorder.none),
                      ),
                    ),

                    isloading
                        ? circularProgress()
                        : MaterialButton(
                            onPressed: () {
                              saveRealy(context, load);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "إضافة العقار",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0),
                              ),
                              margin: const EdgeInsets.only(
                                  bottom: 10.0, top: 20.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: pcPink,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            )),
                  ]),

                  //f
                ),
              );
            })
          ]),
        ),
      ),
    );
  }
}
