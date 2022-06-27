import 'package:flutter/material.dart';
import 'package:braze_plugin/braze_plugin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  String _userId = "";
  late BrazePlugin _braze;
  final userIdController = TextEditingController();
  final customEventNameController = TextEditingController();
  final customEventPropertyKeyController = TextEditingController();
  final customEventPropertyValueController = TextEditingController();
  final emailController = TextEditingController();
  final customAttributeNameController = TextEditingController();
  final customAttributeValueController = TextEditingController();
  final purchaseNameController = TextEditingController();
  final purchaseCurrencyController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final purchaseQtyController = TextEditingController();
  final emailPropController = TextEditingController();

  @override
  void initState() {
    _braze = BrazePlugin(customConfigs: {replayCallbacksConfigKey: true});
    _customIAM();
    super.initState();
  }

  @override
  void dispose() {
    userIdController.dispose();
    customEventNameController.dispose();
    customEventPropertyKeyController.dispose();
    customEventPropertyValueController.dispose();
    emailController.dispose();
    customAttributeNameController.dispose();
    customAttributeValueController.dispose();
    purchaseNameController.dispose();
    purchaseCurrencyController.dispose();
    purchasePriceController.dispose();
    purchaseQtyController.dispose();
    emailPropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/cards');
            },
          )
        ],
        title: const Text("Home"),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            Center(
              child: ListTile(
                  tileColor: Colors.blueGrey[50],
                  leading: const Icon(Icons.account_circle),
                  title: Text(_userId)),
            ),
            TextField(
              autocorrect: false,
              controller: userIdController,
              decoration: const InputDecoration(
                  hintText: 'Please enter a user id', labelText: 'User Id'),
            ),
            TextButton(
              child: const Text('CHANGE USER'),
              onPressed: () {
                String userId = userIdController.text;
                _braze.changeUser(userId);
                setState(() {
                  _userId = userId;
                });
              },
            ),
            TextField(
              autocorrect: false,
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: 'Please enter email', labelText: 'Email'),
            ),
            TextButton(
              child: const Text('CHANGE EMAIL'),
              onPressed: () {
                String email = emailController.text;
                if (email.isEmpty) {
                  _braze.setEmail(null);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Email cleared.'),
                  ));
                } else {
                  _braze.setEmail(email);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Email $email."),
                  ));
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: customAttributeNameController,
                    decoration: const InputDecoration(
                        hintText: 'Attribute Name',
                        labelText: 'Attribute Name'),
                  ),
                ),
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: customAttributeValueController,
                    decoration: const InputDecoration(
                        hintText: 'Attribute Value',
                        labelText: 'Attribute Value'),
                  ),
                ),
              ],
            ),
            TextButton(
              child: const Text('LOG/CLEAR CUSTOM ATTRIBUTE'),
              onPressed: () {
                String customAttributeName = customAttributeNameController.text;
                String customAttributeValue =
                    customAttributeValueController.text;
                String lowerCaseValue = customAttributeValue.toLowerCase();
                if (customAttributeName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Custom Attribute Name is empty.'),
                  ));
                } else if (customAttributeValue.isEmpty) {
                  _braze.unsetCustomUserAttribute(customAttributeName);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Custom attribute $customAttributeName cleared.'),
                  ));
                } else {
                  if (int.tryParse(customAttributeValue) != null) {
                    _braze.setIntCustomUserAttribute(
                        customAttributeName, int.parse(customAttributeValue));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Custom attribute $customAttributeName with int value $customAttributeValue.'),
                    ));
                  } else if (double.tryParse(customAttributeValue) != null) {
                    _braze.setDoubleCustomUserAttribute(customAttributeName,
                        double.parse(customAttributeValue));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Custom attribute $customAttributeName with double value $customAttributeValue.'),
                    ));
                  } else if (lowerCaseValue == 'true' ||
                      lowerCaseValue == 'false') {
                    if (lowerCaseValue == 'true') {
                      _braze.setBoolCustomUserAttribute(
                          customAttributeName, true);
                    } else {
                      _braze.setBoolCustomUserAttribute(
                          customAttributeName, false);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Custom attribute $customAttributeName with boolean value $lowerCaseValue.'),
                    ));
                  } else if (DateTime.tryParse(customAttributeValue) != null) {
                    _braze.setDateCustomUserAttribute(customAttributeName,
                        DateTime.parse(customAttributeValue));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Custom attribute $customAttributeName with date value $customAttributeValue.'),
                    ));
                  } else {
                    _braze.setStringCustomUserAttribute(
                        customAttributeName, customAttributeValue);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Custom attribute $customAttributeName with string value $customAttributeValue.'),
                    ));
                  }
                }
              },
            ),
            TextField(
              autocorrect: false,
              controller: customEventNameController,
              decoration: const InputDecoration(
                  hintText: 'Please enter a custom event name',
                  labelText: 'Event Name'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: customEventPropertyKeyController,
                    decoration: const InputDecoration(
                        hintText: 'Property Key', labelText: 'Property Key'),
                  ),
                ),
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: customEventPropertyValueController,
                    decoration: const InputDecoration(
                        hintText: 'Property Value',
                        labelText: 'Property Value'),
                  ),
                ),
              ],
            ),
            TextButton(
              child: const Text('LOG CUSTOM EVENT'),
              onPressed: () {
                String customEvent = customEventNameController.text;
                String customPropertyKey =
                    customEventPropertyKeyController.text;
                String customPropertyValue =
                    customEventPropertyValueController.text;
                if (customEvent.isEmpty) {
                  customEvent = 'MyCustomEvent';
                }
                if (customPropertyKey.isEmpty) {
                  _braze.logCustomEvent(customEvent);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Custom event $customEvent."),
                  ));
                } else {
                  _braze.logCustomEvent(customEvent,
                      properties: {customPropertyKey: customPropertyValue});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Custom event $customEvent with properties {"$customPropertyKey":"$customPropertyValue"}.'),
                  ));
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: purchaseNameController,
                    decoration: const InputDecoration(
                        hintText: 'Item Purchased',
                        labelText: 'Item Purchased'),
                  ),
                ),
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: purchaseCurrencyController,
                    decoration: const InputDecoration(
                        hintText: 'e.g. USD, SGD', labelText: 'Currency'),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: purchasePriceController,
                    decoration: const InputDecoration(
                        hintText: 'double', labelText: 'Price'),
                  ),
                ),
                Flexible(
                  child: TextField(
                    autocorrect: false,
                    controller: purchaseQtyController,
                    decoration: const InputDecoration(
                        hintText: 'int', labelText: 'Quantity'),
                  ),
                ),
              ],
            ),
            TextButton(
                child: const Text('LOG PURCHASE'),
                onPressed: () {
                  String purchaseName = purchaseNameController.text;
                  String purchaseCurrency = purchaseCurrencyController.text;
                  double purchasePrice =
                      double.parse(purchasePriceController.text);
                  int purchaseQty = int.parse(purchaseQtyController.text);
                  _braze.logPurchase(purchaseName, purchaseCurrency,
                      purchasePrice, purchaseQty);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Purchased $purchaseQty $purchaseName at $purchaseCurrency $purchasePrice'),
                  ));
                }),
            TextField(
              autocorrect: false,
              controller: emailPropController,
              decoration: const InputDecoration(
                  hintText: 'Please enter message', labelText: 'Message'),
            ),
            TextButton(
              child: const Text('SEND MESSAGE'),
              onPressed: () {
                String emailProp = emailPropController.text;
                _braze.logCustomEvent('sendMessage',
                    properties: {'message': emailProp});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Message $emailProp sent.'),
                ));
              },
            ),
            TextButton(
              child: const Text('REFRESH CONTENT CARDS'),
              onPressed: () {
                _braze.requestContentCardsRefresh();
              },
            ),
            TextButton(
              child: const Text('LAUNCH CONTENT CARDS'),
              onPressed: () {
                _braze.launchContentCards();
              },
            ),
          ],
        );
      },
    );
  }

  void _customIAM() {
    _braze.setBrazeInAppMessageCallback((BrazeInAppMessage inAppMessage) {
      //print(inAppMessage.toString());
      String imageUrl =
          'https://cdn-staging.braze.com/appboy/communication/assets/image_assets/images/6201de5da7b6d17c2611e033/original.png';
      String button1 = 'Cancel';
      String button2 = 'OK';
      if (inAppMessage.imageUrl != "") {
        imageUrl = inAppMessage.imageUrl;
      }
      if (inAppMessage.extras.containsKey('external_id')) {
        setState(() {
          _userId = inAppMessage.extras['external_id'].toString();
        });
      }
      if (inAppMessage.buttons.length == 2) {
        button1 = inAppMessage.buttons.asMap()[0]!.text;
        button2 = inAppMessage.buttons.asMap()[1]!.text;
      } else if (inAppMessage.buttons.length == 1) {
        button1 = inAppMessage.buttons.asMap()[0]!.text;
      }
      _braze.logInAppMessageImpression(inAppMessage);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(inAppMessage.header),
              content: Wrap(
                children: [
                  Image.network(imageUrl),
                  Text(inAppMessage.message),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _braze.logInAppMessageClicked(inAppMessage);
                    if (inAppMessage.buttons.isNotEmpty) {
                      _braze.logInAppMessageButtonClicked(
                          inAppMessage, inAppMessage.buttons.asMap()[0]!.id);
                    }
                    Navigator.pop(context, button1);
                  },
                  child: Text(button1),
                ),
                TextButton(
                  onPressed: () {
                    _braze.logInAppMessageClicked(inAppMessage);
                    if (inAppMessage.buttons.length == 2) {
                      _braze.logInAppMessageButtonClicked(
                          inAppMessage, inAppMessage.buttons.asMap()[1]!.id);
                    }
                    Navigator.pop(context, button2);
                  },
                  child: Text(button2),
                ),
              ],
            );
          });
    });
  }
}
