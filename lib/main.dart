// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:userthai2d3d/models/NotiImages.dart';
import 'datas/NetworkUtil.dart';
import 'datas/constant.dart';
import 'datas/database_helper.dart';
import 'models/AppVersion.dart';
import 'models/NotificationPageObj.dart';
import 'models/intro_model.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:http/http.dart' as http;
import 'pages/download_page.dart';

const AndroidNotificationChannel localNotificationChannel =
    AndroidNotificationChannel(
        'high_thai2d3d_channel', // id
        'High thai2d3d Notifications', // title
        'This channel is used for thai2d3d notifications.', // description
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        sound: RawResourceAndroidNotificationSound('noti'));

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (!kIsWeb) {
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
  }
  AppClass.version = await DatabaseHelper.getData('version');
  if (AppClass.version == null ||
      AppClass.version == "null" ||
      AppClass.version.length == 0) {
    AppClass.version = "1.0.0";
    await DatabaseHelper.setData(AppClass.version, 'version');
  }

  GestureBinding.instance?.resamplingEnabled = true;

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      liveQueryUrl: keyLiveQueryUrl,
      debug: false, // When enabled, prints logs to console
      clientKey: keyClientKey,
      autoSendSessionId: true);
  String homePageUrl;
  String domain;
  String backendUrl;
  var isPlaystore = await DatabaseHelper.getData(AppClass.isPlaystore);
  var queryLink;
  if (isPlaystore != null && isPlaystore == "0") {
    //edit pro link

    homePageUrl = "https://www.thaisinapp.com/home";
    domain = "https://www.thaisinapp.com/";
    backendUrl = "https://api.thaisinapp.com/api";
  } else {
    //demo link
    homePageUrl = "https://www.thaisinapp.com/home";
    domain = "https://www.thaisinapp.com/";
    backendUrl = "https://api.thaisinapp.com/api";
  }

  String storeHomePageUrl = await DatabaseHelper.getData('homePageUrl');
  String storeDomain = await DatabaseHelper.getData('domain');
  String storeBackendUrl = await DatabaseHelper.getData('backendUrl');
  print('StoreHomePageUrl>>>' + storeHomePageUrl.toString());
  if (storeHomePageUrl != "" &&
      storeHomePageUrl != null &&
      storeBackendUrl != null) {
    homePageUrl = storeHomePageUrl;
    domain = storeDomain;
    backendUrl = storeBackendUrl;
  }
  runApp(MyApp(
      homePageUrl: homePageUrl, webSiteDomain: domain, backendUrl: backendUrl));

  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarBrightness: Brightness.light,
  ));

//   import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Parse().initialize(
//     keyApplicationId,
//     keyParseServerUrl,
//     liveQueryUrl: keyLiveQueryUrl,
//     debug: false,
//     clientKey: keyClientKey,
//     autoSendSessionId: true,
//   );

//   String homePageUrl;
//   String domain;
//   String backendUrl;

//   var isPlaystore = await DatabaseHelper.getData(AppClass.isPlaystore);

//   // ✅ Domain List (Main + Backup)
//   List<String> domains = [
//     "https://tsapp.thai2d3dgame.com/",
//     "https://backup1.thai2d3dgame.com/",
//     "https://backup2.thai2d3dgame.com/",
//   ];

//   // ✅ Check available domain
//   String workingDomain = await getWorkingDomain(domains);

//   if (isPlaystore != null && isPlaystore == "0") {
//     // production
//     homePageUrl = "${workingDomain}home";
//     domain = workingDomain;
//     backendUrl = "https://apitest.thai2d3dgame.com/api";
//   } else {
//     // demo
//     homePageUrl = "${workingDomain}home";
//     domain = workingDomain;
//     backendUrl = "https://apitest.thai2d3dgame.com/api";
//   }

//   // ✅ Stored URLs
//   String storeHomePageUrl = await DatabaseHelper.getData('homePageUrl');
//   String storeDomain = await DatabaseHelper.getData('domain');
//   String storeBackendUrl = await DatabaseHelper.getData('backendUrl');

//   if (storeHomePageUrl != "" &&
//       storeHomePageUrl != null &&
//       storeBackendUrl != null) {
//     homePageUrl = storeHomePageUrl;
//     domain = storeDomain;
//     backendUrl = storeBackendUrl;
//   }

//   runApp(MyApp(
//     homePageUrl: homePageUrl,
//     webSiteDomain: domain,
//     backendUrl: backendUrl,
//   ));

//   SystemChrome.setEnabledSystemUIOverlays(
//       [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: statusBarColor,
//     statusBarBrightness: Brightness.light,
//   ));
// }

// /// ✅ Helper function to find first working domain
// Future<String> getWorkingDomain(List<String> domains) async {
//   for (String url in domains) {
//     try {
//       final uri = Uri.parse(url);
//       final request = await HttpClient()
//           .getUrl(uri)
//           .timeout(const Duration(seconds: 3));
//       final response = await request.close();
//       if (response.statusCode == 200 || response.statusCode == 301) {
//         print("✅ Active domain: $url");
//         return url;
//       }
//     } catch (e) {
//       print("⚠️ Domain not available: $url");
//     }
//   }
//   // Default fallback
//   print("❌ No domain active, using default");
//   return domains.first;
// }
}

