import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokeDetails extends StatelessWidget {
  final Map pokemon;

  const PokeDetails({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final String name = pokemon['name'];
    final String image = pokemon['image'];
    final List types = pokemon['type'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name[0].toUpperCase() + name.substring(1)),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.network(image, height: 200),
            ),
            const SizedBox(height: 20),
            Text(
              "Type(s): ${types.join(", ")}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: fetchPokemonDetails(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Failed to load details");
                }

                final data = snapshot.data as Map;
                final abilities = data['abilities'] as List;
                final experience = data['base_experience'] ?? 0;
                final cry = data['cries']['latest'] ?? "";

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Base Experience: $experience",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Abilities: ${abilities.map((a) => a['ability']['name']).join(', ')}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      if (cry.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                          },
                          child: const Text("Play Cry"),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Map> fetchPokemonDetails(String name) async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$name");
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load Pokémon details");
    }
  }
}
