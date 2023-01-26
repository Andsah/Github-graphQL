import 'package:flutter/material.dart';

class DetailsView extends StatelessWidget {
  final String title;
  final String namespace;
  final String description;
  final int forkCount;
  final String license;
  final int numCommits;
  final int numBranches;
  final int listIndex;

  const DetailsView({
    super.key,
    required this.title,
    required this.namespace,
    required this.description,
    required this.forkCount,
    required this.listIndex,
    required this.license,
    required this.numCommits,
    required this.numBranches

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column( children: [Text(description)]
          )
        )
            , floatingActionButton: Hero(tag: listIndex, child: Material( child: CircleAvatar( radius: 30, backgroundColor: Colors.blueGrey.shade100, child: IconButton(
      color: Colors.blueGrey,
      icon: const Icon(Icons.arrow_back),
      onPressed: () { Navigator.pop(context); },

    )
    )
    )
    ),
    );
  }

}