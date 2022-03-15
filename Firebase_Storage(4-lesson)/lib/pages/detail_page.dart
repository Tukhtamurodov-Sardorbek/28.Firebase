import 'dart:io';

import 'package:firebasestorage/models/post_model.dart';
import 'package:firebasestorage/services/hive_DB.dart';
import 'package:firebasestorage/services/realtime_service.dart';
import 'package:firebasestorage/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  static const String id = '/detail_page';
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late FocusNode titleFocusNode = FocusNode();
  late FocusNode contentFocusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleFocusNode.dispose();
    contentFocusNode.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  _uploadImage() async {
    String title = _titleController.text.toString().trim();
    String content = _contentController.text.toString().trim();
    var id = await HiveDB.getUser();  // To get the user's ID

    if (title.isEmpty || content.isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    if (_image != null) {
      StoreService.uploadImage(_image).then((imageURL) =>
      {
        _uploadPost(id, title, content, imageURL)
      });
    } else{
      _uploadPost(id, title, content, null);
    }

  }

  _uploadPost(String id, String title, String content, String? imageURL) async{
    await RealtimeDB.POST(
        Post(userId: id, title: title, content: content, imageURL: imageURL ?? 'no image',
            date: DateTime.now().toString().split(' ')[0]
        )).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context, true);
        });
  }


  _getImage() async{
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(image != null){
        _image = File(image.path);
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // #add image
                  Container(
                    height: 350,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: GestureDetector(
                      child:  _image != null
                          ?  Image.file(_image!, fit: BoxFit.cover)
                          : const Image(
                        image:AssetImage('assets/icon/add_image.png'),
                        color: Colors.red,
                      ),
                      onTap: _getImage,
                    ),
                  ),

                  // #title
                  TextField(
                      controller: _titleController,
                      focusNode: titleFocusNode,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: 'Title',
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
                  const SizedBox(height: 20),
                  // #save button
                  MaterialButton(
                    color: CupertinoColors.systemRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    height: 45,
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                    onPressed: _uploadImage,
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
          isLoading
              ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(color: CupertinoColors.systemRed),
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
