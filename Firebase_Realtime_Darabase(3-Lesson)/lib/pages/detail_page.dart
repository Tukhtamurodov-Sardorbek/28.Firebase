import 'package:firebaserealtimedatabase/models/post_model.dart';
import 'package:firebaserealtimedatabase/services/hive_DB.dart';
import 'package:firebaserealtimedatabase/services/realtime_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  static const String id = '/detail_page';
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late FocusNode nameFocusNode = FocusNode();
  late FocusNode contentFocusNode = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameFocusNode.dispose();
    contentFocusNode.dispose();
    _fullNameController.dispose();
    _contentController.dispose();
    _dateController.dispose();
  }

  _save() async {
    String fullName = _fullNameController.text.toString().trim();
    String content = _contentController.text.toString().trim();
    var id = await HiveDB.getUser();  // To get the user's ID

    if (fullName.isEmpty || content.isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await RealtimeDB.POST(
        Post(userId: id, fullName: fullName, content: content,
            date: selectedDate.toString().split(' ')[0]
            )).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context, true);
    });
  }

  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
      ),

      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // #full name
                    TextField(
                        controller: _fullNameController,
                        focusNode: nameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: 'Full Name',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemRed,
                                  width: 3,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemRed,
                                  width: 3,
                                )
                            )
                        ),
                        onChanged: (_) => setState(() {})
                    ),
                    const SizedBox(height: 10),
                    // #content
                    TextField(
                        controller: _contentController,
                        focusNode: contentFocusNode,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          // filled: true,
                          // fillColor: Colors.grey[100],
                            hintText: 'Content',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemRed,
                                  width: 3,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemRed,
                                  width: 3,
                                )
                            )
                        ),
                        onChanged: (_) => setState(() {})
                    ),
                    const SizedBox(height: 10),
                    // #date
                    TextField(
                        onTap: () => _selectDate(context),
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: selectedDate.toString().split(' ')[0],
                            hintStyle: const TextStyle(color: CupertinoColors.systemRed),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemRed,
                                  width: 3,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: CupertinoColors.systemRed,
                                  width: 3,
                                )
                            )
                        ),
                    ),


                    const SizedBox(height: 20),
                    // #save button
                    MaterialButton(
                      color: CupertinoColors.systemRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      height: 45,
                      child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                      onPressed: _save,
                    )
                  ],
                ),
              ),
            ),
            isLoading
                ? const CircularProgressIndicator(color: CupertinoColors.systemRed, backgroundColor: Colors.white)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2032),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      helpText: 'Select date',
      cancelText: 'Cancel',
      confirmText: 'OK',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
              colorScheme: const ColorScheme.dark(
                surface: CupertinoColors.systemRed,
                onSurface: Colors.black,

                primary: CupertinoColors.systemRed,
                onPrimary: Colors.black,

              ),
              dialogBackgroundColor: Colors.white
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
