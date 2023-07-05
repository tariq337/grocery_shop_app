import 'package:admindukanv1/constant.dart';
import 'package:flutter/material.dart';

class CardProducts extends StatelessWidget {
  final id;
  final name, price;

  const CardProducts({Key? key, this.id, this.name, this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .1, vertical: 10),
          height: MediaQuery.of(context).size.height * .3,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width * .5,
                    decoration: const BoxDecoration(
                        //  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          '$passdataUrl/$id/product_image',
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width * .43,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 24,
                            offset: Offset(1, 5),
                            color: Colors.black12,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: SizedBox(),
                        ),
                        ListTile(
                          title: const Text(
                            'اسم المنتج',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                        ListTile(
                          title: const Text(
                            'السعر',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            price,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
