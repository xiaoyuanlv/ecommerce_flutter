import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/screens/product_page.dart';
import 'package:ecommerce_flutter/services/firebase_services.dart';
import 'package:ecommerce_flutter/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.userRef
                .doc(_firebaseServices.getUserId())
                .collection("Cart").get(),
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              // Text("Name : ${document.data()['name']}"),
              if(snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: EdgeInsets.only(
                      top: 108.0,
                      bottom: 24.0
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProductPage(
                              productId: document.id,
                            )
                        )
                        );
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productRef.doc(document.id).get(),
                        builder: (context, productSnap) {

                          if(productSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }

                          if(productSnap.connectionState == ConnectionState.done ) {
                            Map _productMap = productSnap.data.data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9.0),
                                      child: Image.network(
                                        "${_productMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productMap['name']}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0
                                          ),
                                          child: Text(
                                            "\$${_productMap['price']}",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Theme.of(context).accentColor,
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Size  - ${document.data()['size']}",
                                          style: TextStyle(
                                            fontSize: 16.0
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }

                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                  child: CircularProgressIndicator()
                              ),
                            ),
                          );

                        },
                      ),
                    );
                  }).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                    child: CircularProgressIndicator()
                ),
              );
            },
          ),

          CustomActionBar(
            hasBackArrow: true,
            hasTitle: true,
            title: "Cart",
          )
        ],
      ),
    );
  }
}
