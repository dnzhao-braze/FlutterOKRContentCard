import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:braze_plugin/braze_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    return const BrazeFunctions();
  }
}

class BrazeFunctions extends StatefulWidget {
  const BrazeFunctions({Key? key}) : super(key: key);

  @override
  BrazeFunctionsState createState() => BrazeFunctionsState();
}

class BrazeFunctionsState extends State<BrazeFunctions> {
  late BrazePlugin _braze;

  @override
  void initState() {
    _braze = BrazePlugin(customConfigs: {replayCallbacksConfigKey: true});
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _customCard();
      _braze.requestContentCardsRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () async {
              _braze.logCustomEvent('sendMeCards');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _braze.logCustomEvent('removeCards');
              setState(() {
                listOfCards = ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: const <Widget>[
                    Center(
                        child: Text(
                      'We have no cards to display yet. =(\nTap Gift Icon For Test Cards!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                );
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              _braze.launchContentCards();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _braze.requestContentCardsRefresh();
            },
          ),
        ],
        title: const Text("Cards"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: _buildListView(),
    );
  }

  ListView listOfCards = ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.all(20.0),
    children: const <Widget>[
      Center(
          child: Text(
        'We have no cards to display yet. =(\nTap Gift Icon For Test Cards!',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    ],
  );

  Widget _buildListView() {
    return Builder(
      builder: (BuildContext context) {
        return listOfCards;
      },
    );
  }

  void _customCard() {
    _braze.setBrazeContentCardsCallback((List<BrazeContentCard> contentCards) {
      List<Widget> cards = [];
      cards.add(
        const Center(
            child: Text(
          "Tap = Click. Double Tap = Dismiss.",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      );
      cards.add(
        const SizedBox(
          height: 15.0,
        ),
      );
      for (var contentCard in contentCards) {
        //print(contentCard.toString());
        _braze.logContentCardImpression(contentCard);
        cards.add(
          Card(
              elevation: 10,
              color:
                  contentCard.pinned ? Colors.blueGrey[100] : Colors.grey[100],
              child: GestureDetector(
                onTap: () {
                  _braze.logContentCardClicked(contentCard);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Clicked " + contentCard.title),
                  ));
                  _braze.requestContentCardsRefresh();
                },
                onDoubleTap: () {
                  if (contentCard.dismissable) {
                    _braze.logContentCardDismissed(contentCard);
                    if (contentCards.length == 1) {
                      //check if last content card dismissed
                      setState(() {
                        listOfCards = ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(20.0),
                          children: const <Widget>[
                            Center(
                                child: Text(
                              'We have no cards to display yet. =(\nTap Gift Icon For Test Cards!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ],
                        );
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Dismissed " + contentCard.title),
                    ));
                    _braze.requestContentCardsRefresh();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Pinned card could not be dismissed, tap Delete icon to send removal event"),
                    ));
                  }
                },
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 5.0,
                    ),
                    Flexible(
                        child: contentCard.image.isEmpty
                            ? Image.asset('images/BRZEIPO.png',
                                height: 100, width: 100)
                            : Image.network(contentCard.image,
                                height: 100, width: 100)),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: contentCard.title + "\n",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: contentCard.description + "\n",
                            ),
                            TextSpan(
                                text: contentCard.linkText,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    await launchUrl(Uri.parse(contentCard.url));
                                  },
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      }
      setState(() {
        listOfCards = ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: cards,
        );
      });
    });
  }
}
