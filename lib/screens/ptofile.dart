import 'dart:developer';
import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/controllers/UserProfileControllers.dart';
import 'package:admindukanv1/screens/NotAdmine.dart';
import 'package:admindukanv1/screens/authScreen.dart';
import 'package:admindukanv1/screens/menu_page.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Location location = Location();
  late bool isServicesEnibl = false;
  late PermissionStatus _permissionStatus;
  late LocationData locationData;
  bool uploding = false;

  late bool isgetlocation = false;
  @override
  void initState() {
    getLocationdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text('الملف الشخصي'),
              backgroundColor: login_bg,
              centerTitle: true,
              leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => MenuPage()));
                  }),
            ),
            body: GetBuilder<UserController>(
                init: UserController(),
                builder: (controll) {
                  if (controll.isLoading.value) {
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
                          await controll.getUser();
                        },
                        child: const Center(
                            child: Icon(
                          Icons.wifi_tethering_off,
                          color: Colors.black45,
                          size: 200,
                        )));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controll.getUser();
                    },
                    color: login_bg,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 350,
                          child: Stack(
                            children: [
                              ElasticIn(
                                duration: const Duration(milliseconds: 400 * 1),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16)),
                                  child: GestureDetector(
                                    onTap: () {
                                      //groceryImage
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  16.0)),
                                                ),
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.end,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(Icons
                                                          .camera_alt_outlined),
                                                      title:
                                                          const Text('كاميرا'),
                                                      onTap: () async {
                                                        final picker =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
                                                        if (picker == null) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          mess(
                                                              context,
                                                              'لم يتم اختيار الصورة',
                                                              Colors.red);
                                                        } else {
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                          await controll
                                                              .putImage(
                                                                  'groceryImage',
                                                                  picker.path
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  picker.path,
                                                                  context);
                                                        }
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.image),
                                                      title: const Text(
                                                          'الاستديو'),
                                                      onTap: () async {
                                                        final picker =
                                                            await ImagePicker()
                                                                .getImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        if (picker == null) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          mess(
                                                              context,
                                                              'لم يتم اختيار الصورة',
                                                              Colors.red);
                                                        } else {
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                          await controll
                                                              .putImage(
                                                                  'groceryImage',
                                                                  picker.path
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  picker.path,
                                                                  context);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: groceryImages(context,
                                        controll.user.value.userId.toString()),
                                  ),
                                ),
                              ),
                              ElasticIn(
                                duration: const Duration(milliseconds: 400 * 2),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 50, right: 30),
                                    child: _buildInfo(context,
                                        controll.user.value.userId.toString(),
                                        () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  16.0)),
                                                ),
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.end,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(Icons
                                                          .camera_alt_outlined),
                                                      title:
                                                          const Text('كاميرا'),
                                                      onTap: () async {
                                                        final picker =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
                                                        if (picker == null) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          mess(
                                                              context,
                                                              'لم يتم اختيار الصورة',
                                                              Colors.red);
                                                        } else {
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                          await controll
                                                              .putImage(
                                                                  'userImage',
                                                                  picker.path
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  picker.path,
                                                                  context);
                                                        }
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.image),
                                                      title: const Text(
                                                          'الاستديو'),
                                                      onTap: () async {
                                                        final picker =
                                                            await ImagePicker()
                                                                .getImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        if (picker == null) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          mess(
                                                              context,
                                                              'لم يتم اختيار الصورة',
                                                              Colors.red);
                                                        } else {
                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                          await controll
                                                              .putImage(
                                                                  'userImage',
                                                                  picker.path
                                                                      .split(
                                                                          '/')
                                                                      .last,
                                                                  picker.path,
                                                                  context);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
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
                            leading: const Icon(Icons.favorite_border,
                                color: Colors.redAccent),
                            title: const Text(
                              'من يتابع اسعاري',
                            ),
                            subtitle: Text(
                              controll.user.value.menuCount.toString(),
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String? data = '';
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تعديل الاسم'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          data = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "اضف الاسم"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (data!.isNotEmpty) {
                                              await controll.putUser(
                                                  'userName', data!);
                                              if (controll
                                                  .error.value.isEmpty) {
                                                Navigator.of(context).pop();
                                                await controll.getUser();
                                              } else {
                                                mess(
                                                    context,
                                                    controll.error.value,
                                                    Colors.red);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'موافق',
                                            style: TextStyle(color: login_bg),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'الغاء',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400 * 1),
                            child: _buildList(
                                const Icon(Icons.person_outline_sharp),
                                'الاسم',
                                controll.user.value.userName.toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String? data = '';
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تعديل اسم المحل'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          data = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "اضف اسم المحل"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (data!.isNotEmpty) {
                                              await controll.putUser(
                                                  'groceryName', data!);
                                              if (controll
                                                  .error.value.isEmpty) {
                                                Navigator.of(context).pop();
                                                await controll.getUser();
                                              } else {
                                                mess(
                                                    context,
                                                    controll.error.value,
                                                    Colors.red);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'موافق',
                                            style: TextStyle(color: login_bg),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'الغاء',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400 * 2),
                            child: _buildList(
                                const Icon(Icons.home_filled),
                                'اسم المحل',
                                controll.user.value.groceryName.toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String? data = '';
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تعديل رقم الهاتف'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          data = value;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: "اضف رقم الهاتف"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (data!.isNotEmpty) {
                                              await controll.putUser(
                                                  'phoneNumber', data!);
                                              if (controll
                                                  .error.value.isEmpty) {
                                                Navigator.of(context).pop();
                                                await controll.getUser();
                                              } else {
                                                mess(
                                                    context,
                                                    controll.error.value,
                                                    Colors.red);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'موافق',
                                            style: TextStyle(color: login_bg),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'الغاء',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400 * 4),
                            child: _buildList(
                                const Icon(Icons.phone),
                                'رقم الهاتف',
                                controll.user.value.phoneNumber.toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String? data = '';
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تعديل وصف الموقع '),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          data = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "اضف وصف الموقع"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (data!.isNotEmpty) {
                                              await controll.putUser(
                                                  'locationDescription', data!);
                                              if (controll
                                                  .error.value.isEmpty) {
                                                Navigator.of(context).pop();
                                                await controll.getUser();
                                              } else {
                                                mess(
                                                    context,
                                                    controll.error.value,
                                                    Colors.red);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'موافق',
                                            style: TextStyle(color: login_bg),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'الغاء',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400 * 3),
                            child: _buildList(
                                const Icon(Icons.location_on_outlined),
                                'وصف للموقع',
                                controll.user.value.locationDescription
                                    .toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String? data = '';
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تعديل وصف شخصي '),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          data = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "اضف وصف شخصي"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (data!.isNotEmpty) {
                                              await controll.putUser(
                                                  'userDescription', data!);
                                              if (controll
                                                  .error.value.isEmpty) {
                                                Navigator.of(context).pop();
                                                await controll.getUser();
                                              } else {
                                                mess(
                                                    context,
                                                    controll.error.value,
                                                    Colors.red);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'موافق',
                                            style: TextStyle(color: login_bg),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'الغاء',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400 * 4),
                            child: _buildList(
                                const Icon(Icons.comment_bank_outlined),
                                'وصف شخصي',
                                controll.user.value.userDescription.toString()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String? data = '';
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('تعديل وصف المحل '),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          data = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "اضف وصف المحل"),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            if (data!.isNotEmpty) {
                                              await controll.putUser(
                                                  'groceryDescription', data!);
                                              if (controll
                                                  .error.value.isEmpty) {
                                                Navigator.of(context).pop();
                                                await controll.getUser();
                                              } else {
                                                mess(
                                                    context,
                                                    controll.error.value,
                                                    Colors.red);
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'موافق',
                                            style: TextStyle(color: login_bg),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'الغاء',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 400 * 4),
                            child: _buildList(
                                const Icon(Icons.shopping_bag_outlined),
                                'وصف للمحل',
                                controll.user.value.groceryDescription
                                    .toString()),
                          ),
                        ),
                        ElasticIn(
                          duration: const Duration(milliseconds: 400 * 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('تعديل الموقع'),
                                        content: const Text(
                                            'سيتم استخدام موقعك الحالي لدحديد مكان دكانك في الخريطة'),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                if (!isgetlocation) {
                                                  log('getl');
                                                  getLocationdata();
                                                  mess(
                                                      context,
                                                      'الرجاء اعطاء صلاحية الوصول للموقع',
                                                      Colors.red);
                                                  Navigator.of(context).pop();
                                                } else {
                                                  await controll.putUser(
                                                      'location',
                                                      '${locationData.latitude},${locationData.longitude}');
                                                  if (controll
                                                      .error.value.isEmpty) {
                                                    Navigator.of(context).pop();

                                                    mess(context, 'تم',
                                                        login_bg);
                                                  } else {
                                                    mess(
                                                        context,
                                                        controll.error.value,
                                                        Colors.red);
                                                    Navigator.of(context).pop();
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'موافق',
                                                style:
                                                    TextStyle(color: login_bg),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'الغاء',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ))
                                        ],
                                      );
                                    });
                              },
                              color: login_bg,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(24),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.add_location_alt_sharp,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "تعديل الموقع",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })));
  }

  Container groceryImages(BuildContext context, String id) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .5,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [login_bg, Color(0xFF2b8764)],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: Offset(1, 5),
              color: Colors.black54,
            )
          ]),
      child: Image(
          fit: BoxFit.cover,
          image: NetworkImage(
            '$startUrl/users/$id/grocery_image',
          ),
          errorBuilder: (context, exception, stackTrack) => const Icon(
                Icons.home_filled,
                size: 150,
                color: Colors.white,
              )),
    );
  }

  Container _buildList(Icon icon, String tip, String data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        leading: icon,
        title: Text(
          tip,
        ),
        subtitle: Text(
          data,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  void getLocationdata() async {
    isServicesEnibl = await location.serviceEnabled();
    if (!isServicesEnibl) {
      isServicesEnibl = await location.requestService();
      if (isServicesEnibl) return;
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();
    setState(() {
      isgetlocation = true;
    });
  }

  Widget _buildInfo(BuildContext context, String id, ontop) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: ontop,
        child: Container(
          width: MediaQuery.of(context).size.width * .6,
          height: MediaQuery.of(context).size.height * .2,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [login_bg, Color(0xFF2b8763)],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  offset: Offset(1, 5),
                  color: Colors.black54,
                ),
              ]),
          child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                '$startUrl/users/$id/user_image',
              ),
              errorBuilder: (context, exception, stackTrack) => const Icon(
                    Icons.person_outline_sharp,
                    size: 90,
                    color: Colors.white,
                  )),
        ),
      ),
    );
  }
}
