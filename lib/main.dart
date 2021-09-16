import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
      brightness: Brightness.dark,

      // colorScheme: ColorScheme.fromSwatch(
      //   primarySwatch: Colors.indigo,
      // ).copyWith(
      //   secondary: Colors.indigoAccent,
      // ),
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {

  var _formKey =  GlobalKey<FormState>();
  final _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final double _minimumPadding = 5.0;
  var _currentItemSelected = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  var displayResult = '';

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    controller: principalController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter Principal Amount';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Principal",
                      hintText: "Enter Principal e.g. 12000",
                      labelStyle: textStyle,
                      errorStyle:  TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    controller: roiController,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Please enter rate of interest';
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Rate of Interest",
                      hintText: "In Percent",
                      labelStyle: textStyle,
                      errorStyle:  TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 15.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          controller: termController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter time';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Term",
                            hintText: "Time in years",
                            labelStyle: textStyle,
                            errorStyle:  TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.indigo,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: _minimumPadding * 5,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor),
                          textStyle: MaterialStateProperty.all(TextStyle(
                              color: Theme.of(context).primaryColorDark)),
                          elevation:MaterialStateProperty.all(0.5),
                        ),
                        child: Text(
                          "Calculate",
                          textScaleFactor: 1.3,
                        ),
                        onPressed: () {
                          setState(() {
                            if(_formKey.currentState!.validate()){
                              displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColorDark),
                          textStyle: MaterialStateProperty.all(TextStyle(
                              color: Theme.of(context).primaryColorLight)),
                        ),
                        child: Text(
                          "Reset",
                          textScaleFactor: 1.3,
                        ),
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Text(
                    displayResult,
                    style: textStyle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(var newValueSelected) {
    setState(() {
      _currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';

    return result;
  }

  void _reset() {
    _formKey.currentState!.reset();
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
