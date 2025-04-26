import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/CustomHeader.dart';

class CreatePinPage extends StatefulWidget {
  const CreatePinPage({super.key});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  List<String> pin = ['', '', '', ''];
  int currentIndex = 0;
  bool isConfirmed = false;

  void _addDigit(String digit) {
    if (currentIndex < 4) {
      setState(() {
        pin[currentIndex] = digit;
        currentIndex++;
      });
    }
  }

  void _removeDigit() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pin[currentIndex] = '';
      });
    }
  }

  void _confirmPin() {
    if (pin.every((element) => element.isNotEmpty)) {
      setState(() {
        isConfirmed = true;
      });

      // Simulasi delay sebelum redirect ke home
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context); // atau redirect ke halaman Home
      });
    }
  }

  Widget _buildPinBox(String text) {
    return Container(
      width: 50,
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text.isEmpty ? '' : '•',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildKey(String label, {IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => _addDigit(label),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: icon == null
            ? Text(label, style: const TextStyle(fontSize: 24))
            : Icon(icon, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FE),
      appBar: const CustomHeader(title: "Create New Pin"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isConfirmed
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 100),
                  const SizedBox(height: 20),
                  const Text("Congratulations",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    "Your Account is Ready to Use.\nYou will be redirected to the Home Page in a Few Seconds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  const CircularProgressIndicator(),
                ],
              )
            : Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Add a Pin Number to Make Your Account more Secure",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 30),

                  // PIN Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pin.map(_buildPinBox).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Continue Button
                  ActionButton(
                    label: 'Continue',
                    color: const Color(0xFF1D224F),
                    onTap: _confirmPin,
                    width: double.infinity,
                    height: 55,
         
                  ),
                  const SizedBox(height: 30),

                  // Number Pad
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      children: [
                        ...List.generate(9, (i) {
                          final digit = '${i + 1}';
                          return _buildKey(digit);
                        }),
                        _buildKey('', icon: Icons.close, onTap: () {}),
                        _buildKey('0'),
                        _buildKey('', icon: Icons.backspace, onTap: _removeDigit),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
