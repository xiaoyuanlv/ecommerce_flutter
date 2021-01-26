import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/services/firebase_services.dart';
import 'package:ecommerce_flutter/widgets/custom_action_bar.dart';
import 'package:ecommerce_flutter/widgets/image_swipe.dart';
import 'package:ecommerce_flutter/widgets/product_size.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  FirebaseServices _firebaseServices = FirebaseServices();

  final snackBar = SnackBar(content: Text('Product added to Cart!'));
  final snackBarSaved = SnackBar(content: Text('Product saved!'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
                future: _firebaseServices.productRef.doc(widget.productId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text("Error: ${snapshot.error}"),
                      ),
                    );
                  }

                  if(snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> documentData = snapshot.data.data();

                    List imageList = documentData['images'];
                    List productSizes = documentData['size'];
                    String selectedSize = productSizes[0];

                    return ListView(
                      padding: EdgeInsets.all(0),
                      children: [
                        ImageSwipe(imageList: imageList),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24.0,
                              left: 24.0,
                              right: 24.0,
                              bottom: 4.0
                          ),
                          child: Text("${documentData['name']}", style: Constants.boldHeading),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 24.0
                          ),
                          child: Text("\$${documentData['price']}",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 24.0
                          ),
                          child: Text(
                            "${documentData['desc']}",
                            style: TextStyle(
                                fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24.0,
                              horizontal: 24.0
                          ),
                          child: Text(
                            "Select Size",
                            style: Constants.regularDarkText,
                          ),
                        ),
                        ProductSize(productSizes: productSizes, onSelected: (size) {
                          selectedSize = size;
                        }),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _firebaseServices.userRef
                                      .doc(_firebaseServices.getUserId())
                                      .collection("Saved").doc(widget.productId).set({
                                  "size" : selectedSize
                                  });
                                  Scaffold.of(context).showSnackBar(snackBarSaved);
                               },
                                child: Container(
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/tab_saved.png",
                                    ),
                                    height: 22.0,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFDCDCDC),
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  alignment: Alignment.center,
                                  width: 60.0,
                                  height: 60.0,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _firebaseServices.userRef
                                        .doc(_firebaseServices.getUserId())
                                        .collection("Cart").doc(widget.productId).set({
                                          "size" : selectedSize
                                        });
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  },
                                  child: Container(
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(12.0)
                                    ),
                                    alignment: Alignment.center,
                                    height: 65.0,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        left: 16.0
                                    ),
                                  ),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,

                          ),
                        )
                      ],
                    );
                  }

                  return Scaffold(
                    body: Center(
                        child: CircularProgressIndicator()
                    ),
                  );
                }
            ),
            CustomActionBar(
              hasBackArrow: true,
              hasTitle: false,
              hasBackground: false,
            )
          ],
        )
    );
  }
}