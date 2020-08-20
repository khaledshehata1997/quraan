

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quraan/fehres.dart';
import 'package:quraan/lists/listImage.dart';
import 'package:quraan/lists/listOfNameSwraPerPages.dart';
import 'package:quraan/lists/listOfPartPerPage.dart';
import 'package:quraan/lists/listOfParts.dart';
import 'package:quraan/lists/swraNameList.dart';
import 'package:quraan/main.dart';
import 'package:quraan/screens/ajzaa.dart';
import 'package:quraan/screens/dialog/goDialog.dart';
import 'package:quraan/screens/dialog/savedialog.dart';
import 'package:quraan/screens/doaa.dart';
import 'package:quraan/screens/fehresPages.dart';
import 'package:quraan/screens/our.dart';
import 'package:quraan/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final int initialPage;
  MyHomePage({this.initialPage});
  @override
  _MyHomePageState createState() => _MyHomePageState(initialPage:this.initialPage);
}

class _MyHomePageState extends State<MyHomePage> {
  int initialPage;
  _MyHomePageState({this.initialPage});
  bool show = false;
  bool darkMode = false;
  int page;
  String part;
  String swra;
  bool messages = false;
  PageController _pageController;
  @override
  void initState() {

    if(initialPage == null){
    _pageController = PageController(
    initialPage: 1,
    );
    page =1;
    swra = swraNameList[listOfNameSwraPerPages[0]];
    part = listOfParts[listOfPartPerPage[0]];
    }else{
    _pageController = PageController(
    initialPage: initialPage-1,
    ); 
    page = initialPage;
    swra = swraNameList[listOfNameSwraPerPages[initialPage-1]];
    part = listOfParts[listOfPartPerPage[initialPage-1]];
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body:SafeArea(
         bottom: false,
              child: Stack(
          children: <Widget>[
            PageView.builder(
              //scrollDirection: MediaQuery.of(context).size.width>MediaQuery.of(context).size.height?Axis.vertical:Axis.horizontal,
              controller: _pageController,
              onPageChanged: (i){
                setState(() {
                  page = i+1;
                  swra = swraNameList[listOfNameSwraPerPages[i]];
                  part = listOfParts[listOfPartPerPage[i]];
                  _savelastPage();
                });
              },
              itemCount:listOfImages.length ,
              itemBuilder: (context,index){
                return pages(listOfImages[index]);
              }
              ),

               show?Positioned(
            top: 0,
          child: Container(
            padding: EdgeInsets.only(right:10,left:10),
            height: 35,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("الجزء $part" ,style: TextStyle(fontSize:18, color:Colors.white),),

                Text("$page" ,style: TextStyle(fontSize:18, color:Colors.white),),
                Text(page%2==0?"وجه ايسر":"وجه ايمن" ,style: TextStyle(fontSize:17, color:Colors.white),),
                Text("سورة $swra" ,style: TextStyle(fontSize:18, color:Colors.white),)
              ],
            ),
          )):Container(),

          show?Positioned(
            bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.width/6.5 ,
            child:Image(image: AssetImage("images/bar.png"),fit: BoxFit.fill,)
          )
          ):Container(),
          

          show?Positioned(
            top: 35,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 403,
            width: 160,
            color: Colors.black87,
            child: SingleChildScrollView(
                          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(right:10,left:10),
                    width: 180,
                    height: 190,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                          },
                      child:Row(
                        children: <Widget>[
                        Icon(Icons.search,size: 25,color: Colors.white,),
                        SizedBox(width:5),
                        Text("البحث" ,style: TextStyle(fontSize:18, color:Colors.white),),                 
                        ],
                    ),
                      ),
                      Container(height:1,width: 160,color: Colors.white30,),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              darkMode = !darkMode;
                            });
                          },
                          
                      child:Row(
                        children: <Widget>[
                        Icon(Icons.brightness_3,size: 25,color: Colors.white,),
                        SizedBox(width:5),
                        Text("الوضع الليلي" ,style: TextStyle(fontSize:18, color:Colors.white),),                 
                        ],
                    ),
                      ),
                      Container(height:1,width: 160,color: Colors.white30,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                                      show = false;
                                    });
                          showDialog(
  context: context,
  builder: (BuildContext context) => CustomSaveDialog(
    page: page,
        title: "هل تود تغيير مكان العلامة ؟",
        description:"",
        buttonText: "نعم",
        image: Image(image: AssetImage("images/icon.png"),fit: BoxFit.fill,),
      ),
);
                        },
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.bookmark_border,size: 22,color: Colors.white,),
                        SizedBox(width:5),
                        Text("حفظ علامة" ,style: TextStyle(fontSize:18, color:Colors.white),),                 
                        ],
                    ),
                      ),
                    Container(height:1,width: 160,color: Colors.white30,),
                    GestureDetector(
                      onTap: (){
                        _pageController.animateToPage(
                        appState.getPageOfSaved,
                        duration: Duration(milliseconds: 350),
                         curve: Curves.easeIn,
                         );
                      },
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.bookmark_border,size: 22,color: Colors.white,),
                        SizedBox(width:5),
                        Text("انتقال الي علامة" ,style: TextStyle(fontSize:18, color:Colors.white),),                 
                        ],
                      ),
                    ),
                    Container(height:1,width: 160,color: Colors.white30,),
                    
                    GestureDetector(
                      onTap: (){
                        showDialog(
  context: context,
  builder: (BuildContext context) => CustomGoDialog(
        title: "رقم الصفحة التي تود الذهاب اليها",
        buttonText: "ذهاب",
        image: Image(image: AssetImage("images/icon.png"),fit: BoxFit.fill,),
      ),
);
                      },
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.exit_to_app,size: 22,color: Colors.white,),
                        SizedBox(width:5),
                        Text("انتقال الي صفحة" ,style: TextStyle(fontSize:18, color:Colors.white),),                 
                        ],
                      ),
                    ),
                    SizedBox(height:1),
                    
                      ],
                    ),
                  ),

                  Container(height:1,width:160,color: Colors.white30,),

                  Container(
                    //padding: EdgeInsets.only(right:10,left:10),
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Fehres()));
                        },
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.list,size: 25,color: Colors.white,),
                        SizedBox(width:10),
                        Text("الفهرس" ,style: TextStyle(fontSize:19, color:Colors.white),),                 
                        ],
                    ),
                      ),
                      Container(height:1,width: 160,color: Colors.white30,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Fehress()));
                        },
                                            child: Row(
                        children: <Widget>[
                        Icon(Icons.spa,size: 25,color: Colors.white,),
                        SizedBox(width:10),
                        Text("الاجزاء" ,style: TextStyle(fontSize:19, color:Colors.white),),                 
                        ],
                    ),
                      ),
                    Container(height:1,width: 160,color: Colors.white30,),
                    GestureDetector(
                       onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>FehresPages()));
                        },
                        
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.library_books,size: 25,color: Colors.white,),
                        SizedBox(width:10),
                        Text("الصفحات" ,style: TextStyle(fontSize:19, color:Colors.white),),                 
                        ],
                      ),
                    ),
                      ],
                    ),
                  ),

                  Container(height:1,width:160,color: Colors.white30,),

                  Container(
                    //padding: EdgeInsets.only(right:10,left:10),
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Doaa()));
                        },
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.import_contacts,size: 25,color: Colors.white,),
                        SizedBox(width:10),
                        Text("دعاء الختم" ,style: TextStyle(fontSize:19, color:Colors.white),),                 
                        ],
                    ),
                      ),
                    Container(height:1,width: 160,color: Colors.white30,),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>A3mal()));
                          
                        },
                        child: Row(
                        children: <Widget>[
                        Icon(Icons.group,size: 25,color: Colors.white,),
                        SizedBox(width:10),
                        Text("تواصل معنا" ,style: TextStyle(fontSize:19, color:Colors.white),),                 
                        ],
                      ),
                    ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          )):Container()

        ],
        ),
      )
    );
  }
  _savelastPage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int lastPage = page;
  print(page);
  await prefs.setInt('lastPage', lastPage);
  }


  Widget pages(img){
    AppState appState = Provider.of<AppState>(context);
    return
          ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    GestureDetector(
          onTap: (){
            setState(() {
              show = !show;
            });
          },
                    child: ColorFiltered(
                      colorFilter: darkMode?ColorFilter.mode(Colors.white, BlendMode.difference):ColorFilter.mode(Colors.orange[50], BlendMode.darken),
                                                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ?MediaQuery.of(context).size.height*3 :MediaQuery.of(context).size.height-25,
              child: Image(fit: BoxFit.fill , image: AssetImage("images/$img"),),
            ),
                    ),         
        ),
        appState.getPageOfSaved == page-1 ?Positioned(
                  top: 0,
                  left: 40,
                  child: Image(image: AssetImage("images/bookmark0.png"), height: 120,)
                
                ):Container(),
                  ],
                ),
              ],
            );
  }
}
