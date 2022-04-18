import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import './my_textfield.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx) {
    print('Constructor NewTransaction Widget');
  }

  @override
  _NewTransactionState createState() {
    print('createState NewTransaction Widget');

    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    print('Constructor NewTransaction State');
  }
  @override
  void initState() {
    print('initState() (pourrais servir pour http request)');

    super.initState();
  }

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        minimumDate: DateTime(2021),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _selectedDate = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  // void _presentDatePicker() {

  //   showDatePicker(
  //       context: context,
  //       //locale: ,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2021),
  //       lastDate: DateTime.now(),
  //       locale: Locale('fr', 'FR'),
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(data: ThemeData.dark(), child: child);
  //       }).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     setState(() {
  //       _selectedDate = pickedDate;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 41, 45, 62),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),

        //color: Colors.transparent,

        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyTextField(
                titleController,
                (_) => submitData(),
                'Titre',
                false,
              ),
              SizedBox(height: 15),
              MyTextField(
                amountController,
                (_) => submitData(),
                'Montant',
                true,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Pas de date choisi !'
                            : 'Date :  ${DateFormat.yMMMd().format(_selectedDate)}',
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Choisir une date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[400]),
                      ),
                      onPressed: () => _showDatePicker(context),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Ajouter'),
                color: Colors.indigo,
                onPressed: submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