class required {}

class MyApp extends StatelessWidget {
  final String homePageUrl;
  final String webSiteDomain;
  final String backendUrl;

  const MyApp({Key key, this.homePageUrl, this.webSiteDomain, this.backendUrl})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
          homePageUrl: homePageUrl,
          webSiteDomain: webSiteDomain,
          backendUrl: backendUrl),
      title: '',
      themeMode: ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.homePageUrl, this.webSiteDomain, this.backendUrl})
      : super(
          key: key,
        );
  String homePageUrl;
  String webSiteDomain;
  String backendUrl;

  @override
  MyHomePageState createState() => MyHomePageState();
}

WebViewController controllerGlobal;
bool isBackFromGame = false;

Future<bool> browserBack(
    BuildContext context, String currentDomain, String newdomainName) async {
  print('activated');
  String currentUrl = await controllerGlobal.currentUrl();
  print("Current URL: $currentUrl");
// https: //www.lucky2d.com/country-black-list
  if (currentUrl == currentDomain + "home" || currentUrl == newdomainName) {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(false);
  } else if (currentUrl == currentDomain + "country-black-list") {
  } else if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    if (!currentUrl.startsWith(currentDomain)) {
      isBackFromGame = true;
    } else {
      isBackFromGame = false;
    }
    //edit

    controllerGlobal.goBack();
  } else {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(false);
  }
}

class MyHomePageState extends State<MyHomePage> {
  bool value2 = false;
  String _myNotiToken = "";

  MethodChannel channel = new MethodChannel("com.thai2d3d");
  List<NotificationPageObj> items = [];
  FirebaseMessaging _messaging;
  int progress = 0;

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///sending the data
    sendPort.send([id, status, progress]);
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(localNotificationChannel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIos =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIos);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (!kIsWeb) {
      //pro
      await _messaging.subscribeToTopic('fcmtesting');
    }

    var datatoken = "faketoken";
    if (datatoken != "" && datatoken != null) {
      _messaging.getToken().then((token) async {
        var data = await checkToken(token);
        _myNotiToken = data;
        if (data != null && data != "") {}
      });
    } else {}

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      checkForInitialMessage();
      onMessage();
      onMessageOpenedApp();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      //print('User granted permission');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      checkForInitialMessage();
      onMessage();
      onMessageOpenedApp();
    } else {}

    //getDomainFromOnline();
  }

  onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      var androidPlatformChannel = new AndroidNotificationDetails(
        localNotificationChannel.id,
        localNotificationChannel.name,
        localNotificationChannel.description,
        icon: 'ic_launcher',
        color: Color.fromARGB(255, 0, 0, 0),
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('noti'),
        playSound: true,
        priority: Priority.high,
      );
      var platform =
          new NotificationDetails(android: androidPlatformChannel, iOS: null);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification.title.toString(),
        message.notification.body.toString(),
        platform,
        // payload: message.data['body'].toString(),
      );

      Timer(Duration(seconds: 4), () {
        flutterLocalNotificationsPlugin.cancel(0);
      });

      NotificationPageObj _notification = NotificationPageObj(
        id: int.parse(message.data['id']),
        sound: message.data['sound'].toString(),
        createdDateTimeStr: message.data['created_date_time_Str'].toString(),
        body: message.data['body'].toString(),
        type: message.data['type'].toString(),
        title: message.data['title'].toString(),
        clickAction: message.data["click_action"].toString(),
        accountNo: message.data['account_no'].toString(),
        bodyValue: message.data['body_value'].toString(),
        content: message.data['content'].toString(),
        number: message.data['number'].toString(),
        balance: int.parse(message.data['balance']),
        imageUrl: message.data['imageUrl'].toString(),
        refid: int.parse(message.data['refid']),
        state: message.data['state'].toString(),
        requestDateStr: message.data['request_date_Str'].toString(),
        amount: int.parse(message.data['amount']),
        bill: message.data['bill'].toString(),
        phoneno: message.data['phoneno'].toString(),
        currentDateStr: message.data['current_date_Str'].toString(),
        fortime: message.data['fortime'].toString(),
        userId: int.parse(message.data['user_id']),
        requestDate: message.data['request_date'].toString(),
        currentdate: message.data['currentdate'].toString(),
        time: message.data['time'].toString(),
        createdDate: message.data['created_date'].toString(),
        category: message.data['category'].toString(),
        transactionNo: message.data['transaction_no'].toString(),
        status: message.data['status'].toString(),
        odd: int.parse(message.data['odd']),
        guid: message.data['guid'].toString(),
        messageId: message.data['message_id'].toString(),
        isFirstTopup: message.data['isFirstTopup'].toString(),
        percentage: message.data['percentage'].toString(),
        pointWallet: message.data['pointWallet'].toString(),
      );
      //print(_notification);

      String title = message.notification.title;
      String body = message.notification.body;
      var _imgLink;
      var imgPath = '';
      _imgLink = await getImages(_notification.title, _notification.type,
          _notification.fortime, _notification.isFirstTopup);
      if (_imgLink == null) {
        imgPath = "";
        setState(() {});
      } else {
        imgPath = _imgLink.imagePath;
        setState(() {});
      }
      _showAlertDialog(context, _notification, title, body, imgPath);
    });
  }

  onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      //MessageHandel.ShowMessageDuration(context, "", message.messageId,20);
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

      NotificationPageObj _notification = NotificationPageObj(
        id: int.parse(message.data['id']),
        sound: message.data['sound'].toString(),
        createdDateTimeStr: message.data['created_date_time_Str'].toString(),
        body: message.data['body'].toString(),
        type: message.data['type'].toString(),
        title: message.data['title'].toString(),
        clickAction: message.data["click_action"].toString(),
        accountNo: message.data['account_no'].toString(),
        bodyValue: message.data['body_value'].toString(),
        content: message.data['content'].toString(),
        number: message.data['number'].toString(),
        balance: int.parse(message.data['balance']),
        imageUrl: message.data['imageUrl'].toString(),
        refid: int.parse(message.data['refid']),
        state: message.data['state'].toString(),
        requestDateStr: message.data['request_date_Str'].toString(),
        amount: int.parse(message.data['amount']),
        bill: message.data['bill'].toString(),
        phoneno: message.data['phoneno'].toString(),
        currentDateStr: message.data['current_date_Str'].toString(),
        fortime: message.data['fortime'].toString(),
        userId: int.parse(message.data['user_id']),
        requestDate: message.data['request_date'].toString(),
        currentdate: message.data['currentdate'].toString(),
        time: message.data['time'].toString(),
        createdDate: message.data['created_date'].toString(),
        category: message.data['category'].toString(),
        transactionNo: message.data['transaction_no'].toString(),
        status: message.data['status'].toString(),
        odd: int.parse(message.data['odd']),
        guid: message.data['guid'].toString(),
        messageId: message.data['message_id'].toString(),
        isFirstTopup: message.data['isFirstTopup'].toString(),
        percentage: message.data['percentage'].toString(),
        pointWallet: message.data['pointWallet'].toString(),
      );

      String js = jsonEncode(_notification);
      //var url = widget.webSiteDomain + 'noti-direct-show/' + js;
      var url = widget.webSiteDomain + 'noti-direct-show/' + _notification.guid;
      print(url);
      controllerGlobal.loadUrl(url);
    });
  }

  checkToken(fcmtoken) {
    print(fcmtoken);
    if (fcmtoken == null || fcmtoken == "") {
      _messaging.getToken().then((token) async {
        if (token == null || token == "") {
          checkToken(token);
          _myNotiToken = token;
        } else {
          // sysData.fcmtoken = token;
          _myNotiToken = token;
          return token;
        } // Print the Token in Console
      });
    } else {
      return fcmtoken;
    }
  }

