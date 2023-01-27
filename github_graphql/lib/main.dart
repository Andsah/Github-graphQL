import 'package:flutter/material.dart';
import 'package:github_graphql/detailsView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  const String endpoint = "https://api.github.com/graphql";
  const String pat = "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";

  final HttpLink httpLink = HttpLink(endpoint);

  final AuthLink auth = AuthLink(getToken: () => "Bearer $pat");

  final Link linky = auth.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: linky, cache: GraphQLCache(store: InMemoryStore())));

  var app = GraphQLProvider(client: client, child: const MyApp());

  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.sourceSansProTextTheme(),
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'GitHub Trending Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selection = "all";

  static const String testStr = "GitHub has a feature to show which projects "
      "and developers that are most actively discussed during a given time period ( Trending ). Github's "
      "Trending ranking is based on the number of stars given during a given period of time, with a certain "
      "adaptation to stop manipulation from outside. The GitHub custom trending information is available through "
      "GitHubs Rest-API but not via their GraphQL service. If you choose to use GraphQL";

  void setSelection(value) {
    setState(() {
      selection = value;
    });
  }

  String lastWeekStr =
      "${DateTime.now().year}-${DateTime(DateTime.now().second - 604800).month}-${DateTime(DateTime.now().second - 604800).day}";

  @override
  Widget build(BuildContext context) {
    Map<String, String> vars = {
      "queryString": "is:public archived:false language:$selection"
    };

    String trendingQuery = r"""
        query GitHub_trending($queryString: String!) {
            rateLimit {
                remaining
                resetAt
            }
            search(query:$queryString, type:REPOSITORY, first:100) {
                repositoryCount
                pageInfo {
                    endCursor
                    startCursor
                }
                edges {
                    node {
                    ... on Repository {
                        name
                        description
                        resourcePath
                        forkCount
                        stargazerCount
                        primaryLanguage {
                            name
                        }
                        refs(refPrefix:"refs/heads/") {
                            totalCount
                        }
                        licenseInfo {
                            key
                        }
                        }
                    }
                }
            }
        }
    """;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Container(
              width: 150,
              margin: const EdgeInsets.only(right: 25, top: 5, bottom: 5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade600,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      icon: const Icon(Icons.terminal),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.blueGrey.shade700,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setSelection(value);
                      },
                      value: selection,
                      items: const [
                    DropdownMenuItem(value: "all", child: Text("Top Overall")),
                    DropdownMenuItem(
                        value: "javascript", child: Text("JavaScript")),
                    DropdownMenuItem(
                        value: "typescript", child: Text("TypeScript")),
                    DropdownMenuItem(value: "go", child: Text("Go")),
                    DropdownMenuItem(value: "rust", child: Text("Rust")),
                    DropdownMenuItem(value: "swift", child: Text("Swift")),
                    DropdownMenuItem(value: "web", child: Text("Web")),
                    DropdownMenuItem(value: "php", child: Text("PHP")),
                    DropdownMenuItem(value: "css", child: Text("CSS")),
                    DropdownMenuItem(value: "c", child: Text("C")),
                    DropdownMenuItem(value: "c++", child: Text("C++")),
                    DropdownMenuItem(value: "c#", child: Text("C#")),
                    DropdownMenuItem(value: "py", child: Text("Python")),
                    DropdownMenuItem(value: "ruby", child: Text("Ruby")),
                    DropdownMenuItem(value: "julia", child: Text("Julia")),
                    DropdownMenuItem(value: "java", child: Text("Java"))
                  ])))
        ],
      ),
      body: Query(
        options: QueryOptions(document: gql(trendingQuery), variables: vars),
        builder: (QueryResult result, {refetch, fetchMore}) {
          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final int numRepos = result.data!["search"]["edges"].length;
          final repoList = result.data!["search"]["edges"];
          return Center(
            child: Container(
                padding: const EdgeInsets.only(right: 7, left: 7),
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(37),
                        bottomRight: Radius.circular(37))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 15),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                child: ListView.builder(
                                    clipBehavior: Clip.antiAlias,
                                    itemCount: numRepos,
                                    prototypeItem:
                                        const SizedBox(height: 158.1),
                                    // SETS THE ITEM HEIGHT IN THE LIST
                                    itemBuilder: (context, index) {
                                      return Hero(
                                          tag: index,
                                          child: SizedBox(
                                              height: 200,
                                              child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              bottom: 4),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .blueGrey.shade700,
                                                          borderRadius:
                                                              const BorderRadius.all(
                                                                  Radius.circular(
                                                                      20))),
                                                      child: TextButton(
                                                          style:
                                                              TextButton.styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                              return DetailsView(
                                                                  title:
                                                                      //lastWeekStr,
                                                                      repoList[index]["node"][
                                                                          "name"],
                                                                  namespace: repoList[index]
                                                                          ["node"][
                                                                      "resourcePath"],
                                                                  description:
                                                                      repoList[index]["node"]["description"] ??
                                                                          "",
                                                                  forkCount: repoList[index]
                                                                          ["node"][
                                                                      "forkCount"],
                                                                  license: repoList[index]["node"]["licenseInfo"] != null
                                                                      ? repoList[index]["node"]["licenseInfo"][
                                                                          "key"]
                                                                      : "NAN",
                                                                  numCommits: 1,
                                                                  numBranches: repoList[index]
                                                                          ["node"]["refs"]
                                                                      ["totalCount"],
                                                                  listIndex: index);
                                                            }));
                                                          },
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                    child: Text(
                                                                        repoList[index]["node"]
                                                                            [
                                                                            "name"],
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white),
                                                                        textScaleFactor:
                                                                            1.5)),
                                                                Text(
                                                                    repoList[index]
                                                                            [
                                                                            "node"]
                                                                        [
                                                                        "resourcePath"],
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blueGrey
                                                                            .shade300)),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    child: Text(
                                                                      repoList[index]["node"]
                                                                              [
                                                                              "description"] ??
                                                                          "",
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                      textScaleFactor:
                                                                          1,
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    )),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Container(
                                                                          padding: const EdgeInsets.only(
                                                                              right:
                                                                                  5,
                                                                              bottom:
                                                                                  4),
                                                                          child:
                                                                              Text(
                                                                            "Forks: ${repoList[index]["node"]["forkCount"]}",
                                                                            style:
                                                                                TextStyle(color: Colors.blueGrey.shade300),
                                                                          )),
                                                                      Container(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom:
                                                                                  4,
                                                                              right:
                                                                                  8,
                                                                              left:
                                                                                  5),
                                                                          decoration: const BoxDecoration(
                                                                              color: Colors.yellow,
                                                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
                                                                          child: Text(
                                                                            "Stars: ${repoList[index]["node"]["stargazerCount"]}",
                                                                            style:
                                                                                TextStyle(color: Colors.blueGrey.shade900),
                                                                          ))
                                                                    ])
                                                              ]))))));
                                    })))),
                  ],
                )),
          );
        },
      ),
    );
  }
}
