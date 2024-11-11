// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_network/image_network.dart';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:dashboard/pages/realtys/realtys_data.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/function.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';

import 'realtys.dart';
import 'package:dashboard/pages/realtys/realtys.dart';

class EditRealtys extends StatefulWidget {
  int realty_index;
  RealtysData realtys;

  EditRealtys({Key? key, required this.realty_index, required this.realtys})
      : super(key: key);
  @override
  _EditRealtysState createState() => _EditRealtysState();
}

class _EditRealtysState extends State<EditRealtys> {
  String? initialValue;
  String? initialValue_cat;
  String? initialValue_cat_id;

  String selected = "اختر صفة العقار";
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
  TextEditingController txtrealty_short_title = TextEditingController();
  TextEditingController txtnumber_phone = TextEditingController();
  TextEditingController txtrealty_type = TextEditingController();
  TextEditingController txtrealty_summary = TextEditingController();
  TextEditingController txtrealty_price = TextEditingController();

  updateRealty(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    bool myvalid = _formKey.currentState!.validate();
    load.add_loading();
    if (txtrealty_short_title.text.isNotEmpty &&
            initialValue != null &&
            initialValue != "غير ذلك" &&
            txtnumber_phone.text.isNotEmpty &&
            myvalid ||
        txtrealty_short_title.text.isNotEmpty &&
            txtrealty_type.text.isNotEmpty) {
      getNI();
      isloading = true;
      load.add_loading();
      Map arr = {
        "realty_id": widget.realtys.realty_id,
        "cat_id": cat_id,
        "realty_short_title": txtrealty_short_title.text,
        "realty_type":
            initialValue != "غير ذلك" ? initialValue : txtrealty_type.text,
        "number_phone": txtnumber_phone.text,
        "realty_price": txtrealty_price.text,
        "realty_block": checkActive ? "1" : "0",
        "realty_summary": txtrealty_summary.text,
      };
      bool res = await uploadImageWithData(_image, arr,
          "realtys/update_realty.php", context, () => Realtys(), "update");
      realtyList![widget.realty_index].realty_short_title =
          txtrealty_short_title.text;
      realtyList![widget.realty_index].realty_type = txtrealty_type.text;

      realtyList![widget.realty_index].realty_type = initialValue!;
      realtyList![widget.realty_index].number_phone = txtnumber_phone.text;
      realtyList![widget.realty_index].realty_price = txtrealty_price.text;
      realtyList![widget.realty_index].realty_summary = txtrealty_summary.text;
      realtyList![widget.realty_index].cat_id = cat_id;

      // realtyList![widget.realty_index].realty_block = checkActive;

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
    txtrealty_short_title.dispose();
    txtnumber_phone.dispose();
    txtrealty_type.dispose();
    txtrealty_summary.dispose();
    txtrealty_price.dispose();
  }

  String imageEdit = "";
  // String fileEdit = "";
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    // checkActive = widget.books.realty_block;

    txtrealty_short_title.text = widget.realtys.realty_short_title;
    txtrealty_summary.text = widget.realtys.realty_summary;
    txtnumber_phone.text = widget.realtys.number_phone;
    initialValue = widget.realtys.realty_type;
    txtrealty_price.text = widget.realtys.realty_price!;
    

    // initialValue_cat = widget.realtys.cat_id;
    for (int i = 0; i < catNIList!.length; i++) {
      if (cat_id_list[i] == widget.realtys.cat_id) {
        initialValue_cat = cat_name_list[i];
      }
    }
    bool test = false;
    for (int i = 0; i < itemList.length; i++) {
      if (itemList[i] == initialValue) {
        test = true;
      }
    }

    if (test == false) {
      initialValue = "غير ذلك";
      txtrealty_type.text = widget.realtys.realty_type;
    }

    imageEdit = widget.realtys.realty_thumbnail == ""
        ? ""
        : images_path + "realtys/" + widget.realtys.realty_thumbnail;
    // fileEdit = widget.realtys.book_file == ""
    //     ? ""
    //     : files_path_in_app + widget.realtys.book_file;
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

  // var fileUrl;
  // var fileSize;
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

  //     // print(file.name);
  //     // print(file.bytes);
  //     // print(file.size);
  //     // print(file.extension);
  //     // print(file.path);
  //     setState(() {
  //       fileUrl = file.path;
  //       fileSize = file.size;
  //     });
  //     print(fileUrl);
  //     print(fileSize);
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pcWhite,
        appBar: AppBar(
          // backgroundColor: pcBlue,
          title: const Text("تعديل بيانات عقار"),
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
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  return 'الرجاء إدخال العنوان بشكل صحيح';
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DropdownButton(
                              hint: Text(selected,
                                  style: TextStyle(fontSize: 18)),
                              isExpanded: true,

                              //iconEnabledColor: Colors.white,
                              // style: TextStyle(color: Colors.black, fontSize: 16),
                              // dropdownColor: Colors.green,
                              // focusColor: Colors.black,
                              value: initialValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: itemList.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selected = "";
                                  initialValue = newValue!;
                                });
                              },
                            ),
                          ),
                          initialValue == "غير ذلك"
                              ? Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  decoration: BoxDecoration(
                                    color: pcGrey,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: TextFormField(
                                    controller: txtrealty_type,
                                    decoration: const InputDecoration(
                                        hintText: "ادخل صفة العقار",
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال الصفة بشكل صحيح';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              : Container(),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: DropdownButton(
                              hint: Text(selected_cat,
                                  style: TextStyle(fontSize: 18)),
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

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: txtnumber_phone,
                              decoration: const InputDecoration(
                                  hintText: "رقم الجوال",
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الرقم  بشكل صحيح';
                                }

                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          // Container(
                          //   margin: const EdgeInsets.only(bottom: 10.0),
                          //   padding:
                          //       const EdgeInsets.only(left: 20.0, right: 20.0),
                          //   child: IconButton(
                          //       icon: Icon(
                          //         Icons.image,
                          //         size: 60.0,
                          //         color: Colors.orange[400],
                          //       ),
                          //       onPressed: () {
                          //         showSheetGallery(context);
                          //       }),
                          // ),
                          // Container(
                          //   padding: const EdgeInsets.all(15.0),
                          //   child: _image == null
                          //       ? (imageEdit == ""
                          //           ? const Text("الصورة غير محددة")
                          //           : ImageNetwork(
                          //               image: imageEdit,
                          //               height: 150,
                          //               width: 150,
                          //               onLoading: CircularProgressIndicator(
                          //                 color: Colors.indigoAccent,
                          //               ),
                          //               onError: const Icon(
                          //                 Icons.error,
                          //                 color: Colors.red,
                          //               ),
                          //             ))
                          //       : Image.file(
                          //           _image!,
                          //           width: 150.0,
                          //           height: 150.0,
                          //           fit: BoxFit.cover,
                          //         ),
                          // ),

                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                  Expanded(
                                    child: _image == null
                                        ? (imageEdit == ""
                                            ? Text("الصورة غير محددة")
                                            : ImageNetwork(
                                                image: imageEdit,
                                                height: 150,
                                                width: 150,
                                                onLoading:
                                                    CircularProgressIndicator(
                                                  color: Colors.indigoAccent,
                                                ),
                                                onError: const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              ))
                                        : Image.file(
                                            _image!,
                                            width: 150.0,
                                            height: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  _image == null && imageEdit == ""
                                      ? Icon(
                                          Icons.image,
                                          size: 35.0,
                                          color: Colors.red[400],
                                        )
                                      : Icon(
                                          Icons.image,
                                          size: 35.0,
                                          color: Colors.orange[400],
                                        ),
                                ],
                              ),
                            ),
                          ),

                          // Container(
                          //   margin: const EdgeInsets.all(10.0),
                          //   padding:
                          //       const EdgeInsets.only(left: 20.0, right: 20.0),
                          //   decoration: BoxDecoration(
                          //     color: pcGrey,
                          //     borderRadius: BorderRadius.circular(20.0),
                          //   ),
                          //   child: MaterialButton(
                          //     onPressed: () {
                          //       selectFile();
                          //     },
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //             child: fileUrl == null
                          //                 ? (fileEdit == ""
                          //                     ? Text("العقار غير محمل")
                          //                     : Text(fileEdit))
                          //                 : Text(fileUrl)),
                          //         fileUrl == null && fileEdit == ""
                          //             ? Icon(
                          //                 Icons.upload_file,
                          //                 size: 35.0,
                          //                 color: Colors.red,
                          //               )
                          //             : Icon(
                          //                 Icons.upload_file,
                          //                 size: 35.0,
                          //                 color: Colors.green,
                          //               )
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          // CheckboxListTile(
                          //   title: const Text('free'),
                          //   value: checkActive,
                          //   onChanged: (newvalue) => setState(() => {
                          //         checkActive = newvalue!,
                          //         // if (value == true)
                          //         //   {
                          //         //     visible_enable = true,
                          //         //     visible_text_price = false
                          //         //   }
                          //         // else
                          //         //   {
                          //         //     visible_enable = false,
                          //         //     visible_text_price = true
                          //         //   }
                          //       }),
                          // ),

                          Container(
                            height: MediaQuery.of(context).size.width / 2.7,
                            margin: const EdgeInsets.all(15.0),
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            decoration: BoxDecoration(
                              color: pcGrey,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: txtrealty_summary,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  hintText: 'ملخص عن العقار',
                                  border: InputBorder.none),
                            ),
                          ),

                          isloading
                              ? circularProgress()
                              : MaterialButton(
                                  onPressed: () {
                                    updateRealty(context, load);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Text(
                                      "حفظ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30.0),
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
