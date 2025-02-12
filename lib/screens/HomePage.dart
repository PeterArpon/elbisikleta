import 'package:elbisikleta/screens/AddBikePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/user_controller.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:elbisikleta/screens/BikeCard.dart';
import 'package:elbisikleta/models/bike_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex = 0;
  TabController? _tabController;
  late Future<QuerySnapshot> _bikesFuture;

  @override
  void initState() {
    super.initState();
    _bikesFuture = _fetchBikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshBikes,
        child: ListView(
          children: [
            _userProfile(),
            _addBike(),
            _searchField(),
            _popularBikes(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Future<void> _refreshBikes() async {
    setState(() {
      _bikesFuture = _fetchBikes();
    });
  }

  Future<QuerySnapshot> _fetchBikes() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('bikes').where('isAvailable', isEqualTo: true);
    
    return query.orderBy('createdAt', descending: true).get();
  }

  GestureDetector _addBike() {
    return GestureDetector(
      onTap: () {
        // navigate to add bike page
        final String ownerId = UserController.user!.uid;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBikePage(ownerId: ownerId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LineIcons.plusCircle,
              size: 36,
              color: Color(0xff1D1617),
            ),
            SizedBox(height: 5),
            Text('Add a bike',
              style: TextStyle(
                color: Color(0xff1D1617),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _bottomNavigationBar() {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: GNav(
        selectedIndex: bottomIndex,
        onTabChange: (index) {
          setState(() {
            bottomIndex = index;
          });
        },
        curve: Curves.easeOutExpo,
        duration: Duration(milliseconds: 250),
        gap: 2,
        activeColor: Colors.black,
        iconSize: 24,
        tabBackgroundColor: Color(0xffE7E8E8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tabs: [
          GButton(
            icon: LineIcons.home,
            text: 'Home',
          ),
          GButton(
            icon: LineIcons.bicycle,
            text: 'Bikes',
          ),
          GButton(
            icon: LineIcons.map,
            text: 'Map',
          ),
          GButton(
            icon: LineIcons.user,
            text: 'Profile',
          ),
        ]
      ),
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
          FutureBuilder<QuerySnapshot>(
            future: _bikesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No bikes found');
              }

              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final bike = BikeModel.fromFirestore(snapshot.data!.docs[index]);
                    return BikeCard(
                      bike: bike,
                    );
                  },
                );
            },
          ),
        ],
      ),
    );
  }

  Container _userProfile(){
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
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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