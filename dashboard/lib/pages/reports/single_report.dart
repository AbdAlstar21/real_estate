import 'package:dashboard/pages/reports/report_data.dart';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:dashboard/pages/reports/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../function.dart';

class SingleReport extends StatefulWidget {
  int rep_index;
  ReportData reports;
  SingleReport({
    required this.rep_index,
    required this.reports,
  });
  @override
  _SingleReportState createState() => _SingleReportState();
}

class _SingleReportState extends State<SingleReport> {
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
        reportList!.removeAt(widget.rep_index);
        deleteData("rep_id", widget.reports.rep_id, "reports/delete_rep.php");
        Navigator.of(context).pop();
        load.add_loading();
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

  bool isloading = false;

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var providerreport = Provider.of<LoadingControl>(context);
    return Consumer<LoadingControl>(builder: (context, load, child) {
      return MaterialButton(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        onPressed: () {},
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.report,
                  size: 55,
                  color: Color.fromARGB(255, 235, 12, 12),
                ),
                title: Text(
                  widget.reports.rep_not,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  children: [
                    Text(widget.reports.rep_title),
                    Text(widget.reports.rep_date),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    showAlertDialog(context, providerreport);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 253, 222, 222),
                      size: 24,
                    ),
                    decoration: BoxDecoration(
                        color: pcPink,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