// For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    var backgroundNotificationStatus = "";
    // await DatabaseHelper.getData(DataKeyValue.backgroundNotiStatus);
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null &&
        (backgroundNotificationStatus == null ||
            backgroundNotificationStatus == "")) {
      print(
          'Message title: ${initialMessage.notification?.title}, body: ${initialMessage.notification?.body}, data: ${initialMessage.data}');

      NotificationPageObj _notification = NotificationPageObj(
        id: int.parse(initialMessage.data['id']),
        sound: initialMessage.data['sound'].toString(),
        createdDateTimeStr:
            initialMessage.data['created_date_time_Str'].toString(),
        body: initialMessage.data['body'].toString(),
        type: initialMessage.data['type'].toString(),
        title: initialMessage.data['title'].toString(),
        clickAction: initialMessage.data["click_action"].toString(),
        accountNo: initialMessage.data['account_no'].toString(),
        bodyValue: initialMessage.data['body_value'].toString(),
        content: initialMessage.data['content'].toString(),
        number: initialMessage.data['number'].toString(),
        balance: int.parse(initialMessage.data['balance']),
        imageUrl: initialMessage.data['imageUrl'].toString(),
        refid: int.parse(initialMessage.data['refid']),
        state: initialMessage.data['state'].toString(),
        requestDateStr: initialMessage.data['request_date_Str'].toString(),
        amount: int.parse(initialMessage.data['amount']),
        bill: initialMessage.data['bill'].toString(),
        phoneno: initialMessage.data['phoneno'].toString(),
        currentDateStr: initialMessage.data['current_date_Str'].toString(),
        fortime: initialMessage.data['fortime'].toString(),
        userId: int.parse(initialMessage.data['user_id']),
        requestDate: initialMessage.data['request_date'].toString(),
        currentdate: initialMessage.data['currentdate'].toString(),
        time: initialMessage.data['time'].toString(),
        createdDate: initialMessage.data['created_date'].toString(),
        category: initialMessage.data['category'].toString(),
        transactionNo: initialMessage.data['transaction_no'].toString(),
        status: initialMessage.data['status'].toString(),
        odd: int.parse(initialMessage.data['odd']),
        guid: initialMessage.data['guid'].toString(),
        messageId: initialMessage.data['message_id'].toString(),
        isFirstTopup: initialMessage.data['isFirstTopup'].toString(),
        percentage: initialMessage.data['percentage'].toString(),
        pointWallet: initialMessage.data['pointWallet'].toString(),
      );

      String js = jsonEncode(_notification);
      // print("Js: $js");
      // var url = widget.webSiteDomain + 'noti-direct-show/' + js;
      var url = widget.webSiteDomain + 'noti-direct-show/' + _notification.guid;
      //print(url);
      controllerGlobal.loadUrl(url);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _showUpdate = false;
  String _isFirstTimeOpenApp = "1";
  String _isPlaystore = "0"; //false
  @override
  void initState() {
    super.initState();
    checkIsFirstTimeUseApp();
    checkIsPlaystoreApp();
    updateVersion = AppClass.version;
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        WebView.platform = SurfaceAndroidWebView();
      }
    }

    if (!kIsWeb) {
      registerNotification();
      subscriptToPublicChannel();
      // getPromotionIntroModel();
    }

    //print("version"+AppClass.version);
  }

  checkIsFirstTimeUseApp() async {
    _isFirstTimeOpenApp = await DatabaseHelper.getData(AppClass.isFirstTime);
    setState(() {});
  }

  checkIsPlaystoreApp() async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('ThaiSinMyanmarPlaystore'));
    var response = await query.query();
    if (response.success) {
      print("response success");
      for (var item in response.results) {
        await DatabaseHelper.setData(item['isPlaystore'], AppClass.isPlaystore);
        setState(() {});
      }
    }
  }

  List<IntroModel> adsItem = [];

  getPromotionIntroModel() async {
    adsItem = await getIntroList(context);
    //print("Length : ${adsItem.length}");
    // setState(() {});
  }

  Future<void> subscriptToPublicChannel() async {
    _messaging = FirebaseMessaging.instance;
    var subscriptionRef = FirebaseFirestore.instance.collection('channels');
    try {
      await subscriptionRef.get().then((value) {
        value.docs.forEach((result) async {
          await _messaging.subscribeToTopic(result.data()['name']);
        });
      });
    } catch (e) {}
  }

  checkVersion() async {
    print("In check version");

    var isPlaystore = await DatabaseHelper.getData(AppClass.isPlaystore);
    var queryLink;
    if (isPlaystore != null && isPlaystore == "0") {
      queryLink = 'ThaiSinMyanmarAppCleanCache';
    } else {
      queryLink = 'ThaiSinMyanmarDemoAppCleanCache';
    }
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(queryLink));
    var response = await query.query();
    if (response.success) {
      print("response success");
      for (var item in response.results) {
        updateVersion = item['version'];
        if (updateVersion != AppClass.version) {
          setState(() {
            if (!_showingAds && !_showingUpdateApp) {
              _showUpdate = true;
              _showUpdateAlertDialog(context);
            }
          });
        }
      }
    }
  }

  String updateVersion = "";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool showBackBtn = false;
  // var stackToShow = 1;

  // String backendUrl = "https://apinew.thai2d3d.com/api";

  getDomainFromOnline() async {
    var isPlaystore = await DatabaseHelper.getData(AppClass.isPlaystore);
    var queryLink;
    if (isPlaystore != null && isPlaystore == "0") {
      queryLink = 'ThaiSinMyanmarDomainControl';
    } else {
      queryLink = 'ThaiSinMyanmarDemoDomainControl';
    }

    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(queryLink));

    var response = await query.query();
    String homePageUrl = widget.homePageUrl;
    String domain = widget.webSiteDomain;
    String backendUrl = widget.backendUrl;
    if (response.success) {
      List<ParseObject> list = response.results.toList();
      List<ParseObject> resultList =
          list.where((e) => e['versionCode'] == b4appVersionCode).toList();
      if (resultList.isEmpty || resultList.length == 0) {
        List<ParseObject> tempList =
            list.where((e) => e['versionCode'] == 'default').toList();
        if (tempList.isNotEmpty && tempList.length > 0) {
          domain = tempList.first['domainName'];
          homePageUrl = tempList.first['homePageUrl'] + "/" + _myNotiToken;
          backendUrl = tempList.first['apiUrl'];
        }
      } else {
        var item = resultList.first;
        domain = item['domainName'];
        homePageUrl = item['homePageUrl'] + "/" + _myNotiToken;
        backendUrl = item['apiUrl'];
      }
      await DatabaseHelper.setData(homePageUrl, 'homePageUrl');
      await DatabaseHelper.setData(domain, 'domain');
      await DatabaseHelper.setData(backendUrl, 'backendUrl');
      if (backendUrl != widget.backendUrl) {
        widget.backendUrl = backendUrl;
      }
      if (homePageUrl != widget.homePageUrl) {
        widget.homePageUrl = homePageUrl;
        widget.webSiteDomain = domain;
        controllerGlobal.loadUrl(widget.homePageUrl);
        controllerGlobal.loadUrl(widget.homePageUrl);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstTimeOpenApp == null ||
        _isFirstTimeOpenApp.length == 0 ||
        _isFirstTimeOpenApp == "0") {
      return _buildButtonPage(context);
    } else {
      return _buildParseWebView(widget.homePageUrl);
    }

    //return _buildButtonPage(context);//_buildParseWebView(widget.homePageUrl);
  }

  int _count = 0;

  int progressValue = 0;
  bool isLoading = true;
  bool isShowAds = false;
  bool isFirstload = true;

  Widget _buildParseWebView(String domain) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () =>
            browserBack(context, widget.homePageUrl, widget.webSiteDomain),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Builder(
            builder: (BuildContext context) {
              return Stack(
                children: [
                  Theme(
                    data: ThemeData.light(),
                    child: WebView(
                      //zoomEnabled: false,
                      initialUrl: domain,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        controllerGlobal = webViewController;
                      },
                      onProgress: (int progress) {
                        setState(() {
                          progressValue = progress;
                        });
                        //print("ProgressValue: $progressValue");
                        //print('WebView is loading (progress : $progress%)');
                      },
                      javascriptChannels: <JavascriptChannel>{
                        _toasterJavascriptChannel(context),
                      },
                      navigationDelegate: (NavigationRequest request) async {
                        //print("My Url: ${request.url}");

                        if (request.url.contains('me-page/mobile')) {
                          await controllerGlobal.clearCache();
                          return NavigationDecision.prevent;
                        } else if (request.url
                            .startsWith('https://www.youtube.com/')) {
                          //print('blocking navigation to $request}');
                          return NavigationDecision.prevent;
                        } else if (request.url.endsWith("?openinnewtap=1")) {
                          String url =
                              request.url.replaceAll("?openinnewtap=1", "");
                          _launchURL(url);
                          //print('allowing navigation to $request');
                          return NavigationDecision.prevent;
                        } else {
                          //print('allowing navigation to $request');
                          return NavigationDecision.navigate;
                        }
                      },

                      onPageStarted: (String url) {
                        if (isBackFromGame ||
                            !url.startsWith(widget.webSiteDomain)) {
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        if (!url.startsWith(widget.webSiteDomain)) {
                        } else {
                          SystemChrome.setEnabledSystemUIOverlays(
                              [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                            statusBarColor: statusBarColor,
                          ));

                          setState(() {
                            showBackBtn = false;
                          });
                        }
                      },
                      onPageFinished: (String url) async {
                        AppClass.version =
                            await DatabaseHelper.getData('version');
                        if (!isShowAds && !_showingUpdateApp) {
                          checkVersion();
                        }

                        setState(() {
                          isLoading = false;
                        });
                        if (!url.startsWith(widget.webSiteDomain)) {
                          setState(() {
                            showBackBtn = false;
                          });
                        } else {
                          setState(() {
                            showBackBtn = false;
                          });
                        }
                        if (url == widget.homePageUrl &&
                            !_showingAds &&
                            isFirstload) {
                          isFirstload = false;
                          adsItem = await getIntroList(context);
                          if (adsItem.length > 0) {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return buildAdsWidget(context);
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          } else {
                            checkVersion();
                          }
                        } else {
                          if (url == widget.homePageUrl && !_showingAds) {
                            checkVersionUpdate();
                          }
                        }
                      },
                      gestureNavigationEnabled: true,
                    ),
                  ),
                  isLoading ? _buildLoadingWidget(context) : Stack(),
                ],
              );
            },
          ),
          // floatingActionButton: backButton(),
        ),
      ),
    );
  }

  Widget _buildButtonPage(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff001393),
        title: Center(
            child: const Text('Thai Sin',
                style: TextStyle(
                    color: Color(0xffffffff), fontWeight: FontWeight.w600))),
      ),
      body: Center(
          child: Column(
        children: [
          InkWell(
            onTap: () async {
              if (_count < 6) {
                _count++;
              } else {
                await DatabaseHelper.setData("1", AppClass.isFirstTime);
                Restart.restartApp();
              }
            }, // Image tapped
            splashColor: Colors.white10, // Splash color over image
            child: Ink.image(
              fit: BoxFit.cover, // Fixes border issues
              width: 600.0,
              height: 240.0,
              image: AssetImage(
                'assets/click.jpg',
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // _showAlertDialog(context,"Thai 2D3D ဆော့ဝဲကို လူကြီးမင်းများ ပိုမိုကောင်းမွန်စွာ အသုံးပြုနိုင်ရန်အတွက် ဆော့ဝဲအား Clean Cache လုပ်ပေးရန်",
              //     "Thai 2D3D ဆော့ဝဲကို လူကြီးမင်းများ ပိုမိုကောင်းမွန်စွာ အသုံးပြုနိုင်ရန်အတွက် ဆော့ဝဲအား Clean Cache လုပ်ပေးရန် မေတ္တာရပ်ခံအပ်ပါသည်။ Clean Cache လုပ်နည်း 1. 🐘Thai 2D3D ဆော့ဝဲထဲသို့ဝင်ပါ။ 2. ဆော့ဝဲ၏ ညာ‌ဖက်ထောင့်အောက်ခြေမှ 👤ကိုနှိပ်ပါ 3. Clean Cache ကိုတစ်ချက်နှိပ်လိုက်ပါ 4. လူကြီးမင်း၏ အကောင့်ပြန်ဝင်ရန် လိုအပ်ပါသည်။ Thai 2D3D ဆော့ဝဲ အသုံးပြုခြင်းအတွက် ကျေးဇူးတင်ပါသည်။"
              //     ,"");
              _launchURL("tel:" + "+959988432606");
            },
            child: Container(
                margin: EdgeInsets.only(top: 50, right: 10, left: 10),
                child: Text("ဆက်သွယ်ရန် ဖုန်းနံပါတ်  - ၀၉ ၉၈၈၄၃၂၆၀၆",
                    style: TextStyle(
                        color: Color(0xff2253A2),
                        fontWeight: FontWeight.bold))),
          ),
        ],
      )),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/splash.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LinearProgressIndicator(
              value: progressValue / 100,
              backgroundColor: Colors.white,
              color: Colors.green),
        ],
      ),
    );
  }

  bool _showingAds = false;
  Future<List<IntroModel>> getIntroList(BuildContext context) async {
    NetworkUtil _netUtil = new NetworkUtil();
    var url = "${widget.backendUrl}/promotion/GetPromotionAds";
    List<IntroModel> result = [];
    var _header = await getHeadersWithOutToken();
    http.Response response = await _netUtil.get(this.context, url, _header);
    if (response != null) {
      var obj = json.decode(response.body);
      print(obj);

      for (var item in obj) {
        result.add(IntroModel.fromJson(item));
      }

      if (result.length > 0) {
        _showingAds = true;
      }

      return result;
    }
    return result;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<void> _showUpdateAlertDialog(BuildContext context) {
    setState(() {
      AppClass.version = updateVersion;
    });
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                side: const BorderSide(
                  width: 1.0,
                  color: Colors.black12,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _showUpdate = false;
                });
                return null;
              },
            ),
            const SizedBox(
              width: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                side: const BorderSide(
                  width: 1.0,
                  color: Colors.black12,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Text(
                "Reload",
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _showUpdate = false;
                });
                await updateApp(updateVersion);
              },
            ),
          ],
          title: Center(
            child: Row(
              children: const [
                Flexible(
                  child: Text(
                    "Reload App ?",
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  maxLines: null,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                          child: Icon(
                            Icons.warning,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "Please Reload your app.",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool inApp = false;

  Widget backButton() {
    if (showBackBtn) {
      return FloatingActionButton(
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.white,
          ),
        ),
        mini: true,
        // backgroundColor: mainColor,
        backgroundColor: Colors.transparent,
        onPressed: () async {
          await browserBack(context, widget.homePageUrl, widget.webSiteDomain);
        },
        // onPressed: () async {
        //   if (await controllerGlobal.canGoBack()) {
        //     print("onwill goback");
        //     // setState(() {
        //     //   stackToShow = 0;
        //     // });
        //     controllerGlobal.goBack();
        //   }
        // },
        child: Center(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<bool> updateApp(String updateVersion) async {
    AppClass.version = updateVersion;
    await DatabaseHelper.setData(updateVersion, "version");

    await controllerGlobal.clearCache();
    return true;
  }

  Future<void> _showAlertDialog(BuildContext context,
      NotificationPageObj _notification, title, body, imgLink) {
    // Future<void> _showAlertDialog(
    //     BuildContext context, title, body,imgLink) {
    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         shape: RoundedRectangleBorder(
    //             borderRadius:
    //             BorderRadius.circular(20.0)), //this right here
    //         child: Stack(
    //           overflow: Overflow.visible,
    //           alignment: Alignment.topCenter,
    //           children: [
    //             Container(
    //               height: MediaQuery.of(context).size.height / 3,
    //               child: Padding(
    //                 padding: const EdgeInsets.only(top: 12.0,left: 12.0,right: 12.0),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Flexible(
    //                           child: Padding(
    //                             padding: const EdgeInsets.only(top: 5.0),
    //                             child: Text(
    //                               title,
    //                               maxLines: null,
    //                               style: const TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.bold,
    //                                 color: Color(0xff2253A2),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                         Expanded(
    //                           child: RichText(
    //                             maxLines: null,
    //                             text: TextSpan(
    //                               children: [
    //                                 // WidgetSpan(
    //                                 //   child: Padding(
    //                                 //     padding: const EdgeInsets.fromLTRB(2, 0, 4, 0),
    //                                 //     child: Icon(
    //                                 //       Icons.warning,
    //                                 //       color: Theme.of(context).primaryColor,
    //                                 //     ),
    //                                 //   ),
    //                                 // ),
    //                                 TextSpan(
    //                                   text: body,
    //                                   style: const TextStyle(
    //                                     fontSize: 12,
    //                                     color: Color(0xff2253A2),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: (MediaQuery.of(context).size.height -10 / 3) ,
    //                     ),
    //                     Row(
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                       children: [
    //                         OutlinedButton(
    //                           style: OutlinedButton.styleFrom(
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(5.0),
    //                             ),
    //                             side: const BorderSide(
    //                               width: 1.0,
    //                               color: Color(0xff2253A2),
    //                               style: BorderStyle.solid,
    //                             ),
    //                           ),
    //                           child: const Text(
    //                             "    Close    ",style: TextStyle(color: Color(0xff2253A2)),
    //                           ),
    //                           onPressed: () {
    //                             Navigator.of(context).pop();
    //                             return null;
    //                           },
    //                         ),
    //                         OutlinedButton(
    //                           style: OutlinedButton.styleFrom(
    //                             backgroundColor: Color(0xff2253A2),
    //                             shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.circular(5.0),
    //                             ),
    //                             side: const BorderSide(
    //                               width: 1.0,
    //                               color: Color(0xff2253A2),
    //                               style: BorderStyle.solid,
    //                             ),
    //                           ),
    //                           child: const Text(
    //                             "Go to Detail",style: TextStyle(color: Colors.white),),
    //                           // onPressed: () async {
    //                           //   Navigator.of(context).pop();
    //                           //   String js = jsonEncode(_notification);
    //                           //   //print("js:$js");
    //                           //   //var url = widget.webSiteDomain + 'noti-direct-show/' + js;
    //                           //   var url = widget.webSiteDomain + 'noti-direct-show/' + _notification.guid;
    //                           //   //print(url);
    //                           //   controllerGlobal.loadUrl(url);
    //                           // },
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Positioned(
    //                child: Image.asset(imgLink,width: 60,),
    //                top: -30,
    //             ),
    //           ],
    //         ),
    //       );
    //     });

    var newBody = '';
    if (body.length > 260) {
      newBody = body.substring(0, 260) + "...";
    } else {
      newBody = body;
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Color(0xff2253A2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Text(
                    "    Close    ",
                    style: TextStyle(color: Color(0xff2253A2)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    return null;
                  },
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xff2253A2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    side: const BorderSide(
                      width: 1.0,
                      color: Color(0xff2253A2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Text(
                    "Go to Detail",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    String js = jsonEncode(_notification);
                    //print("js:$js");
                    //var url = widget.webSiteDomain + 'noti-direct-show/' + js;
                    var url = widget.webSiteDomain +
                        'noti-direct-show/' +
                        _notification.guid;
                    //print(url);
                    controllerGlobal.loadUrl(url);
                  },
                ),
              ],
            )
          ],
          title: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  maxLines: null,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff2253A2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (imgLink != null && imgLink != "")
                  ? Positioned(
                      child: Image.network(imgLink, width: 60),
                      top: -50,
                    )
                  : Container(),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: RichText(
                maxLines: null,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: newBody,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff2253A2),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
    // return showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //         actionsPadding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
    //         actions: [
    //           OutlinedButton(
    //             style: OutlinedButton.styleFrom(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(18.0),
    //               ),
    //               side: const BorderSide(
    //                 width: 1.0,
    //                 color: Colors.black12,
    //                 style: BorderStyle.solid,
    //               ),
    //             ),
    //             child: const Text(
    //               "Close",
    //             ),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               return null;
    //             },
    //           ),
    //           const SizedBox(
    //             width: 20,
    //           ),
    //           OutlinedButton(
    //             style: OutlinedButton.styleFrom(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(18.0),
    //               ),
    //               side: const BorderSide(
    //                 width: 1.0,
    //                 color: Colors.black12,
    //                 style: BorderStyle.solid,
    //               ),
    //             ),
    //             child: const Text(
    //               "Go to Detail",
    //             ),
    //             onPressed: () async {
    //               Navigator.of(context).pop();
    //               String js = jsonEncode(_notification);
    //               //print("js:$js");
    //               //var url = widget.webSiteDomain + 'noti-direct-show/' + js;
    //               var url = widget.webSiteDomain + 'noti-direct-show/' + _notification.guid;
    //               //print(url);
    //               controllerGlobal.loadUrl(url);
    //             },
    //           ),
    //         ],
    //         title: Center(
    //           child: Row(
    //             children: [
    //               Flexible(
    //                 child: Text(
    //                   title,
    //                   maxLines: null,
    //                   style: const TextStyle(
    //                     fontSize: 13,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         content: Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               child: RichText(
    //                 maxLines: null,
    //                 text: TextSpan(
    //                   children: [
    //                     WidgetSpan(
    //                       child: Padding(
    //                         padding: const EdgeInsets.fromLTRB(2, 0, 4, 0),
    //                         child: Icon(
    //                           Icons.warning,
    //                           color: Theme.of(context).primaryColor,
    //                         ),
    //                       ),
    //                     ),
    //                     TextSpan(
    //                       text: body,
    //                       style: const TextStyle(
    //                         fontSize: 12,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ));
    //   },
    // );
  }

  String link = "";
  String appName = "";
  String updateversion = "";
  int size = 0;

  Future<AppVersion> getAppVersion(String platfrom) async {
    NetworkUtil _netUtil = new NetworkUtil();
    var url =
        "${widget.backendUrl}/value/getAppLatestVersion?platform=$platfrom";
    // var url = "http://worldtimeapi.org/api/ip";
    var _header = await getHeadersWithOutToken();
    http.Response response = await _netUtil.get(this.context, url, _header);
    if (response != null) {
      var obj = json.decode(response.body);
      var dataObj = AppVersion.fromJson(obj);

      return dataObj;
    }
    return null;
  }

  Future<NotiImages> getImages(
      String title, String type, String fortime, String isFirstTopup) async {
    NetworkUtil _netUtil = new NetworkUtil();
    var url = "${widget.backendUrl}/notification/GetNotiImages";
    var data = jsonEncode({
      "title": "$title",
      "type": "$type",
      "fortime": "$fortime",
      "isFirstTopup": "$isFirstTopup",
    });
    var _header = await getHeadersWithOutToken();
    http.Response response =
        await _netUtil.post(this.context, url, headers: _header, body: data);
    if (response != null) {
      if (response.statusCode == 200) {
        var obj = json.decode(response.body);
        var dataObj = NotiImages.fromJson(obj);
        return dataObj;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  bool _showingUpdateApp = false;
  Future<void> checkVersionUpdate() async {
    String platfrom = "";
    if (Platform.isAndroid) {
      platfrom = "playstore";
    }
    if (Platform.isIOS) {
      platfrom = "ios";
    }
    AppVersion version = await getAppVersion(platfrom);
    if (version.douwnloadLink == null ||
        version.versionCode == null ||
        version.fileSize == null) {
      return;
    }

    link = version.douwnloadLink;
    updateversion = version.versionCode;
    appName = version.appName;
    size = int.parse(version.fileSize);

    AppClass.updateVersion = updateversion;
    AppClass.appName = appName;
    int newVer = int.parse(updateversion.replaceAll(".", ""));
    int myVer = int.parse(appVersion.replaceAll(".", ""));
    if (newVer > myVer) {
      if (!_showingAds) {
        _showingUpdateApp = true;
        _showVersionUpdateDialog(context);
      }
    } else {
      checkVersion();
    }
  }

  Future<void> _showVersionUpdateDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(
              child: Row(
                children: const [
                  Flexible(
                    child: Text(
                      "Update App ?",
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        maxLines: null,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 4, 0),
                                child: Icon(
                                  Icons.warning,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  "A new version of Thai 2D3D is available! Version $updateversion is now available-you have $appVersion.",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          width: 1.0,
                          color: Colors.green,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _showingUpdateApp = false;
                      });
                      Navigator.of(context).pop();
                      // await initPlatformState();
                      await versionUpdate();
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[600]),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(
                          width: 1.0,
                          color: Colors.grey[600],
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _showingUpdateApp = false;
                      });
                      Navigator.of(context).pop();

                      checkVersion();
                      return null;
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> versionUpdate() async {
    String _localPath = (await _findLocalPath());
    String apkFileLocation = _localPath + "/" + appName;
    File apkFile = File(apkFileLocation);
    bool isExist = await apkFile.exists();

    if (isExist) {
      int apkSizeInBytes = await apkFile.length();
      if (apkSizeInBytes == size) {
        // "/storage/emulated/0/Android/data/com.example.thai2dlive/files/thai2dlive-1.0.1.apk"
        OpenResult openState = await OpenFile.open(apkFileLocation);

        if (openState.type == ResultType.error) {
          await download();
        } else if (openState.type == ResultType.fileNotFound) {
          await download();
        }
      } else {
        await download();
      }
    } else {
      await download();
    }
  }

  download() async {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        if (link != null && link != "") {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DownLoadPage(
                  title: "Update new version $updateversion",
                  appName: appName,
                  url: link,
                  version: updateversion));
        }
      } else {}
    } else {
      if (link != null && link != "") {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => DownLoadPage(
                title: "Update new version $updateversion",
                appName: appName,
                url: link,
                version: updateversion));
      }
    }
  }

  Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
        //externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    }

    return externalStorageDirPath;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CarouselController carouselController = CarouselController();

  int duration = 0;
  int currentIndex = 0;
  Widget buildAdsWidget(
    BuildContext context,
  ) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Card(
        child: Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(0),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      aspectRatio: MediaQuery.of(context).size.height /
                          MediaQuery.of(context).size.width,
                      reverse: true,
                      enableInfiniteScroll: true,
                      height: MediaQuery.of(context).size.height,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        if (mounted) {
                          setState(() {
                            currentIndex = index;
                          });
                        }
                      },
                    ),
                    items: adsItem.map(
                      (item) {
                        return item.imgUrl != null && item.imgUrl != ""
                            ? CachedNetworkImage(
                                httpHeaders: <String, String>{
                                  "Access-Control-Allow-Origin": "*",
                                },
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                imageUrl: item.imgUrl,
                                placeholder: (context, url) =>
                                    SpinKitFadingCircle(
                                  color: Colors.white,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Container();
                      },
                    ).toList(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: adsItem.length > 0
                      ? DotsIndicator(
                          dotsCount: adsItem.length,
                          position: currentIndex.toDouble(),
                          onTap: (position) {
                            setState(() {
                              currentIndex = position.toInt();
                            });
                          },
                          decorator: DotsDecorator(
                            size: const Size.square(9.0),
                            activeSize: const Size(18.0, 9.0),
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 10,
              child: SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        left: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        top: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        right: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        bottom: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                      ),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () => closeAds(),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 0,
                            ),
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17),
                            ),
                          ),
                          Countdown(
                            duration: Duration(seconds: introDisplaySec),
                            onFinish: () => closeAds(),
                            builder: (BuildContext ctx, Duration remaining) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    top: 5, left: 5, right: 20, bottom: 5),
                                child: Text('${remaining.inSeconds}',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 17)),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void closeAds() {
    Navigator.of(context).pop();
    _showingAds = false;

    print("On finished");
    checkVersionUpdate();

    return;
  }
}
