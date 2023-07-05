import 'package:admindukanv1/constant.dart';
import 'package:admindukanv1/screens/menu_page.dart';
import 'package:flutter/material.dart';

class PutProfileScreen extends StatefulWidget {
  const PutProfileScreen({Key? key}) : super(key: key);

  @override
  State<PutProfileScreen> createState() => _PutProfileScreenState();
}

class _PutProfileScreenState extends State<PutProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController groceryName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  Size get size => MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [],
              ),
            ),
          ),
        ));
  }
}
