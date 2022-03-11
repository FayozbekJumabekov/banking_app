import 'package:banking_app/models/card_model.dart';
import 'package:banking_app/pages/add_card.dart';
import 'package:banking_app/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';

import '../services/http_service.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  saveCard() {
    String cardNumber = cardNumberController.text.trim().toString();
    String firstName = firstNameController.text.trim().toString();
    String lastName = lastNameController.text.trim().toString();
    String data = dataController.text.trim().toString();
    String cvv = cvvController.text.trim().toString();
    if (cardNumber.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        data.isEmpty ||
        cvv.isEmpty) return null;
    CardModel cardModel = CardModel(
        name: firstName + ' ' + lastName,
        cardNumber: cardNumber,
        data: data,
        cvv: cvv);
    Network.POST(Network.API_CREATE, Network.paramsCreate(cardModel)).then((value){
      getResponse(value);
    });
  }

  getResponse(String? response){
    if(response != null){
      Log.i(response);
      Navigator.pop(context,true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          saveCard();
        }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.blue.shade900,
        title: Text('Add your card'),
        actions: [
          TextButton(
              onPressed: () {
                saveCard();
              },
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardWidget(
              height: MediaQuery.of(context).size.height * 0.22,
              glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName:
                  firstNameController.text + ' ' + lastNameController.text,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: false,
              isHolderNameVisible: true,
              cardBgColor: Colors.indigo,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            SizedBox(
              height: 10,
            ),

            /// Card Number
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(171, 171, 171, 0.7),
                        blurRadius: 20,
                        offset: Offset(0, 10)),
                  ]),
              child: TextField(
                maxLength: 16,
                controller: cardNumberController,
                cursorColor: Colors.grey,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  setState(() {
                    cardNumber = text;
                  });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5),
                  hintText: "Credit Card Number",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            /// data and CVV
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(171, 171, 171, 0.7),
                              blurRadius: 20,
                              offset: Offset(0, 10)),
                        ]),
                    child: TextField(
                      maxLength: 4,
                      controller: dataController,
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        setState(() {
                          expiryDate = text;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 5),
                        hintText: "data",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(171, 171, 171, 0.7),
                              blurRadius: 20,
                              offset: Offset(0, 10)),
                        ]),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cvvController,
                      maxLength: 3,
                      cursorColor: Colors.grey,
                      onChanged: (text) {
                        setState(() {
                          cvvCode = text;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 5),
                        hintText: "CVV2",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            /// name
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(171, 171, 171, 0.7),
                        blurRadius: 20,
                        offset: Offset(0, 10)),
                  ]),
              child: TextField(
                controller: firstNameController,
                cursorColor: Colors.grey,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5),
                  hintText: "First Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(171, 171, 171, 0.7),
                        blurRadius: 20,
                        offset: Offset(0, 10)),
                  ]),
              child: TextField(
                controller: lastNameController,
                cursorColor: Colors.grey,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5),
                  hintText: "Last Name",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = firstNameController.text + ' ' + lastNameController.text;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
