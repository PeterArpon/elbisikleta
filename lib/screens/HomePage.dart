import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _userProfile(),
          _searchField(),
          _popularBikes(),
        ],
      )
    );
  }

  Container _popularBikes(){
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular Bikes',
            style: TextStyle(
              color: Color(0xff1D1617),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _bikeCard('assets/images/bike1.png', 'Bike 1', 'Mountain Bike', '4.5', '20'),
                _bikeCard('assets/images/bike2.png', 'Bike 2', 'Mountain Bike', '4.5', '20'),
                _bikeCard('assets/images/bike3.png', 'Bike 3', 'Mountain Bike', '4.5', '20'),
                _bikeCard('assets/images/bike4.png', 'Bike 4', 'Mountain Bike', '4.5', '20'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _bikeCard(String image, String name, String type, String rating, String price){
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.10),
            spreadRadius: 0,
            blurRadius: 7,
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                  style: TextStyle(
                    color: Color(0xff1D1617),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(type,
                  style: TextStyle(
                    color: Color(0xff1D1617),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/star.svg',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Text(rating,
                      style: TextStyle(
                        color: Color(0xff1D1617),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Text('\$$price',
                      style: TextStyle(
                        color: Color(0xff1D1617),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _userProfile(){
    print(UserController.user?.displayName);
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Color(0xffE7E8E8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CircleAvatar(
              foregroundImage: NetworkImage(UserController.user?.photoURL ?? ''),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,',
                style: TextStyle(
                  color: Color(0xff1D1617),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(UserController.user?.displayName ?? 'NONE',
                style: TextStyle(
                  color: Color(0xff1D1617),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(onPressed: () async {
            await UserController.signOut();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed('/sign-in');
            }
          }, child: Text('Sign Out')),
        ],
      ),
    );
  }

  Container _searchField(){
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.10),
            spreadRadius: 0,
            blurRadius: 7,
          ),
        ]
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          hintText: 'Search for bikes',
          hintStyle: TextStyle(
            color: Color(0xffDDDADA),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset('assets/icons/Search.svg',
              height: 20,
              width: 20,
            ),
          ),
          suffixIcon: Container(
            width: 100,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    color: Colors.black,
                    indent: 10,
                    endIndent: 10,
                    thickness: 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset('assets/icons/Filter.svg',
                      height: 25,
                      width: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none
          )
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Elbisikleta',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {

        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFE7E8E8),
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: Color(0xFFE7E8E8),
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: SvgPicture.asset('assets/icons/dots.svg',
              height: 5,
              width: 5,
            ),
          ),
        ),
      ],
    );
  }
}