import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  String BTCPrice = '?';
  String ETHPrice = '?';
  String LTCPrice = '?';

  Widget getPicker() {
    if (Platform.isAndroid) {
      return getAndroidDropDownItems();
    }
    return getIOSPicker();
  }

  DropdownButton<String> getAndroidDropDownItems() {
    List<DropdownMenuItem<String>> dropdownMenuItemsList = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      DropdownMenuItem<String> dropdownMenuItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownMenuItemsList.add(dropdownMenuItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropdownMenuItemsList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getNetworkData();
        });
        print(value);
      },
    );
  }

  CupertinoPicker getIOSPicker() {
    List<Text> pickerList = [];
    for (String currency in currenciesList) {
      Text pickerItem = Text(
        currency,
        style: const TextStyle(
          color: Colors.white,
        ),
      );
      pickerList.add(pickerItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        selectedCurrency = currenciesList[selectedIndex];
        getNetworkData();
      },
      children: pickerList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCryptoInfoWidget('BTC', BTCPrice),
              buildCryptoInfoWidget('ETH', ETHPrice),
              buildCryptoInfoWidget('LTC', LTCPrice),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isAndroid ? getAndroidDropDownItems() : getIOSPicker(),
          ),
        ],
      ),
    );
  }

  Padding buildCryptoInfoWidget(String cryptoCurrency, String price) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $price $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getNetworkData();
  }

  void getNetworkData() async {
    var response = await coinData.getCoinData(selectedCurrency);
    if (response != null) {
      setState(() {
        // double price = response['rate'];
        // if (response['asset_id_base'] == 'BTC') {
        //   BTCPrice = price.toStringAsFixed(2);
        // } else if (response['asset_id_base'] == 'ETH') {
        //   ETHPrice = price.toStringAsFixed(2);
        // } else {
        //   LTCPrice = price.toStringAsFixed(2);
        // }
        BTCPrice = response[0];
        ETHPrice = response[1];
        LTCPrice = response[2];
      });
    }
  }
}
