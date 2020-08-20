import 'dart:convert';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:quraan/screens/homePage.dart';

import 'lists/listOfNameSwraPerPages.dart';
import 'lists/swraNameList.dart';

class Post {
  final String title;
  final String aya;
  final int safha;
  Post(this.title, this.aya , this.safha);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  List<String> ayat = [];
  List<String> raquemayat = [];
  List<int> safhat = [];
  @override
  void initState() {
    getDataJson();
    super.initState();
  }

   hasArabicCharacters(String text){
     String newT = "";
    var regex = new RegExp(
        
        "^[\u0621-\u064A\s0-9]");
        for (var i = 0; i < text.length; i++) {
          if(regex.stringMatch(text[i]).toString() != "null"){
          newT = newT + regex.stringMatch(text[i]).toString();
          }
        }
        return newT;
}

  Future<List<Post>> _getALlPosts(String text) async {
    List<Post> posts = [];
    
        for (var i = 0; i < ayat.length; i++) {
          if(hasArabicCharacters("${ayat[i]}").contains(hasArabicCharacters("$text"))){
            posts.add(Post("${ayat[i]}", "${raquemayat[i]}",safhat[i]));
            
          }
        }
        
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
        child: SearchBar<Post>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          searchBarController: _searchBarController,
          // cancellationWidget: Text("Cancel"),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onItemFound: (Post post, int index) {
            return GestureDetector(
              onTap: (){
                Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(initialPage:post.safha)),
          (Route<dynamic> route) => false,
        );
              },
                          child: Container(
                color: Colors.black12,
                child: 
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children:<Widget>[
                    Text(post.title,style: TextStyle(fontSize:20 ,color: Colors.black54 , fontFamily:"quran" , fontWeight: FontWeight.w600 ),),
                    SizedBox(height:10),
                     Row(
                       mainAxisAlignment:MainAxisAlignment.spaceBetween,
                       children:<Widget>[
                         Text("سورة : ${swraNameList[listOfNameSwraPerPages[(post.safha)-1]]}",style: TextStyle(fontSize:20 ,color: Colors.black54 , fontFamily:"quran" , fontWeight: FontWeight.w600 ),),
                         Text("آية : ${post.aya}",style: TextStyle(fontSize:20 ,color: Colors.black54 , fontFamily:"quran" , fontWeight: FontWeight.w600 ),),
                       Text("صفحة رقم : ${post.safha}",style: TextStyle(fontSize:20 ,color: Colors.black54 , fontFamily:"quran" , fontWeight: FontWeight.w600 ),),
                       ]
                     )
                      ]),
                  )
                  // onTap: () {
                  //   //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
                  // },
                  
              ),
            );
          },
        ),
      ),
    );
  }

   getDataJson()async{
    String data = await DefaultAssetBundle.of(context).loadString("data/data.json");
    List jsonResult = json.decode(data);
    print(jsonResult.length);
    for (var i = 0; i < jsonResult.length; i++) {
      ayat.add("${jsonResult[i]["content"]}");
      raquemayat.add("${jsonResult[i]["verse_number"]}");
      safhat.add(jsonResult[i]["safha"]);
      }
    setState(() {
      ayat = ayat;
      raquemayat=raquemayat;
      safhat=safhat;
    });
    print(jsonResult);
  }
}