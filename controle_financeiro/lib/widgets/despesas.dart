import 'dart:math';

import 'package:controle_financeiro/models/expense.dart';
import 'package:controle_financeiro/widgets/chart/chart.dart';
import 'package:controle_financeiro/widgets/expenses_list/expenses_list.dart';
import 'package:controle_financeiro/widgets/expenses_list/new_expense.dart';
import 'package:flutter/material.dart';

class Despesas extends StatefulWidget {
  const Despesas({super.key});

  @override
  State<Despesas> createState() => _DespesasState();
}

class _DespesasState extends State<Despesas> {
  final List<Expense> _registredExpenses = [
    Expense(
      title: 'Viagem',
      amount: 80.20,
      date: DateTime.now(),
      category: Category.viagem,
    ),
    Expense(
      title: 'Almoço',
      amount: 49.90,
      date: DateTime.now(),
      category: Category.comida,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: __addExpense),
    );
  }

  void __addExpense(Expense expense) {
    setState(() {
      _registredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registredExpenses.indexOf(expense);
    setState(() {
      _registredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: const Text('Despesa deletada'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _registredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('Despesas não encontradas. Comece a adiconar!'),
    );

    if (_registredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Painel de despesas [Flutter]'),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registredExpenses),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registredExpenses)),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
