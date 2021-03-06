import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/screens/product_page.dart';
import 'package:ecommerce_flutter/services/firebase_services.dart';
import 'package:ecommerce_flutter/widgets/custom_action_bar.dart';
import 'package:ecommerce_flutter/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productRef.get(),
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
                    return ProductCard(
                      title: document.data()['name'],
                      price: "\$${document.data()['price']}",
                      imageUrl: document.data()['images'][0],
                      productId: document.id,
                      onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ProductPage(productId: document.id)
                            ));
                      },
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
