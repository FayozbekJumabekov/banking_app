import 'package:banking_app/models/card_model.dart';
import 'package:banking_app/pages/add_card.dart';
import 'package:banking_app/services/http_service.dart';
import 'package:banking_app/utils/loading_anim.dart';
import 'package:banking_app/utils/widgets_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardModel> cards = [];
  bool isLoading = false;
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  @override
  void initState() {
    super.initState();
    getCards();
  }

  void getCards() {
    setState(() {
      isLoading = true;
    });
    Network.GET(Network.API_LIST, Network.paramsEmpty()).then((value) {
      setState(() {
        cards = Network.parseCards(value);
        isLoading = false;
      });
    });
  }

  void deleteCard(String id, int index) {
    setState(() {
      cards.removeAt(index);
    });
    Network.DEL(Network.API_DELETE + id, Network.paramsEmpty()).then((value) {
    });
  }

  /// Receive Data from AddingNotePage
  void _openAddCardPage() async {
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
            radius: 25,
            backgroundImage: AssetImage('assets/images/im_profile.jpeg'),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: (isLoading)
          ? const LoadingAnim()
          : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cards.isEmpty
                  ? Container(
                padding: EdgeInsets.symmetric(
                    vertical:
                    MediaQuery
                        .of(context)
                        .size
                        .height * 0.25),
                child: Text(
                  "No cards ...",
                  style: TextStyle(fontSize: 20),
                ),
              )
                  : const SizedBox.shrink(),
              ListView.builder(
                  itemCount: cards.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return cardItems(context, cards[index], index,);
                  }),
              addCardWidget(context),
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
        items: const <BottomNavigationBarItem>[
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

  Widget addCardWidget(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.25,
      width: MediaQuery
          .of(context)
          .size
          .width,
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
                _openAddCardPage();
              },
              icon: const Icon(Icons.add_box_outlined)),
          const SizedBox(
            height: 5,
          ),
          Text(
            'Add new card',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget cardItems(BuildContext context, CardModel card, int index) {
    return Dismissible(
      key: ValueKey(card),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final bool? res = await WidgetsCatalog.androidDialog(title: 'Delete Card',
              content: 'Are you sure delete this card?',
              onTapNo: () {
                Navigator.pop(context);
              },
              onTapYes: () {
                deleteCard(card.id!, index);
                Navigator.pop(context);
              },
              context: context);
          return res;
        }
        return null;
      },
      child: CreditCardWidget(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.22,
        cardNumber: card.cardNumber,
        expiryDate: card.data,
        cardHolderName: card.name,
        cvvCode: card.cvv,
        showBackView: isCvvFocused,
        obscureCardNumber: true,
        glassmorphismConfig: Glassmorphism(
          blurX: 0.0,
          blurY: 0.0,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.75),
              Colors.black.withOpacity(1),
            ],
          ),
        ),
        obscureCardCvv: false,
        isHolderNameVisible: true,
        cardBgColor: Colors.black,
        isSwipeGestureEnabled: true,
        onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
      ),
    );
  }

}
