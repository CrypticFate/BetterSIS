import 'package:bettersis/modules/bettersis_appbar.dart';
import 'package:bettersis/screens/Student/Meal-Token/display_tokens.dart';
import 'package:bettersis/screens/Misc/appdrawer.dart';
import 'package:bettersis/screens/Student/Smart%20Wallet/smart_wallet.dart';
import 'package:bettersis/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyToken extends StatefulWidget {
  final String userId;
  final String userDept;
  final String userName;
  final VoidCallback onLogout;

  const BuyToken({
    super.key,
    required this.userId,
    required this.userDept,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<BuyToken> createState() => _BuyTokenState();
}

class _BuyTokenState extends State<BuyToken> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCafeteria = "Central Cafeteria";
  String _selectedMealType = "Lunch";
  String _selectedPaymentMethod = "bKash";
  String? _selectedTokens;
  int _totalCost = 0;
  int _pricePerToken = 70;
  String? _selectedDate;
  final List<String> _tokenOptions = ['1', '2', '3', '4', '5', '6'];
  final List<DateTime> _availableDates = [];
  final TextEditingController _priceController = TextEditingController();
  smartWalletPage walletP = smartWalletPage();

  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
    _priceController.text = '৳$_pricePerToken';
  }

  void _generateAvailableDates() {
    DateTime today = DateTime.now();
    for (int i = 1; i <= 3; i++) {
      DateTime futureDate = today.add(Duration(days: i));
      _availableDates.add(futureDate);
    }
  }

  void _updateTotalCost() {
    if (_selectedTokens != null) {
      setState(() {
        _totalCost = int.parse(_selectedTokens!) * _pricePerToken;
      });
    }
  }

  void _updatePrice() {
    setState(() {
      _priceController.text = '৳$_pricePerToken';
    });
    _updateTotalCost();
  }

  Future<void> buyTokenWithWallet(String userID, double tokenCost) async {
    double currentBalance = await walletP.getBalance(userID);

    if (currentBalance < tokenCost) {
      // Insufficient funds, show a pop-up dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Insufficient Funds"),
            content: const Text("You do not have enough balance in your Smart Wallet."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Sufficient funds, proceed with the transaction and show confirmation dialog
      bool confirmation = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Purchase"),
            content: Text("You are about to purchase $_selectedTokens token(s) for a total of $_totalCost Taka. Do you want to continue?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel purchase
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm purchase
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );

      if (confirmation) {
        // Deduct the token cost from the current balance
        double newBalance = currentBalance - tokenCost;

        // Update the balance in Firestore
        await walletP.updateBalance(userID, newBalance);

        // Log the transaction in Firestore
        await walletP.addTransaction(userID, 'North Cafeteria - ' + _selectedMealType, tokenCost, 'meal');

        // Show success dialog before navigation
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Purchase Successful"),
              content: const Text("Your token purchase was successful."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigate to DisplayTokens after confirmation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayTokens(
                          userId: widget.userId,
                          userDept: widget.userDept,
                          onLogout: widget.onLogout,
                          userName: widget.userName,
                          cafeteria: _selectedCafeteria,
                          date: _selectedDate,
                          meal: _selectedMealType,
                          tokens: _selectedTokens,
                        ),
                      ),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double paddingValue = screenWidth * 0.05;
    final double fontSize = screenWidth * 0.045;
    final double buttonHeight = screenHeight * 0.07;
    final double iconSize = screenWidth * 0.065;

    ThemeData theme = AppTheme.getTheme(widget.userDept);

    return Scaffold(
      drawer: CustomAppDrawer(theme: theme),
      appBar: BetterSISAppBar(
          onLogout: widget.onLogout, theme: theme, title: 'Buy Meal Token'),
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Cafeteria',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                ),
                value: _selectedCafeteria,
                items: ['Central Cafeteria']
                    .map((cafeteria) => DropdownMenuItem<String>(
                  value: cafeteria,
                  child: Text(
                    cafeteria,
                    style: TextStyle(fontSize: fontSize),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCafeteria = value!;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Meal Type',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                ),
                value: _selectedMealType,
                items: ['Breakfast', 'Lunch']
                    .map((mealType) => DropdownMenuItem<String>(
                  value: mealType,
                  child: Text(
                    mealType,
                    style: TextStyle(fontSize: fontSize),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMealType = value!;
                    if (_selectedMealType == 'Breakfast') {
                      _pricePerToken = 40;
                    } else {
                      _pricePerToken = 70;
                    }
                    _updateTotalCost();
                    _updatePrice();
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(fontSize: fontSize),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: false, // Disable the price field
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tokens',
                        labelStyle: TextStyle(fontSize: fontSize),
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedTokens,
                      items: _tokenOptions
                          .map((token) => DropdownMenuItem<String>(
                        value: token,
                        child: Text(token,
                            style: TextStyle(fontSize: fontSize)),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTokens = value;
                          _updateTotalCost();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a number of tokens';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                ),
                value: _selectedDate,
                items: _availableDates
                    .map((date) => DropdownMenuItem<String>(
                  value: DateFormat('dd-MM-yyyy HH:mm:ss').format(date),
                  child: Text(
                    DateFormat('dd-MM-yyyy').format(date),
                    style: TextStyle(fontSize: fontSize),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Total Cost: $_totalCost Taka',
                style:
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Pay With',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                ),
                value: _selectedPaymentMethod,
                items: [
                  DropdownMenuItem(
                    value: 'bKash',
                    child: Row(
                      children: [
                        Image.asset('assets/bKash.png',
                            width: iconSize, height: iconSize),
                        SizedBox(width: screenWidth * 0.03),
                        Text('bKash', style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Smart Card',
                    child: Row(
                      children: [
                        Icon(Icons.credit_card, size: iconSize),
                        SizedBox(width: screenWidth * 0.03),
                        Text('Smart Card',
                            style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  minimumSize: Size(double.infinity, buttonHeight),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedPaymentMethod == 'Smart Card') {
                      buyTokenWithWallet(widget.userId, _totalCost.toDouble());
                    } else {
                      // Handle bKash or other payments
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayTokens(
                            userId: widget.userId,
                            userDept: widget.userDept,
                            onLogout: widget.onLogout,
                            userName: widget.userName,
                            cafeteria: _selectedCafeteria,
                            date: _selectedDate,
                            meal: _selectedMealType,
                            tokens: _selectedTokens,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize * 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
