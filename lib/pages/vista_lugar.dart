import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../util/lugar.dart';

class LugarDetalle extends StatefulWidget {
  final Lugar lugar;

  const LugarDetalle({Key? key, required this.lugar}) : super(key: key);

  @override
  _LugarDetalleState createState() => _LugarDetalleState();
}

class _LugarDetalleState extends State<LugarDetalle> {
  bool isFavorite = false;
  bool isSpeaking = false;
  final FlutterTts flutterTts = FlutterTts();

  Future _speak(String text) async {
    await flutterTts.setLanguage('es-LA');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  Future _pause() async {
    await flutterTts.pause();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double carouselHeight = MediaQuery.of(context).size.height * 0.35;
    final double carouselWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: carouselHeight,
              width: carouselWidth,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: carouselHeight,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  aspectRatio: 16 / 9,
                ),
                items: [
                  Stack(
                    children: [
                      Image.network(
                        'https://new.diariolaprensa.cl/wp-content/uploads/2023/04/F-1-CERRO-Y-TURISMO.jpg',
                        fit: BoxFit.cover,
                        width: carouselWidth,
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Image.network(
                        'https://www.monumentos.gob.cl/sites/default/files/styles/slide_monumentos/public/image-monumentos/ZT_00425_2011_CMN%20%282%29.JPG?itok=S89AiYuD',
                        fit: BoxFit.cover,
                        width: carouselWidth,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    widget.lugar.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            rating: widget.lugar.valoracion,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                            unratedColor: Colors.grey[300],
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.lugar.valoracion.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '(${widget.lugar.valoraciones.length})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Historia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.lugar.historia,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isSpeaking) {
                          _pause();
                        } else {
                          _speak(widget.lugar.historia);
                        }
                        setState(() {
                          isSpeaking = !isSpeaking;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                      ),
                      child: Text(
                        isSpeaking ? 'Pausar lectura' : 'Escuchar historia',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
