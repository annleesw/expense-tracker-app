import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker_app/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget{
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
    State<StatefulWidget> createState() {
      return _NewExpenseState();
    }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate; //rmb ?, tells dart that _selectedDate should be stored as type DateTime or null
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async { //async-await for functions with future data needed
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now,
      firstDate: firstDate, 
      lastDate: now
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text); // typeParse('Hello') => null, tryParse('1.2') => 1.20
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty || 
        amountIsInvalid || 
        _selectedDate == null) { //check if amount/ date is filled in
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please ensure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(ctx);
            }, child: const Text('Okay'),
          ),],
        )); 
      return;
    } 

    widget.onAddExpense(
      Expense(
        title: _titleController.text, 
        amount: enteredAmount, 
        date: _selectedDate!, 
        category: _selectedCategory
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() { //remove unnecessary memory stored by title controller
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  
  // var _enteredTitle = '';
  
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded( //for both amount and date picker to share the row space
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null 
                    ? 'No date selected' 
                    : formatter.format(_selectedDate!)), // ! after null value tells dart that the value will nvr be null
                    IconButton(
                      onPressed: _presentDatePicker, 
                      icon: const Icon(Icons.calendar_month
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                  .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.name.toUpperCase()
                    ),
                  ), 
                ).toList(),
                onChanged: (value) {
                  if (value == null){
                    return;
                  }
                  setState(() { //update category state when value changes
                    _selectedCategory = value;
                  });
                }
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text('Cancel'),
              ),
            ElevatedButton(
              onPressed: _submitExpenseData, 
              child: const Text('Save'),
            ),
          ],)
        ],
      ),
    );
  }
}