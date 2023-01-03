import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function transactionHandler;
  NewTransaction(this.transactionHandler, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    String enteredTitle = titleController.text;
    double enteredAmount = double.parse(amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.transactionHandler(titleController.text,
        double.parse(amountController.text), _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 6)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter Title'),
              controller: titleController,
              onSubmitted: (value) => _submitData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter Amount'),
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (value) => _submitData(),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date chosen'
                        : 'Selected Date: ${DateFormat.yMd().format(_selectedDate!)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Choose Date'),
                )
              ],
            ),
            ElevatedButton(
                onPressed: _submitData,
                child: const Text(
                  'Enter Transaction',
                ))
          ]),
        ),
      ),
    );
  }
}
