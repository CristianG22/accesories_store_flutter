import 'package:accesories_store_flutter/widgets/CustomAppBar.dart';
import 'package:accesories_store_flutter/widgets/CustomBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _nombre = '';
  String _apellido = '';
  String _email = '';
  String _direccion = '';
  String _piso = '';
  DateTime? _fechaNacimiento;
  String _password = '';
  final TextEditingController _fechaController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
        _fechaController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Registro',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField('Nombre', (value) => _nombre = value),
                    _buildField('Apellido', (value) => _apellido = value),
                    _buildEmailField(),
                    _buildField('Dirección', (value) => _direccion = value),
                    _buildField('Piso (opcional)', (value) => _piso = value, required: false),
                    _buildDateField(),
                    _buildPasswordField(),
                    const SizedBox(height: 30),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(),
    );
  }

  Widget _buildField(String label, Function(String) onSaved, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 75, 74, 74),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
        ),
        validator: required 
          ? (value) => value?.isEmpty ?? true ? 'Este campo es requerido' : null
          : null,
        onSaved: (value) => onSaved(value ?? ''),
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 75, 74, 74),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu email';
          }
          if (!value.contains('@')) {
            return 'Ingrese un email válido';
          }
          return null;
        },
        onSaved: (value) => _email = value ?? '',
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _fechaController,
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 75, 74, 74),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
        ),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor selecciona tu fecha de nacimiento';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 75, 74, 74),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa una contraseña';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
        onSaved: (value) => _password = value ?? '',
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff07CAB3),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrando usuario...')),
          );
        }
      },
      child: const Text(
        'Registrarse',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}