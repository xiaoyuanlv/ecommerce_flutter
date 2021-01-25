import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/screens/product_page.dart';
import 'package:ecommerce_flutter/widgets/custom_action_bar.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productRef =
        FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _productRef.get(),
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        height: 350,
                        margin: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0
                        ),
                        child: Stack(
                          children: [
                            Container(
                              height: 350,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                "${document.data()['images'][0]}",
                                fit: BoxFit.cover,
                              ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${document.data()['name']}" ?? "Product Name",
                                        style: Constants.regularHeading
                                    ),
                                    Text(
                                        "\$${document.data()['price']}" ?? "price",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w600
                                        ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
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
            title: "Home",
            hasBackArrow: false,
          )
        ],
      )
    );
  }
}
