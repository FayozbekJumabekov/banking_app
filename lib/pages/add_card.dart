import 'package:banking_app/models/card_model.dart';
import 'package:banking_app/services/log_service.dart';
import 'package:banking_app/utils/textfield_cover_widget.dart';
import 'package:banking_app/utils/widgets_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
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
  final _formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  void saveCard() {
    String cardNumber = cardNumberController.text.trim().toString();
    String firstName = firstNameController.text.trim().toString();
    String lastName = lastNameController.text.trim().toString();
    String data = dataController.text.trim().toString();
    String cvv = cvvController.text.trim().toString();
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      WidgetsCatalog.showSnackBar(context, 'Fields must be filled correctly');
      return;
    } else {
      addCard(cardNumber, firstName, lastName, data, cvv);
    }
  }

  void addCard(String cardNumber, String firstName, String lastName,
      String data, String cvv) {
    CardModel cardModel = CardModel(
        name: firstName + ' ' + lastName,
        cardNumber: cardNumber,
        data: data,
        cvv: cvv);
    Network.POST(Network.API_CREATE, Network.paramsCreate(cardModel))
        .then((value) {
      getResponse(value);
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
  }

  void getResponse(String? response) {
    if (response != null) {
      Log.i(response);
      Navigator.pop(context, true);
    } else {
      Log.w('Card not saved');
    }
  }

  String? checkValid({
    required String value,
    required int length,
    required String name,
  }) {
    if (value.isEmpty) {
      return "Field must be filled";
    } else if (value.length != length) {
      return 'Enter $length digits';
    } else if (!RegExp("^[0-9]").hasMatch(value)) {
      return "Enter only digits ";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreditCardWidget(
                height: MediaQuery.of(context).size.height * 0.22,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName:
                    firstNameController.text + ' ' + lastNameController.text,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: false,
                isHolderNameVisible: true,
                cardBgColor: Colors.indigo.shade900,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              ),
              const SizedBox(
                height: 10,
              ),

              /// Card Number
              TextFieldDecoration(
                child: TextFormField(
                  maxLength: 16,
                  controller: cardNumberController,
                  cursorColor: Colors.grey,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    setState(() {
                      if (RegExp("^[0-9]").hasMatch(text)) {
                        cardNumber = text;
                      } else {
                        _submit();
                      }
                    });
                  },
                  onFieldSubmitted: (value) {
                    _submit();
                  },
                  validator: (value) => checkValid(
                      value: value!, name: 'Card number', length: 16),
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    contentPadding: EdgeInsets.only(left: 5),
                    hintText: "Credit Card Number",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              /// data and CVV
              Row(
                children: [
                  Expanded(
                    child: TextFieldDecoration(
                      child: TextFormField(
                        maxLength: 4,
                        controller: dataController,
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            if (RegExp("^[0-9]").hasMatch(text)) {
                              expiryDate = text;
                            } else {
                              _submit();
                            }
                          });
                        },
                        onFieldSubmitted: (value) {
                          _submit();
                        },
                        validator: (value) =>
                            checkValid(value: value!, name: 'Data', length: 4),
                        decoration: const InputDecoration(
                          labelText: 'Data',
                          contentPadding: EdgeInsets.only(left: 5),
                          hintText: "Data",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: TextFieldDecoration(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: cvvController,
                        maxLength: 4,
                        cursorColor: Colors.grey,
                        onChanged: (text) {
                          setState(() {
                            if (RegExp("^[0-9]").hasMatch(text)) {
                              cvvCode = text;
                            } else {
                              _submit();
                            }
                          });
                        },
                        onFieldSubmitted: (value) {
                          _submit();
                        },
                        validator: (value) =>
                            checkValid(value: value!, name: 'CVV2', length: 4),
                        decoration: const InputDecoration(
                          labelText: 'CVV2',
                          contentPadding: EdgeInsets.only(left: 5),
                          hintText: "CVV2",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
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
              TextFieldDecoration(
                child: TextFormField(
                  controller: firstNameController,
                  cursorColor: Colors.grey,
                  onFieldSubmitted: (value) {
                    _submit();
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Field must be filled' : null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5),
                    hintText: "First Name",
                    labelText: 'First name',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              TextFieldDecoration(
                child: TextFormField(
                  controller: lastNameController,
                  cursorColor: Colors.grey,
                  onFieldSubmitted: (value) {
                    _submit();
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Field must be filled' : null,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
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
      ),
    );
  }

// void onCreditCardModelChange(CreditCardModel? creditCardModel) {
//   setState(() {
//     cardNumber = creditCardModel!.cardNumber;
//     expiryDate = creditCardModel.expiryDate;
//     cardHolderName = firstNameController.text + ' ' + lastNameController.text;
//     cvvCode = creditCardModel.cvvCode;
//     isCvvFocused = creditCardModel.isCvvFocused;
//   });
// }
}
