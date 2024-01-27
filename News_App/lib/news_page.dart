import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import 'package:news_app/news_web_view.dart';

class NewsPage extends StatefulWidget {
  final String selectedCategory;

  const NewsPage({required this.selectedCategory, Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

Widget _buildCategories(
  String selectedCategory,
  List<String> categoryItems,
  Function(String) onSelectCategory,
) {
  return SizedBox(
    height: 60,
    child: ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              onSelectCategory(categoryItems[index]);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                categoryItems[index] == selectedCategory
                    ? Colors.green.withOpacity(0.5)
                    : Colors.green,
              ),
            ),
            child: Text(categoryItems[index]),
          ),
        );
      },
      itemCount: categoryItems.length,
      scrollDirection: Axis.horizontal,
    ),
  );
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> future;
  String? searchTerm;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String selectedCategory = ""; // Separate variable to track selected category
  List<String> categoryItems = [
    "GENERAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY"
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory; // Initialize with the provided category
    future = getNewsData();
  }

  Future<List<Article>> getNewsData() async {
    NewsAPI newsAPI = NewsAPI("5603c8b2498842878cac670df77f15b9");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query: searchTerm,
      category: selectedCategory,
      pageSize: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching ? searchAppBar() : appBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildCategories(
              selectedCategory,
              categoryItems,
              (category) {
                setState(() {
                  selectedCategory = category;
                  future = getNewsData();
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasError){
                  return const Center(
                    child: Text("Error Loading the news"),);
                }else {
                  if(snapshot.hasData && snapshot.data!.isNotEmpty){
                    return _buildNewsListView(snapshot.data as List<Article>);
                  }else{
                    return const  Center(child: Text("No News Available"),);
                  }
                }
              },
              future: future,
              ),
            )
          ],
      )),
    );
  }

  searchAppBar(){
    return AppBar(
      backgroundColor: Colors.green,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            // print("Search term before update: $searchTerm");
            isSearching = false;
            searchTerm = null;
            searchController.text = "";
            future = getNewsData();
          });
          // print("Search term after update: $searchTerm");
        },
        ),
      title: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              searchTerm = searchController.text;
              future = getNewsData();
          });
        }, icon: const Icon(Icons.search)),
      ],
    );
  }

  appBar(){
    return AppBar(
      backgroundColor: Colors.green,
      title: const Text("NEWS NOW"),
      actions: [
        IconButton(onPressed: () {
          setState(() {
            isSearching = true;
          });
        }, icon: const Icon(Icons.search)),
      ],
    );
  }

  Widget _buildNewsListView(List<Article> articleList){
    return ListView.builder(
      itemBuilder: (context, index){
        Article article = articleList[index];
        return _buildNewsItem(article);
      },
      itemCount: articleList.length,);
  }

  Widget _buildNewsItem(Article article){
    return InkWell(
      onTap: () {
        print(article.url);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsWebView(url:article.url!),
        ));
      },
      child: Card(
        elevation: 4,
        child: Padding(padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.network(article.urlToImage??"",
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported);
              },
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                ),
                Text(article.source.name!,
                style: const TextStyle(color: Colors.grey),
                ),
              ],
            ))
          ],
        ),
        ),
      ),
    );
  }

}