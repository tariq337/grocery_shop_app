import 'dart:async';
import 'dart:io';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:admindukanv1/screens/NotAdmine.dart';
import 'package:admindukanv1/screens/authScreen.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/controllers/productsControllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  final nametext;
  final pricetext;
  final id;
  const AddProducts({Key? key, this.nametext, this.pricetext, this.id})
      : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  bool isloding = false;
  late bool ifimamge = true;
  final ProductsControllers productsControllers =
      Get.put(ProductsControllers());

  File? imagFile;

  getImageRounded() async {
    final picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;

    imagFile = File(picker.path);
    setState(() {});
  }

  getImageCamera() async {
    final picker = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picker == null) return;
    imagFile = File(picker.path);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.nametext.isNotEmpty && widget.pricetext.isNotEmpty) {
      name.text = widget.nametext;
      price.text = widget.pricetext;
    }
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: login_bg,
          elevation: 0,
          title: const Text(
            "اضافة منتج",
            style: TextStyle(fontSize: 25),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: LoadingOverlay(
              color: Colors.black,
              opacity: .3,
              isLoading: productsControllers.isLoading.value,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: login_bg,
                          borderRadius: BorderRadius.circular(13),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.white54,
                                blurRadius: 10,
                                spreadRadius: 3,
                                offset: Offset(3, 4))
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(
                              (widget.nametext.isNotEmpty &&
                                      widget.pricetext.isNotEmpty)
                                  ? Icons.update_sharp
                                  : Icons.mode,
                              color: Colors.white),
                          title: Text(
                            (widget.nametext.isNotEmpty &&
                                    widget.pricetext.isNotEmpty)
                                ? 'تعديل منتج'
                                : 'اضافة منتج جديد',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل الاسم';
                            }
                            return null;
                          },
                          controller: name,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'اسم المنتج',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ادخل السعر';
                            }
                            return null;
                          },
                          controller: price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'السعر',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: getImageRounded,
                              icon: const Icon(Icons.image_rounded)),
                          IconButton(
                              onPressed: getImageCamera,
                              icon: const Icon(Icons.camera_alt))
                        ],
                      ),
                      const SizedBox(height: 2),
                      imagFile != null
                          ? Image.file(
                              imagFile!,
                              // fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * .7,
                              height: MediaQuery.of(context).size.width * .7,
                            )
                          : Container(),
                      RoundedLoadingButton(
                        controller: _btnController,
                        color: login_bg,
                        onPressed: () async {
                          if (!(productsControllers.isLoading.value)) {
                            if (_formKey.currentState!.validate()) {
                              if (imagFile != null) {
                                if (widget.id.isNotEmpty) {
                                  await productsControllers.putController(
                                      name.text,
                                      price.text,
                                      widget.id,
                                      imagFile!);
                                } else {
                                  await productsControllers.addController(
                                      name.text, price.text, imagFile!);
                                }

                                if (productsControllers.error.value.isEmpty &&
                                    !productsControllers.isLoading.value) {
                                  _btnController.success();

                                  mess(context, 'تم', Colors.green);

                                  _btnController.success();

                                  Navigator.of(context).pop();
                                } else if (productsControllers.error.value ==
                                    'token') {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AuthScreen()),
                                      (route) => false);
                                  mess(context, 'الرجاء اعادة تسجيل الدخول',
                                      Colors.red);
                                } else if (productsControllers.error.value ==
                                    'not admin') {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NotAdmine()),
                                      (route) => false);
                                  mess(context, 'ليس لديك صلاحية الوصول',
                                      Colors.red);
                                } else {
                                  _btnController.error();
                                  Timer(const Duration(seconds: 2), () {
                                    _btnController.stop();
                                  });
                                  mess(context, productsControllers.error.value,
                                      Colors.red);
                                }
                              } else {
                                _btnController.error();
                                Timer(const Duration(seconds: 2), () {
                                  _btnController.stop();
                                });
                                mess(context, 'لم يتم اختيار الصورة',
                                    Colors.red);
                              }
                            } else {
                              _btnController.error();
                              Timer(const Duration(seconds: 2), () {
                                _btnController.stop();
                              });
                            }
                          } else {
                            mess(context, 'جاري الحساب', Colors.red);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: login_bg),
                          child: const Center(
                            child: Text(
                              'اضافة',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
