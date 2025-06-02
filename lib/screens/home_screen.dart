import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pokepedia = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=151"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];

        List<Future> futures = results.map((pokemon) async {
          final detailResponse = await http.get(Uri.parse(pokemon['url']));
          if (detailResponse.statusCode == 200) {
            final detailData = jsonDecode(detailResponse.body);
            return {
              'name': detailData['name'],
              'image': detailData['sprites']['other']['official-artwork']['front_default'] ?? '',
              'types': detailData['types']
                  .map<String>((t) => t['type']['name'].toString())
                  .toList(),
            };
          } else {
            return null;
          }
        }).toList();

        final allDetails = await Future.wait(futures);

        setState(() {
          pokepedia = allDetails.where((e) => e != null).toList();
          isLoading = false;
        });
      } else {
        print("Failed to load list: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.greenAccent;
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'electric':
        return Colors.yellowAccent;
      case 'rock':
        return Colors.grey;
      case 'ground':
        return Colors.brown;
      case 'psychic':
        return Colors.indigo;
      case 'fighting':
        return Colors.orange;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurple;
      case 'normal':
        return Colors.black26;
      case 'poison':
        return Colors.deepPurpleAccent;
      default:
        return Colors.pinkAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'assets/images/pokeball.png',
              width: 200,
              fit: BoxFit.fitHeight,
            ),
          ),
          const Positioned(
            top: 90,
            left: 15,
            child: Text(
              "Pokepedia",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 160,
            bottom: 0,
            left: 0,
            right: 0,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: pokepedia.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokepedia[index];
                      final String name = pokemon['name'] ?? 'Unknown';
                      final String image = pokemon['image'] ?? '';
                      final List typeList = pokemon['types'] ?? [];
                      final String type = typeList.isNotEmpty ? typeList[0] : 'Unknown';

                      Color bgColor = _getTypeColor(type);

                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          // Navigate to details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(pokemon: pokemon),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: bgColor,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: Image.asset(
                                  'assets/images/pokeball.png',
                                  width: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              Positioned(
                                top: 15,
                                left: 10,
                                child: Text(
                                  name[0].toUpperCase() + name.substring(1),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 40,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white30,
                                  ),
                                  child: Text(
                                    type,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  height: 90,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map pokemon;
  const DetailScreen({super.key, required this.pokemon});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.greenAccent;
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'electric':
        return Colors.yellowAccent;
      case 'rock':
        return Colors.grey;
      case 'ground':
        return Colors.brown;
      case 'psychic':
        return Colors.indigo;
      case 'fighting':
        return Colors.orange;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurple;
      case 'normal':
        return Colors.black26;
      case 'poison':
        return Colors.deepPurpleAccent;
      default:
        return Colors.pinkAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = pokemon['name'] ?? 'Unknown';
    final String image = pokemon['image'] ?? '';
    final List types = pokemon['types'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(name[0].toUpperCase() + name.substring(1)),
        backgroundColor: _getTypeColor(types.isNotEmpty ? types[0] : ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: image,
              height: 200,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            Text(
              'Types',
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: types.map<Widget>((type) {
                return Chip(
                  label: Text(
                    type[0].toUpperCase() + type.substring(1),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getTypeColor(type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
