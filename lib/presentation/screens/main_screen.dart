import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'JKtecno',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 75, 74, 74),
        elevation: 0, // opcional para eliminar sombra
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Inicio',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            width: 380,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0Xff004B4C),
                  Color(0xFF07CAB3),
                ], // Los colores del degradado
                begin: Alignment.topLeft, // De arriba a la izquierda
                end: Alignment.bottomRight, // Hacia abajo a la derecha
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: const Text(
                  'Ofertas \nEspeciales',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    width: 100, // Tamaño fijo para el círculo
                    height: 100, // Tamaño fijo para el círculo
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 75, 74, 74),
                      shape: BoxShape.circle, // Esto hace que sea circular
                    ),
                    child: Center(
                      child: IconButton(
                        enableFeedback: false,
                        onPressed: () {
                          //context.go('/');
                        },
                        icon: const Icon(
                          Icons.phone_android,
                          color: Colors.black,
                          size: 50,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Fundas',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),

              Column(
                children: [
                  Container(
                    width: 100, // Tamaño fijo para el círculo
                    height: 100, // Tamaño fijo para el círculo
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 75, 74, 74),
                      shape: BoxShape.circle, // Esto hace que sea circular
                    ),
                    child: Center(
                      child: IconButton(
                        enableFeedback: false,
                        onPressed: () {
                          //context.go('/');
                        },
                        icon: const Icon(
                          Icons.headphones,
                          color: Colors.black,
                          size: 50,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Auriculares',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),

              Column(
                children: [
                  Container(
                    width: 100, // Tamaño fijo para el círculo
                    height: 100, // Tamaño fijo para el círculo
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 75, 74, 74),
                      shape: BoxShape.circle, // Esto hace que sea circular
                    ),
                    child: Center(
                      child: IconButton(
                        enableFeedback: false,
                        onPressed: () {
                          //context.go('/');
                        },
                        icon: const Icon(
                          Icons.cable,
                          color: Colors.black,
                          size: 50,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cargadores',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Productos destacados',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  width: 160,
                  height: 230,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ), // Espacio entre la parte superior de la tarjeta y la imagen
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            'https://www.macstation.com.ar/web/image/product.template/63139/image_1024?unique=d209ace',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ), // Separación entre la imagen y el título
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Funda roja',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ), // Separación entre el título y el precio
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '\$999',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SizedBox(
                  width: 160,
                  height: 230,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                        ), // Espacio entre la parte superior de la tarjeta y la imagen
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            'https://static.vecteezy.com/system/resources/thumbnails/014/033/452/small_2x/wireless-headphones-front-view-white-icon-on-a-transparent-background-3d-rendering-png.png',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ), // Separación entre la imagen y el título
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Auriculares X',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ), // Separación entre el título y el precio
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '\$1599',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: Color.fromARGB(255, 75, 74, 74)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                context.go('/');
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.black,
                size: 40,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                context.go('/test');
              },
              icon: const Icon(Icons.dehaze, color: Colors.black, size: 40),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                //context.go('/');
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
                size: 40,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                context.go('/profile');
              },
              icon: const Icon(
                Icons.person_outline,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
