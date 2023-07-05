import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/controllers/productsControllers.dart';
import 'package:admindukanv1/screens/NotAdmine.dart';
import 'package:admindukanv1/screens/add.dart';
import 'package:admindukanv1/screens/authScreen.dart';
import 'package:admindukanv1/screens/menu_page.dart';
import 'package:admindukanv1/widget/CardProducts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Size get size => MediaQuery.of(context).size;
  late String price;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('منتجاتي'),
          backgroundColor: login_bg,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true, builder: (_) => MenuPage()));
              }),
        ),
        body: Center(
            child: GetBuilder<ProductsControllers>(
                init: ProductsControllers(),
                builder: (controll) {
                  if (controll.isListLoading.value) {
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: login_bg,
                    ));
                  } else if (controll.error.value.isNotEmpty) {
                    if (controll.error.value == 'token') {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AuthScreen()),
                          (route) => false);
                      mess(context, 'الرجاء اعادة تسجيل الدخول', Colors.red);
                    } else if (controll.error.value == 'not admin') {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const NotAdmine()),
                          (route) => false);
                      mess(context, 'ليس لديك صلاحية الوصول', Colors.red);
                    }
                    return GestureDetector(
                        onTap: () async {
                          await controll.getdataController();
                        },
                        child: const Center(
                            child: Icon(
                          Icons.wifi_tethering_off,
                          color: Colors.black45,
                          size: 200,
                        )));
                  } else if ((controll.productsList.value.details ?? [])
                      .isEmpty) {
                    return RefreshIndicator(
                        onRefresh: () async {
                          await controll.getdataController();
                        },
                        color: login_bg,
                        child: const Center(child: Text('لاتوجد عناصر')));
                  }
                  return LoadingOverlay(
                    color: Colors.black54,
                    opacity: .3,
                    isLoading: controll.isListLoading.value,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controll.getdataController();
                        },
                        color: login_bg,
                        child: ListView.builder(
                          itemCount: (controll.productsList.value.details ?? [])
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            return ElasticIn(
                              duration: Duration(milliseconds: 200 * index),
                              child: FocusedMenuHolder(
                                menuItems: [
                                  FocusedMenuItem(
                                    title: const Text('تعديل السعر'),
                                    trailingIcon:
                                        const Icon(Icons.price_change_sharp),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('تعديل السعر'),
                                              content: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    price = value;
                                                  });
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: "اضف السعر"),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      if (price.isNotEmpty) {
                                                        await controll
                                                            .putPriceController(
                                                                price
                                                                    .toString(),
                                                                controll
                                                                    .productsList
                                                                    .value
                                                                    .details![
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                        if (controll.errordelet
                                                            .value.isEmpty) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await controll
                                                              .getdataController();
                                                        } else {
                                                          mess(
                                                              context,
                                                              controll
                                                                  .errordelet
                                                                  .value,
                                                              Colors.red);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      }
                                                    },
                                                    child: const Text('موافق')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('لا'))
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                  FocusedMenuItem(
                                    title: const Text('تعديل الكل'),
                                    trailingIcon: const Icon(Icons.mode),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddProducts(
                                                    nametext: controll
                                                        .productsList
                                                        .value
                                                        .details![index]
                                                        .name
                                                        .toString(),
                                                    pricetext: controll
                                                        .productsList
                                                        .value
                                                        .details![index]
                                                        .price
                                                        .toString(),
                                                    id: controll
                                                        .productsList
                                                        .value
                                                        .details![index]
                                                        .id
                                                        .toString(),
                                                  ))).then((_) {
                                        controll.getdataController();
                                      });
                                    },
                                  ),
                                  FocusedMenuItem(
                                    title: const Text('حذف',
                                        style: TextStyle(color: Colors.white)),
                                    trailingIcon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.white),
                                    backgroundColor: Colors.red,
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'هل انت متاكد انك تريد الحذف'),
                                                actionsAlignment:
                                                    MainAxisAlignment.start,
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await controll
                                                            .DeleteController(
                                                                controll
                                                                    .productsList
                                                                    .value
                                                                    .details![
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                        if (controll.errordelet
                                                            .value.isEmpty) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await controll
                                                              .getdataController();
                                                        } else {
                                                          mess(
                                                              context,
                                                              controll
                                                                  .errordelet
                                                                  .value,
                                                              Colors.red);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child:
                                                          const Text('موافق')),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('لا'))
                                                ],
                                              ));
                                    },
                                  ),
                                ],
                                blurSize: 9,
                                blurBackgroundColor: Colors.white,
                                menuWidth: size.width,
                                menuItemExtent: 60,
                                animateMenuItems: true,
                                duration: const Duration(milliseconds: 600),
                                menuOffset: 6,
                                openWithTap: true,
                                onPressed: () {},
                                child: CardProducts(
                                    id: controll
                                        .productsList.value.details![index].id,
                                    name: controll
                                        .productsList.value.details![index].name
                                        .toString(),
                                    price: controll.productsList.value
                                        .details![index].price
                                        .toString()),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                })),
        floatingActionButton: GetBuilder<ProductsControllers>(
            init: ProductsControllers(),
            builder: (controll) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProducts(
                                nametext: '',
                                pricetext: '',
                                id: '',
                              ))).then((_) {
                    controll.getdataController();
                  });
                },
                child: const Icon(Icons.add),
                backgroundColor: login_bg,
              );
            }),
      ),
    );
  }
}

/*
  onTap: () {
              */