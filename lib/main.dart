import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login & Income Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrangeAccent),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _validateUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedPassword =
        prefs.getString('${_emailController.text}_password');
    return _passwordController.text == storedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        color: Colors.grey[200], // Background color
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool isValid = await _validateUser();
                    if (isValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IncomeExpenseListScreen(
                            userEmail: _emailController.text,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Invalid email or password')),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _registerUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${_emailController.text}_password', _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        color: Colors.grey[200], // Background color
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _registerUser();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IncomeExpenseListScreen extends StatefulWidget {
  final String userEmail;

  const IncomeExpenseListScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _IncomeExpenseListScreenState createState() =>
      _IncomeExpenseListScreenState();
}

class _IncomeExpenseListScreenState extends State<IncomeExpenseListScreen> {
  List<Map<String, String>> _incomeExpenseList = [];

  @override
  void initState() {
    super.initState();
    _loadIncomeExpenseList();
  }

  Future<void> _loadIncomeExpenseList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? storedData =
        prefs.getStringList('${widget.userEmail}_data');
    if (storedData != null) {
      setState(() {
        _incomeExpenseList = storedData.map((data) {
          final parts = data.split('|');
          return {
            'amount': parts[0],
            'date': parts[1],
            'type': parts[2],
            'note': parts[3],
          };
        }).toList();
      });
    }
  }

  Future<void> _saveIncomeExpenseList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> data = _incomeExpenseList.map((item) {
      return '${item['amount']}|${item['date']}|${item['type']}|${item['note']}';
    }).toList();
    await prefs.setStringList('${widget.userEmail}_data', data);
  }

  void _addIncomeExpense(String amount, String date, String type, String note) {
    setState(() {
      _incomeExpenseList.add({
        'amount': amount,
        'date': date,
        'type': type,
        'note': note,
      });
      _saveIncomeExpenseList();
    });
  }

  void _deleteIncomeExpense(int index) {
    setState(() {
      _incomeExpenseList.removeAt(index);
      _saveIncomeExpenseList();
    });
  }

  double _calculateTotal(String type) {
    return _incomeExpenseList
        .where((item) => item['type'] == type)
        .fold<double>(
            0.0, (sum, item) => sum + double.parse(item['amount'] ?? '0'));
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = _calculateTotal('รายรับ');
    double totalExpense = _calculateTotal('รายจ่าย');
    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการรายรับรายจ่าย'),
      ),
      body: Container(
        color: Colors.grey[200], // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _incomeExpenseList.isEmpty
                  ? const Center(child: Text('ไม่มีรายการ'))
                  : ListView.builder(
                      itemCount: _incomeExpenseList.length,
                      itemBuilder: (context, index) {
                        final item = _incomeExpenseList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text('${item['type']} - ${item['amount']}'),
                            subtitle: Text(
                                'วันที่: ${item['date']}\nโน้ต: ${item['note']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteIncomeExpense(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'รายรับรวม: ${NumberFormat('#,###.##').format(totalIncome)} บาท',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'รายจ่ายรวม: ${NumberFormat('#,###.##').format(totalExpense)} บาท',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'ยอดคงเหลือ: ${NumberFormat('#,###.##').format(balance)} บาท',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: balance >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Income/Expense'),
              content: AddIncomeExpenseForm(onSubmit: _addIncomeExpense),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'เพิ่มรายการ',
      ),
    );
  }
}

class AddIncomeExpenseForm extends StatefulWidget {
  final void Function(String amount, String date, String type, String note)
      onSubmit;

  const AddIncomeExpenseForm({Key? key, required this.onSubmit})
      : super(key: key);

  @override
  _AddIncomeExpenseFormState createState() => _AddIncomeExpenseFormState();
}

class _AddIncomeExpenseFormState extends State<AddIncomeExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedType = 'รายรับ';
  DateTime _selectedDate = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _amountController.text,
        DateFormat('yyyy-MM-dd').format(_selectedDate),
        _selectedType,
        _noteController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
            items: const [
              DropdownMenuItem(value: 'รายรับ', child: Text('Income')),
              DropdownMenuItem(value: 'รายจ่าย', child: Text('Expense')),
            ],
            decoration: const InputDecoration(labelText: 'Type'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
