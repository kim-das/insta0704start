import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(
      MaterialApp(
          theme: style.theme,
          home:MyApp()
  ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab=0;
  var urlData=[];
  var userImage;

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    setState(() {
      urlData=jsonDecode(result.body);
    });

    print(urlData);

  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Instagram'),
        actions: [
          IconButton(
            icon:Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source:ImageSource.gallery);
              if (image!=null){
                setState(() {
                  userImage = File(image.path);
                });}

              Navigator.push(context,
                MaterialPageRoute(builder: (c)=> Upload(userImage:userImage)));
            },),
        ],
      ),
      body:Home(state:urlData),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (i){
          setState(() {
              tab=i;
            });
          },

        items: [
          BottomNavigationBarItem(icon:Icon(Icons.home_outlined),label:'홈'),
          BottomNavigationBarItem(icon:Icon(Icons.shopping_bag_outlined), label:'샵'),
      ]),
    );
  }
}//myApp 끝났음


class Home extends StatefulWidget {
  Home({Key? key, this.state}) : super(key:key);
  final state;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getNewData() async {
    var newData = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    setState(() {
      widget.state.add(jsonDecode(newData.body));
    });
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener((){
      if(scroll.position.pixels==scroll.position.maxScrollExtent){
        getNewData();
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.state.isNotEmpty){
      return  ListView.builder(itemCount:widget.state.length,controller:scroll,itemBuilder:(c,i)
      {
        return Column(
          children:[
            SizedBox(
              width:double.infinity,
              child:
              Column(
                  children: [
                    Image.network(widget.state[i]['image'],width: double.infinity,
                      fit: BoxFit.cover,),

                    Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('좋아요 ${widget.state[i]['likes']}'),
                          Text('글쓴이 ${widget.state[i]['user']}'),
                          Text('글내용 ${widget.state[i]['content']}'),],
                      )
                    )
                  ],
              ),
            ),
          ],
      );
    },
        );}else{
      return Text('로딩중임');
    }
  }
}

class Upload extends StatelessWidget {
  Upload({Key? key, this.userImage}) : super(key:key);
  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true,
      appBar: AppBar(),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            TextField(),
            Text('이미지 업로드 화면'),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close)),
            TextButton(onPressed: (){
              //여기다가 발행 기능 만들 것
            }, child: Text('발행'))
          ],
        ),
      ),
    );
  }
}
