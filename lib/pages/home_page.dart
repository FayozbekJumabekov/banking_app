import 'package:banking_app/models/card_model.dart';
import 'package:banking_app/pages/add_card.dart';
import 'package:banking_app/services/http_service.dart';
import 'package:banking_app/services/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardModel> cards = [];
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  @override
  void initState() {
    super.initState();
    getCards();
  }

  void getCards() {
    Network.GET(Network.API_LIST, Network.paramsEmpty()).then((value) {
      setState(() {
        cards = Network.parseCards(value);
        Log.w(cards[0].cardNumber);
      });
    });
  }

  void deleteCard(String id,int index){
    Network.DEL(Network.API_DELETE + id, Network.paramsEmpty()).then((value){
      setState(() {
      });
      getCards();
    });
  }

  /// Receive Data from AddingNotePage
  void _openAddNotesPage() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCard()));
    if (result != null && result == true) {
      setState(() {
        getCards();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Good Morning,',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            Text(
              'Eugene',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/im_profile.jpeg'),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListView.builder(
              itemCount: cards.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return cardItems(context, cards[index], index);
              }),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 40,
                    color: Colors.grey,
                    onPressed: () {
                      _openAddNotesPage();
                    },
                    icon: Icon(Icons.add_box_outlined)),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Add new card',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                )
              ],
            ),
          ),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        fixedColor: Colors.black,
        selectedFontSize: 14,
        onTap: (index) {
          setState(() {});
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }

  Widget cardItems(BuildContext context,CardModel card,int index) {
    return Container(
      child: Dismissible(
        key: ValueKey(card),
        onDismissed: (direction) {
          setState(() {
            deleteCard(card.id!, index);
            cards.removeAt(index);
          });
        },

        child: CreditCardWidget(
          height: MediaQuery.of(context).size.height * 0.22,
          cardNumber: card.cardNumber,
          expiryDate: card.data,
          cardHolderName: card.name,
          cvvCode: card.cvv,
          showBackView: isCvvFocused,
          obscureCardNumber: true,
          obscureCardCvv: false,
          isHolderNameVisible: true,
          cardBgColor: Colors.indigo,
          isSwipeGestureEnabled: true,
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
        ),
      ),
    );
  }

  /// # Snackbar
  // void showSnackBar(BuildContext context,CardModel card, int index) {
  //   var deletedNote = cards[index];
  //   deleteCard(card.id!,index);
  //   SnackBar snackBar = SnackBar(
  //     content: Text('Deleted ${cards[index].cardNumber}'),
  //     action: SnackBarAction(
  //       label: "UNDO",
  //       onPressed: () {
  //         setState(() {
  //           cards.insert(index, deletedNote);
  //
  //           // storeNote();
  //           // _loadNoteList();
  //         });
  //       },
  //     ),
  //   );
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }
}
