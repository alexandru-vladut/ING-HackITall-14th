import 'package:flutter/material.dart';
import 'package:ing_mobile/configs/products.dart';


class ScanProductResultPage extends StatelessWidget {
  const ScanProductResultPage({super.key, required this.barcode});
  final String barcode;

  @override
  Widget build(BuildContext context) {

    final product = products[barcode];

    Color lightGreen = const Color.fromARGB(255, 99, 210, 102);
    Color darkGreen = const Color.fromARGB(255, 83, 161, 86);
    Color lightRed = const Color.fromARGB(255, 251, 87, 75);
    Color darkRed = const Color.fromARGB(255, 181, 43, 33);

    Color lightColor;
    Color darkColor;

    if (product!['redgreen'] == 'red') {
      lightColor = lightRed;
      darkColor = darkRed;
    } else {
      lightColor = lightGreen;
      darkColor = darkGreen;
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(
              product['imagePath'],
              height: 200,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  product['name'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Disposal Recommendations: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: product['Disposal Recommendations'],
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Total Carbon Impact: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: lightColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: product['CO2e'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const TextSpan(
                        text: 'kg CO2e',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Total Waster Waste: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: lightColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: product['Water Waste'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const TextSpan(
                        text: 'L H2O',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          color: lightColor,
          height: 250,
          padding: const EdgeInsets.only(left: 40, right: 40, top: 0, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                "Can be recycled:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  bottomBarElement('assets/images/paper.png', 'Paper', product['paper']),
                  bottomBarElement('assets/images/foil.png', 'Foil', product['foil']),
                  bottomBarElement('assets/images/plastic.png', 'Plastic', product['plastic']),
                  if (product['tobacco'] != null)
                    bottomBarElement('assets/images/tobacco.png', 'Tobacco', product['tobacco']),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (product['points'] != 1) ? "${product['points']} Points" : "1 Point",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: () {
                        // to do
                      },
                      child: Container(
                        color: darkColor,
                        width: 120,
                        height: 60,
                        alignment: Alignment.center,
                        child: const Text(
                          'Recylce Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}

Widget bottomBarElement(String imagePath, String text, dynamic value) {

  int intValue = (value * 1000).toInt();

  return Column(
    children: <Widget>[
      Image.asset(
        imagePath,
        height: 30,
        color: Colors.white,
      ),
      const SizedBox(height: 3),
      Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 3),
      Text(
        (intValue != 0) ? '${intValue}g' : 'x',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}