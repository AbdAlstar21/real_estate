import 'dart:math';

import 'package:dashboard/pages/categories/category_data.dart';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import '../realtys/realtys_cat.dart';
import '../function.dart';
import 'add_category.dart';
import 'edit.dart';

class SingleCategory extends StatefulWidget {
  int cat_index;
  CategoryData categories;
  SingleCategory({
    required this.cat_index,
    required this.categories,
  });

  @override
  State<SingleCategory> createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  showAlertDialog(BuildContext context, LoadingControl load) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء الأمر", style: TextStyle(color: pcPink)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("موافق", style: TextStyle(color: pcPink)),
      onPressed: () {
        categoryList!.removeAt(widget.cat_index);
        deleteData(
            "cat_id", widget.categories.cat_id, "categories/delete_cat.php");
        load.add_loading();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text("تأكيد الحذف", style: TextStyle(color: pcPink))),
      content: Text("هل متأكد أنك تريد حذف هذا العنصر"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var providerCategory = Provider.of<LoadingControl>(context);
    return MaterialButton(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RealtysCategory(
                    cat_id: widget.categories.cat_id,
                    cat_name: widget.categories.cat_name)));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showAlertDialog(context, providerCategory);
                              },
              child: Container(
                alignment: Alignment.topRight,
                child: const Icon(
                  Icons.cancel,
                  color: pcPink,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  child: widget.categories.cat_thumbnail == ""
                      ? ImageNetwork(
                          image: imageCategory + "category.png",
                          height: 90,
                          width: 75,
                          onLoading: const CircularProgressIndicator(
                            color: pcPinkLight,
                          ),
                          onError: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        )
                      : ImageNetwork(
                          image:
                              imageCategory + widget.categories.cat_thumbnail,
                          height: 90,
                          width: 75,
                          onLoading: CircularProgressIndicator(
                            color: pcPinkLight,
                          ),
                          onError: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      widget.categories.cat_name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 25),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.categories.cat_date),
                          // RaisedButton(
                          //   child: Text("اضافة المأكولات"),
                          //   onPressed: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => new Categories(
                          //                 cat_id: categories.cat_id,
                          //                 cat_name: categories.cat_name)));
                          //   },
                          // )
                        ]),
                    trailing: SizedBox(
                      width: 30.0,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditCategory(
                                          cat_index: widget.cat_index,
                                          mycategory: widget.categories)));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                              decoration: BoxDecoration(
                                  color: pcPink,
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Divider(
            //   color: Colors.grey[500],
            // )
          ],
        ),
      ),
    );
  }
}
