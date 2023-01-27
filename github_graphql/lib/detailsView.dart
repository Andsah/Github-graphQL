import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold( backgroundColor: Colors.blueGrey.shade900,
          body: Center(
            child:
            Container(padding: const EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 85),
                margin: const EdgeInsets.all(5),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: const BorderRadius.all(Radius.circular(37))),
                child: Column(
                    children: [
                  Container(padding: const EdgeInsets.all(10), width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade700,
                        borderRadius: const BorderRadius.all(Radius.circular(37))),
                    child: Center(
                        child: Text(title, textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                    )
                    ),
                  ),
                     const SizedBox(height: 20),
                      Center(
                        child: Text(description,
                            style: GoogleFonts.sourceSansPro(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w200)),
                      ),
              Expanded(child: SizedBox.fromSize()),
              Container(padding: const EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                height: 250,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade700,
                      borderRadius: const BorderRadius.all(Radius.circular(37))),
                  child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column( mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Licence",
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      Text("Commits",
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      Text("Branches",
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400))
                    ]),
                    Column( mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      Text(license,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      Text(numCommits.toString(),
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      Text(numBranches.toString(),
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400))
                    ],)
                  ]),
              )
                ]
            )
          )
          ),
          floatingActionButton: Hero(tag: listIndex,
              child: Material( type: MaterialType.transparency,
                  child: CircleAvatar( radius: 30,
                      backgroundColor: Colors.blueGrey.shade100,
                      child: IconButton(
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