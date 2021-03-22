import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplechat/main.dart';
import 'package:simplechat/screens/main/chat_list_screen.dart';
import 'package:simplechat/screens/main/nearby_screen.dart';
import 'package:simplechat/screens/main/noti_screen.dart';
import 'package:simplechat/screens/main/post_screen.dart';
import 'package:simplechat/screens/main/setting_screen.dart';
import 'package:simplechat/services/notification_service.dart';
import 'package:simplechat/services/socket_service.dart';
import 'package:simplechat/utils/colors.dart';
import 'package:simplechat/utils/constants.dart';
import 'package:simplechat/utils/dimens.dart';
import 'package:simplechat/utils/themes.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    NotificationService(context).init();

    socketService = injector.get<SocketService>();
    socketService.createSocketConnection();
  }

  var _screens = <int, Widget Function()>{
    0: () => PostScreen(),
    1: () => ChatListScreen(),
    3: () => appSettingInfo['isNearby'] ? NearByScreen() : NotiScreen(),
    4: () => SettingScreen(),
  };
  var bottomItems = [
    {
      'icon': 'assets/icons/ic_post.svg',
      'title': 'Posts',
    },
    {
      'icon': 'assets/icons/ic_chat.svg',
      'title': 'Chats',
    },
    {
      'icon': '',
      'title': '',
    },
    appSettingInfo['isNearby'] ? {
      'icon': 'assets/icons/ic_nearby.svg',
      'title': 'Nearby',
    } : {
      'icon': 'assets/icons/ic_notification_on.svg',
      'title': 'Notify',
    },
    {
      'icon': 'assets/icons/ic_setting.svg',
      'title': 'Setting',
    },
  ];
  var selectedIndex = 0;

  Color getColor(int index) {
    if (index == selectedIndex) {
      return Colors.green;
    } else {
      return Colors.green.withOpacity(0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        body: _screens[selectedIndex](),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 54,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                for (var item in bottomItems)
                  item['icon'].isEmpty
                      ? Expanded(
                          child: Container(),
                          flex: 3,
                        )
                      : Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = bottomItems.indexOf(item);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(offsetSm),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    item['icon'],
                                    width: 18.0,
                                    height: 18.0,
                                    fit: BoxFit.fitHeight,
                                    color: getColor(bottomItems.indexOf(item)),
                                  ),
                                  SizedBox(
                                    height: offsetXSm,
                                  ),
                                  Text(
                                    item['title'],
                                    style: semiBold.copyWith(
                                        fontSize: fontSm,
                                        color:
                                            getColor(bottomItems.indexOf(item))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          flex: 2,
                        ),
              ],
            ),
          ),
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
        ),
        floatingActionButton:
            FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}