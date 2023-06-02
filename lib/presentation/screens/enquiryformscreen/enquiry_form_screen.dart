

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/api/app_api.dart';

import '../../../utils/systemuioverlay/full_screen.dart';

class EnquiyformScreen extends StatefulWidget {
  const EnquiyformScreen({Key? key}) : super(key: key);

  @override
  State<EnquiyformScreen> createState() => _EnquiyformScreenState();
}

class _EnquiyformScreenState extends State<EnquiyformScreen> {

  //TextEditingController _nameController = TextEditingController();
  TextEditingController _subjectController = TextEditingController(text: '');
  TextEditingController _descriptionController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.amber);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          iconSize: 25.0,
        ),
        title: Text('Enquiry Form'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    /*Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        expands: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          label: Text('Your Name'),
                          labelStyle: TextStyle(color: Colors.green, fontSize: 20.0, fontWeight: FontWeight.w400),
                          //hintText: 'Enter Your Name',
                          //hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w700),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 1.0)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 1.0)),
                          fillColor: Colors.black12,
                          focusColor: Colors.white,
                        ),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _subjectController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        expands: false,
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          label: Text('Subject'),
                          labelStyle: TextStyle(color: Colors.green, fontSize: 20.0, fontWeight: FontWeight.w400),
                          //hintText: 'Enter Your Name',
                          //hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w700),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1.0),
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black,width: 1.0),
                              borderRadius: BorderRadius.circular(8.0)
                          ),

                          fillColor: Colors.black12,
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 8,
                        onTapOutside: (event) {
                          FocusScopeNode currentFocus =
                          FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }

                        },
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          label: Text('Description', textAlign: TextAlign.center,),
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.green, fontSize: 20.0, fontWeight: FontWeight.w400),
                          //hintText: 'Enter Your Name',
                          //hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.w700),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey,width: 1.0),
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black,width: 1.0),
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          fillColor: Colors.black12,
                          focusColor: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            if(_descriptionController.text != '' && _subjectController.text != ''){
                              EasyLoading.show();
                              Response? response = await API.customerSupport(subject: _subjectController.text, message: _descriptionController.text);
                              EasyLoading.dismiss();
                              if(response == null){
                                EasyLoading.showToast('Unable to communicate to server!');

                              }else if (response.data['status'] == 'true'){
                                EasyLoading.showToast('Response recorded successfully!');
                              }else if (response.data['status'] == 'false'){
                                EasyLoading.showToast('Unauthorised Access!');
                              }else{
                                EasyLoading.showToast(response.toString());
                              }
                            }else{
                              EasyLoading.showToast('Subject/Description can\'t be empty!');
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          textColor: Colors.white,
                          child: Text('Submit'),
                          color: Colors.amber,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if(EasyLoading.isShow){
      EasyLoading.dismiss();
    }
    super.dispose();
  }
}
