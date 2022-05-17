import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:logger/logger.dart';
import 'package:flutter_nano_ffi/flutter_nano_ffi.dart';
import 'package:nautilus_wallet_flutter/bus/payments_home_event.dart';
import 'package:nautilus_wallet_flutter/bus/tx_update_event.dart';
import 'package:nautilus_wallet_flutter/bus/unified_home_event.dart';
import 'package:nautilus_wallet_flutter/localization.dart';
import 'package:nautilus_wallet_flutter/model/available_block_explorer.dart';
import 'package:nautilus_wallet_flutter/model/db/txdata.dart';
import 'package:nautilus_wallet_flutter/model/db/user.dart';
import 'package:nautilus_wallet_flutter/model/wallet.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nautilus_wallet_flutter/network/model/fcm_message_event.dart';
import 'package:nautilus_wallet_flutter/network/model/response/account_balance_item.dart';
import 'package:nautilus_wallet_flutter/network/model/response/account_info_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/accounts_balances_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/alerts_response_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:nautilus_wallet_flutter/themes.dart';
import 'package:nautilus_wallet_flutter/service_locator.dart';
import 'package:nautilus_wallet_flutter/model/available_themes.dart';
import 'package:nautilus_wallet_flutter/model/available_currency.dart';
import 'package:nautilus_wallet_flutter/model/available_language.dart';
import 'package:nautilus_wallet_flutter/model/address.dart';
import 'package:nautilus_wallet_flutter/model/vault.dart';
import 'package:nautilus_wallet_flutter/model/db/appdb.dart';
import 'package:nautilus_wallet_flutter/model/db/account.dart';
import 'package:nautilus_wallet_flutter/util/ninja/api.dart';
import 'package:nautilus_wallet_flutter/util/ninja/ninja_node.dart';
import 'package:nautilus_wallet_flutter/network/model/block_types.dart';
import 'package:nautilus_wallet_flutter/network/model/request/account_history_request.dart';
import 'package:nautilus_wallet_flutter/network/model/request/fcm_update_request.dart';
import 'package:nautilus_wallet_flutter/network/model/request/subscribe_request.dart';
import 'package:nautilus_wallet_flutter/network/model/response/account_history_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/account_history_response_item.dart';
import 'package:nautilus_wallet_flutter/network/model/response/callback_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/error_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/subscribe_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/process_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/pending_response.dart';
import 'package:nautilus_wallet_flutter/network/model/response/pending_response_item.dart';
import 'package:nautilus_wallet_flutter/util/sharedprefsutil.dart';
import 'package:nautilus_wallet_flutter/util/nanoutil.dart';
import 'package:nautilus_wallet_flutter/network/account_service.dart';
import 'package:nautilus_wallet_flutter/bus/events.dart';
// E2E Encryption
import 'package:flutter_js/flutter_js.dart';
// local storage:
import 'package:localstorage/localstorage.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background message");
  // dumb hack since the event bus doesn't work properly in background isolates or w/e:
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var list = await prefs.getStringList('background_messages');
  if (list == null) {
    list = [];
  }
  list.add(jsonEncode(message.data));
  await prefs.setStringList('background_messages', list);
}

Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  // print("Handling a foreground message");
  EventTaxiImpl.singleton().fire(FcmMessageEvent(data: message.data));
}

class _InheritedStateContainer extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final StateContainerState data;

  // You must pass through a child and your state.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}

class StateContainer extends StatefulWidget {
  // You must pass through a child.
  final Widget child;

  StateContainer({@required this.child});

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedStateContainer>().data;
  }

  @override
  StateContainerState createState() => StateContainerState();
}

/// App InheritedWidget
/// This is where we handle the global state and also where
/// we interact with the server and make requests/handle+propagate responses
///
/// Basically the central hub behind the entire app
class StateContainerState extends State<StateContainer> {
  final Logger log = sl.get<Logger>();

  // Minimum receive = 0.000001 NANO
  // String receiveThreshold = BigInt.from(10).pow(24).toString();
  String receiveThreshold = "0";
  // min raw for receive
  // String minRawReceive = "0";

  AppWallet wallet;
  String currencyLocale;
  Locale deviceLocale = Locale('en', 'US');
  AvailableCurrency curCurrency = AvailableCurrency(AvailableCurrencyEnum.USD);
  LanguageSetting curLanguage = LanguageSetting(AvailableLanguage.DEFAULT);
  AvailableBlockExplorer curBlockExplorer = AvailableBlockExplorer(AvailableBlockExplorerEnum.NANOLOOKER);
  BaseTheme curTheme = NautilusTheme();
  bool nyanoMode = false;
  // Currently selected account
  Account selectedAccount = Account(id: 1, name: "AB", index: 0, lastAccess: 0, selected: true);
  // Two most recently used accounts
  Account recentLast;
  Account recentSecondLast;

  // Natricon / Nyanicon settings
  bool natriconOn = false;
  bool nyaniconOn = false;
  Map<String, String> natriconNonce = Map<String, String>();
  Map<String, String> nyaniconNonce = Map<String, String>();

  // Active alert
  AlertResponseItem activeAlert;
  AlertResponseItem settingsAlert;
  bool activeAlertIsRead = true;

  // If callback is locked
  bool _locked = false;

  // Initial deep link
  String initialDeepLink;
  // Deep link changes
  StreamSubscription _deepLinkSub;
  // branch subscription:
  StreamSubscription<Map> _branchSub;

  List<String> pendingRequests = [];
  List<String> alreadyReceived = [];

  // List of Verified Nano Ninja Nodes
  bool nanoNinjaUpdated = false;
  List<NinjaNode> nanoNinjaNodes;

  // nano.to username db up to date?
  // bool nautilusUsernamesUpdated = false;
  // String lastUpdatedUsernames;

  // gifts!
  bool giftedWallet = false;
  String giftedWalletSeed;
  String giftedWalletAddress;
  String giftedWalletAmountRaw;
  String giftedWalletMemo;
  String giftedWalletSenderAddress;

  // When wallet is encrypted
  String encryptedSecret;

  // JS run time:
  JavascriptRuntime flutterJs;

  void updateNinjaNodes(List<NinjaNode> list) {
    setState(() {
      nanoNinjaNodes = list;
    });
  }

  void updateNatriconNonce(String address, int nonce) {
    setState(() {
      this.natriconNonce[address] = nonce.toString();
    });
  }

  void updateNyaniconNonce(String address, int nonce) {
    setState(() {
      this.nyaniconNonce[address] = nonce.toString();
    });
  }

  void updateActiveAlert(AlertResponseItem active, AlertResponseItem settingsAlert) {
    setState(() {
      this.activeAlert = active;
      if (settingsAlert != null) {
        this.settingsAlert = settingsAlert;
      } else {
        this.settingsAlert = null;
        this.activeAlertIsRead = true;
      }
    });
  }

  void setAlertRead() {
    setState(() {
      this.activeAlertIsRead = true;
    });
  }

  void setAlertUnread() {
    setState(() {
      this.activeAlertIsRead = false;
    });
  }

  String getNatriconNonce(String address) {
    if (this.natriconNonce.containsKey(address)) {
      return this.natriconNonce[address];
    }
    return "";
  }

  Future<void> checkAndCacheNapiDatabases(bool forceUpdate) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      int lastUpdatedUsers = int.parse(await sl.get<SharedPrefsUtil>().getLastNapiUsersCheck());

      int day_in_seconds = 60 * 60 * 24;
      int week_in_seconds = day_in_seconds * 7;

      // update if more than a day old:
      if (forceUpdate || currentTime - lastUpdatedUsers > day_in_seconds) {
        await sl.get<DBHelper>().fetchNapiUsernames();
        await sl.get<SharedPrefsUtil>().setLastNapiUsersCheck(currentTime.toString());
      }
      // more than a week old?
      // if (forceUpdate || currentTime - lastUpdatedUsers > week_in_seconds) {
      //   await sl.get<AccountService>().fetchNapiRepresentatives();
      //   await sl.get<SharedPrefsUtil>().setLastNapiRepsCheck(currentTime.toString());
      // }
      // await sl.get<DBHelper>().fetchDatabases();
    } catch (e) {
      log.e("Error checking and caching NAPI databases: $e");
      // update now:
      await sl.get<DBHelper>().fetchNapiUsernames();
      await sl.get<SharedPrefsUtil>().setLastNapiUsersCheck(currentTime.toString());
    }
  }

  Future<void> updateRequests() async {
    if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
      var requests = await sl.get<DBHelper>().getAccountSpecificRequests(wallet.address);
      setState(() {
        this.wallet.requests = requests;
        EventTaxiImpl.singleton().fire(PaymentsHomeEvent(items: wallet.requests));
      });
    }
  }

  Future<void> updateTXMemos() async {
    if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
      EventTaxiImpl.singleton().fire(TXUpdateEvent());
    }
  }

  // Future<void> updateTransactionData() async {
  //   if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
  //     var transactions = await sl.get<DBHelper>().getAccountSpecificTXData(wallet.address);
  //     setState(() {
  //       // this.wallet.transactions = transactions;
  //       // EventTaxiImpl.singleton().fire(PaymentsHomeEvent(items: wallet.transactions));
  //     });
  //   }
  // }

  Future<void> updateUnified(bool fastUpdate) async {
    if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
      setState(() {
        EventTaxiImpl.singleton().fire(UnifiedHomeEvent(fastUpdate: fastUpdate));
      });
    }
  }

  Future<void> checkAndUpdateAlerts() async {
    // Get active alert
    try {
      String localeString = (await sl.get<SharedPrefsUtil>().getLanguage()).getLocaleString();
      if (localeString == "DEFAULT") {
        List<Locale> languageLocales = await Devicelocale.preferredLanguagesAsLocales;
        if (languageLocales.length > 0) {
          localeString = languageLocales[0].languageCode;
        }
      }
      AlertResponseItem alert = await sl.get<AccountService>().getAlert(localeString);
      if (alert == null) {
        updateActiveAlert(null, null);
        return;
      } else if (await sl.get<SharedPrefsUtil>().shouldShowAlert(alert)) {
        // See if we should display this one again
        if (alert.link == null || await sl.get<SharedPrefsUtil>().alertIsRead(alert)) {
          setAlertRead();
        } else {
          setAlertUnread();
        }
        updateActiveAlert(alert, alert);
      } else {
        if (alert.link == null || await sl.get<SharedPrefsUtil>().alertIsRead(alert)) {
          setAlertRead();
        } else {
          setAlertUnread();
        }
        updateActiveAlert(null, alert);
      }
    } catch (e) {
      log.e("Error retrieving alert", e);
      return;
    }
  }

  Future<void> checkAndCacheNinjaAPIResponse() async {
    List<NinjaNode> nodes;
    if ((await sl.get<SharedPrefsUtil>().getNinjaAPICache()) == null) {
      nodes = await NinjaAPI.getVerifiedNodes();
      setState(() {
        nanoNinjaNodes = nodes;
        nanoNinjaUpdated = true;
      });
    } else {
      nodes = await NinjaAPI.getCachedVerifiedNodes();
      setState(() {
        nanoNinjaNodes = nodes;
        nanoNinjaUpdated = false;
      });
    }
  }

  // Future<void> executeAfterBuild() async {
  //   // this code will get executed after the build method
  //   // because of the way async functions are scheduled
  //   print("??????????????????????????????");
  //   flutterJs.evaluate(await rootBundle.loadString("assets/nano-lib.js"));
  // }

  @override
  void initState() {
    super.initState();
    // JS runtime:
    flutterJs = getJavascriptRuntime();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      flutterJs.evaluate(await rootBundle.loadString("assets/nano-lib.js"));
      print("loaded nano JS lib");

      // sanity check:
      // String senderPrivateKey = "B769C123E31D9B07F46FDD7AA9D8F7EC3C11C82F2E44A8A8FD5BEB63DDCED0D1";
      // String senderAddress = "nano_3gfgcm34otkdzarycr9pbxoq4fy7hnk3mcdsnpsmpaafpnu58itiq8zcc4kj";
      // String message = "my message here 123456";
      // String recipientAddress = "nano_343siwsnfs4s4es678x6ts9ocqdg75kkafm4bjktsn8ockcpnt1qdb4xdw8d";
      // String recipientPrivateKey = "768A79E483BC6CCCDE87992BEDA64AB8AADE4A36BD39570CE2CD96B2A71C0C87";
      // String encrypted = await encryptMessage(message, recipientAddress, senderPrivateKey);
      // print("encrypted: ${encrypted}");
      // String decrypted = await decryptMessage(encrypted, senderAddress, recipientPrivateKey);
      // print("decrypted: ${decrypted}");
    });
    // executeAfterBuild();

    // Register RxBus
    _registerBus();
    // Set currency locale here for the UI to access
    sl.get<SharedPrefsUtil>().getCurrency(deviceLocale).then((currency) {
      setState(() {
        currencyLocale = currency.getLocale().toString();
        curCurrency = currency;
      });
    });
    // Get default language setting
    sl.get<SharedPrefsUtil>().getLanguage().then((language) {
      setState(() {
        curLanguage = language;
      });
    });
    // Get theme default
    sl.get<SharedPrefsUtil>().getTheme().then((theme) {
      updateTheme(theme, setIcon: false);
    });
    // Get default block explorer
    sl.get<SharedPrefsUtil>().getBlockExplorer().then((explorer) {
      setState(() {
        curBlockExplorer = explorer;
      });
    });
    // Get initial deep link
    getInitialLink().then((initialLink) {
      setState(() {
        initialDeepLink = initialLink;
      });
    });
    // Cache ninja API if don't already have it
    checkAndCacheNinjaAPIResponse();
    // Update alert
    checkAndUpdateAlerts();
    // Get natricon pref
    sl.get<SharedPrefsUtil>().getUseNatricon().then((useNatricon) {
      setNatriconOn(useNatricon);
    });
    // Get nyanicon pref
    sl.get<SharedPrefsUtil>().getUseNyanicon().then((useNyanicon) {
      setNyaniconOn(useNyanicon);
    });
    // Get min raw receive pref
    sl.get<SharedPrefsUtil>().getMinRawReceive().then((minRaw) {
      setMinRawReceive(minRaw);
    });
    // make sure nano API databases are up to date
    // TODO: only call when out of date
    checkAndCacheNapiDatabases(false);
    // restore payments from the cache
    updateRequests();

    // sl.get<DBHelper>().fetchDatabases();
    // sl.get<DBHelper>().populateDBFromCache();
    // WidgetsBinding.instance.addPostFrameCallback((_) => (context) {
    //       // try {
    //       // } catch (e) {
    //       //   log.e("Error registering background message handler: $e");
    //       // }
    //       FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    //       FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
    //     });
    // WidgetsBinding.instance.ensureVisualUpdate();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // Subscriptions
  StreamSubscription<ConnStatusEvent> _connStatusSub;
  StreamSubscription<SubscribeEvent> _subscribeEventSub;
  StreamSubscription<PriceEvent> _priceEventSub;
  StreamSubscription<CallbackEvent> _callbackSub;
  StreamSubscription<ErrorEvent> _errorSub;
  StreamSubscription<FcmUpdateEvent> _fcmUpdateSub;
  StreamSubscription<FcmMessageEvent> _fcmMessageSub;
  StreamSubscription<AccountModifiedEvent> _accountModifiedSub;

  // Register RX event listenerss
  void _registerBus() {
    _subscribeEventSub = EventTaxiImpl.singleton().registerTo<SubscribeEvent>().listen((event) {
      handleSubscribeResponse(event.response);
    });
    _priceEventSub = EventTaxiImpl.singleton().registerTo<PriceEvent>().listen((event) {
      // PriceResponse's get pushed periodically, it wasn't a request we made so don't pop the queue
      // handle the null case in debug mode:
      setState(() {
        if (wallet != null) {
          wallet.btcPrice = event.response.btcPrice?.toString();
          wallet.localCurrencyPrice = event.response.price?.toString();
        }
      });
    });
    _connStatusSub = EventTaxiImpl.singleton().registerTo<ConnStatusEvent>().listen((event) {
      if (event.status == ConnectionStatus.CONNECTED) {
        requestUpdate();
      } else if (event.status == ConnectionStatus.DISCONNECTED && !sl.get<AccountService>().suspended) {
        sl.get<AccountService>().initCommunication();
      }
    });
    _callbackSub = EventTaxiImpl.singleton().registerTo<CallbackEvent>().listen((event) {
      handleCallbackResponse(event.response);
    });
    _errorSub = EventTaxiImpl.singleton().registerTo<ErrorEvent>().listen((event) {
      handleErrorResponse(event.response);
    });
    _fcmUpdateSub = EventTaxiImpl.singleton().registerTo<FcmUpdateEvent>().listen((event) {
      if (wallet != null) {
        sl.get<SharedPrefsUtil>().getNotificationsOn().then((enabled) {
          sl.get<AccountService>().sendRequest(FcmUpdateRequest(account: wallet.address, fcmToken: event.token, enabled: enabled));
        });
      }
    });
    _fcmMessageSub = EventTaxiImpl.singleton().registerTo<FcmMessageEvent>().listen((event) {
      // final db = Localstore.instance;
      // db.collection('background_messages2').get().then((messages) {
      //   print("bbbbbbbbbbbbbbbbbbbbbbb");
      //   for (var id in messages.keys) {
      //     print("id: $id");
      //     print("message: ${messages[id]}");
      //     // delete from the list:
      //     db.collection('background_messages2').doc(id).delete();
      //   }
      // });

      handleMessage(event.data);
    });
    // Account has been deleted or name changed
    _accountModifiedSub = EventTaxiImpl.singleton().registerTo<AccountModifiedEvent>().listen((event) {
      if (!event.deleted) {
        if (event.account.index == selectedAccount.index) {
          setState(() {
            selectedAccount.name = event.account.name;
          });
        } else {
          updateRecentlyUsedAccounts();
        }
      } else {
        // Remove account
        updateRecentlyUsedAccounts().then((_) {
          if (event.account.index == selectedAccount.index && recentLast != null) {
            sl.get<DBHelper>().changeAccount(recentLast);
            setState(() {
              selectedAccount = recentLast;
            });
            EventTaxiImpl.singleton().fire(AccountChangedEvent(account: recentLast, noPop: true));
          } else if (event.account.index == selectedAccount.index && recentSecondLast != null) {
            sl.get<DBHelper>().changeAccount(recentSecondLast);
            setState(() {
              selectedAccount = recentSecondLast;
            });
            EventTaxiImpl.singleton().fire(AccountChangedEvent(account: recentSecondLast, noPop: true));
          } else if (event.account.index == selectedAccount.index) {
            getSeed().then((seed) {
              sl.get<DBHelper>().getMainAccount(seed).then((mainAccount) {
                sl.get<DBHelper>().changeAccount(mainAccount);
                setState(() {
                  selectedAccount = mainAccount;
                });
                EventTaxiImpl.singleton().fire(AccountChangedEvent(account: mainAccount, noPop: true));
              });
            });
          }
        });
        updateRecentlyUsedAccounts();
      }
    });
    // Deep link has been updated
    _deepLinkSub = getLinksStream().listen((String link) {
      setState(() {
        initialDeepLink = link;
      });
    });

    // branch deep links:
    _branchSub = FlutterBranchSdk.initSession().listen((data) {
      if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) {
        //Link clicked. Add logic to get link data
        print(data);

        // check if they were gifted a wallet:
        if (data.containsKey("~feature") && data["~feature"] == "gift") {
          // if (data["+match_guaranteed"] == true) {
          // setup the auto load wallet:
          setState(() {
            giftedWallet = true;
            giftedWalletSeed = data["seed"] ?? "";
            giftedWalletAmountRaw = data["amount_raw"] ?? "";
            giftedWalletAddress = data["address"] ?? "";
            giftedWalletSenderAddress = data["senderAddress"] ?? "";
            giftedWalletMemo = data["memo"] ?? "";
          });
          // }
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print('InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  @override
  void dispose() {
    _destroyBus();
    super.dispose();
  }

  void _destroyBus() {
    if (_connStatusSub != null) {
      _connStatusSub.cancel();
    }
    if (_subscribeEventSub != null) {
      _subscribeEventSub.cancel();
    }
    if (_priceEventSub != null) {
      _priceEventSub.cancel();
    }
    if (_callbackSub != null) {
      _callbackSub.cancel();
    }
    if (_errorSub != null) {
      _errorSub.cancel();
    }
    if (_fcmUpdateSub != null) {
      _fcmUpdateSub.cancel();
    }
    if (_fcmMessageSub != null) {
      _fcmMessageSub.cancel();
    }
    if (_accountModifiedSub != null) {
      _accountModifiedSub.cancel();
    }
    if (_deepLinkSub != null) {
      _deepLinkSub.cancel();
    }
    if (_branchSub != null) {
      _branchSub.cancel();
    }
  }

  // Update the global wallet instance with a new address
  Future<void> updateWallet({Account account}) async {
    String address = NanoUtil.seedToAddress(await getSeed(), account.index);
    account.address = address;
    selectedAccount = account;
    updateRecentlyUsedAccounts();
    // get username if it exists:
    User user = await sl.get<DBHelper>().getUserWithAddress(address);
    String walletUsername;
    if (user != null && user.username != null) {
      walletUsername = user.username;
    }
    setState(() {
      wallet = AppWallet(address: address, username: walletUsername, loading: true);
      requestUpdate();
      updateRequests();
    });
  }

  Future<void> updateRecentlyUsedAccounts() async {
    List<Account> otherAccounts = await sl.get<DBHelper>().getRecentlyUsedAccounts(await getSeed());
    if (otherAccounts != null && otherAccounts.length > 0) {
      if (otherAccounts.length > 1) {
        setState(() {
          recentLast = otherAccounts[0];
          recentSecondLast = otherAccounts[1];
        });
      } else {
        setState(() {
          recentLast = otherAccounts[0];
          recentSecondLast = null;
        });
      }
    } else {
      setState(() {
        recentLast = null;
        recentSecondLast = null;
      });
    }
  }

  // Change language
  void updateLanguage(LanguageSetting language) {
    if (language != null && curLanguage != null && curLanguage.language != language.language) {
      checkAndUpdateAlerts();
    }
    setState(() {
      curLanguage = language;
    });
  }

  // Change block explorer
  void updateBlockExplorer(AvailableBlockExplorer explorer) {
    setState(() {
      curBlockExplorer = explorer;
    });
  }

  // Set encrypted secret
  void setEncryptedSecret(String secret) {
    setState(() {
      encryptedSecret = secret;
    });
  }

  // Reset encrypted secret
  void resetEncryptedSecret() {
    setState(() {
      encryptedSecret = null;
    });
  }

  // Change theme
  void updateTheme(ThemeSetting theme, {bool setIcon = true}) {
    setState(() {
      curTheme = theme.getTheme();
      if (curTheme is NyanTheme) {
        // TODO: make toggle-able individually later
        // nyaniconOn = true;
        nyanoMode = true;
      } else {
        // nyaniconOn = false;
        nyanoMode = false;
      }
    });
    if (setIcon) {
      AppIcon.setAppIcon(theme.getTheme().appIcon);
    }
  }

  // Change natricon setting
  void setNatriconOn(bool natriconOn) {
    setState(() {
      this.natriconOn = natriconOn;
    });
  }

  // Change nyanicon setting
  void setNyaniconOn(bool nyaniconOn) {
    setState(() {
      this.nyaniconOn = nyaniconOn;
    });
  }

  // Change min raw setting
  void setMinRawReceive(String minRaw) {
    setState(() {
      this.receiveThreshold = minRaw;
    });
  }

  void disconnect() {
    sl.get<AccountService>().reset(suspend: true);
  }

  void reconnect() {
    sl.get<AccountService>().initCommunication(unsuspend: true);
  }

  void lockCallback() {
    _locked = true;
  }

  void unlockCallback() {
    _locked = false;
  }

  ///
  /// When an error is returned from server
  ///
  Future<void> handleErrorResponse(ErrorResponse errorResponse) async {
    sl.get<AccountService>().processQueue();
    if (errorResponse.error == null) {
      return;
    }
  }

  /// Handle account_subscribe response
  void handleSubscribeResponse(SubscribeResponse response) {
    // get the preference for the receive threshold:
    sl.get<SharedPrefsUtil>().getMinRawReceive().then((String minRaw) {
      receiveThreshold = minRaw;
      // Combat spam by raising minimum receive if pending block count is large enough
      // only override the user preference if it was set to 0 (default)
      if (response.pendingCount != null && response.pendingCount > 50 && minRaw == "0") {
        // Bump min receive to 0.05 NANO
        receiveThreshold = BigInt.from(5).pow(28).toString();
      }
    });
    // Set currency locale here for the UI to access
    sl.get<SharedPrefsUtil>().getCurrency(deviceLocale).then((currency) {
      setState(() {
        currencyLocale = currency.getLocale().toString();
        curCurrency = currency;
      });
    });
    // Server gives us a UUID for future requests on subscribe
    if (response.uuid != null) {
      sl.get<SharedPrefsUtil>().setUuid(response.uuid);
    }
    EventTaxiImpl.singleton().fire(ConfirmationHeightChangedEvent(confirmationHeight: response.confirmationHeight));
    setState(() {
      wallet.loading = false;
      wallet.frontier = response.frontier;
      wallet.representative = response.representative;
      wallet.representativeBlock = response.representativeBlock;
      wallet.openBlock = response.openBlock;
      wallet.blockCount = response.blockCount;
      wallet.confirmationHeight = response.confirmationHeight;
      if (response.balance == null) {
        wallet.accountBalance = BigInt.from(0);
      } else {
        wallet.accountBalance = BigInt.tryParse(response.balance);
      }
      wallet.localCurrencyPrice = response.price.toString();
      wallet.btcPrice = response.btcPrice.toString();
      sl.get<AccountService>().pop();
      sl.get<AccountService>().processQueue();
    });
  }

  /// Handle callback response
  /// Typically this means we need to pocket transactions
  Future<void> handleCallbackResponse(CallbackResponse resp) async {
    if (_locked) {
      return;
    }
    log.d("Received callback ${json.encode(resp.toJson())}");
    if (resp.isSend != "true") {
      sl.get<AccountService>().processQueue();
      return;
    }
    PendingResponseItem pendingItem = PendingResponseItem(hash: resp.hash, source: resp.account, amount: resp.amount);
    String receivedHash = await handlePendingItem(pendingItem, link_as_account: resp.block.linkAsAccount);
    if (receivedHash != null) {
      AccountHistoryResponseItem histItem =
          AccountHistoryResponseItem(type: BlockTypes.RECEIVE, account: resp.account, amount: resp.amount, hash: receivedHash, link: resp.hash);
      log.d("Received histItem ${json.encode(histItem.toJson())}");
      if (!wallet.history.contains(histItem)) {
        setState(() {
          // TODO: not necessarily the best way to handle this, should get real height:
          histItem.height = wallet.confirmationHeight + 1;
          wallet.confirmationHeight += 1;
          wallet.history.insert(0, histItem);
          wallet.accountBalance += BigInt.parse(resp.amount);
          // Send list to home screen
          EventTaxiImpl.singleton().fire(HistoryHomeEvent(items: wallet.history));
          updateUnified(false);
        });
      }
    }
  }

  Future<String> handlePendingItem(PendingResponseItem item, {String link_as_account}) async {
    if (pendingRequests.contains(item.hash)) {
      return null;
    }
    pendingRequests.add(item.hash);
    BigInt amountBigInt = BigInt.tryParse(item.amount);
    sl.get<Logger>().d("Handling ${item.hash} pending");
    if (amountBigInt != null) {
      // don't process if under the receive threshold:
      if (amountBigInt < BigInt.parse(receiveThreshold)) {
        pendingRequests.remove(item.hash);
        return null;
      }
      // don't process if the user / address is blocked:
      if (await sl.get<DBHelper>().blockedExistsWithAddress(item.source)) {
        pendingRequests.remove(item.hash);
        log.d("Blocked send from address: ${item.source}");
        return null;
      }
    }

    // are we on the wrong account?
    if (link_as_account != null && link_as_account != wallet.address) {
      // we aren't on the current account for this receive:
      log.d("Receive is for a different account: ${link_as_account}");
      // HANDLE IT: 😔

      AccountInfoResponse accountResp = await sl.get<AccountService>().getAccountInfo(link_as_account);
      String seed = await getSeed();
      Account correctAccount;
      List<Account> accounts = await sl.get<DBHelper>().getAccounts(seed);
      for (int i = 0; i < accounts.length; i++) {
        if (accounts[i].address == link_as_account) {
          correctAccount = accounts[i];
          break;
        }
      }

      if (correctAccount == null) {
        log.d("Could not find account for ${link_as_account}");
        pendingRequests.remove(item.hash);
        return null;
      }

      String privKey = NanoUtil.seedToPrivate(seed, correctAccount.index);

      // publish open:
      if (accountResp.openBlock == null) {
        sl.get<Logger>().d("Handling ${item.hash} as open");
        try {
          ProcessResponse resp = await sl.get<AccountService>().requestOpen(item.amount, item.hash, link_as_account, privKey);
          wallet.openBlock = resp.hash;
          wallet.frontier = resp.hash;
          pendingRequests.remove(item.hash);
          alreadyReceived.add(item.hash);
          // don't add to history list since we're not on the current account
          // return resp.hash;
          return null;
        } catch (e) {
          pendingRequests.remove(item.hash);
          sl.get<Logger>().e("Error creating open", e);
        }
      } else {
        try {
          ProcessResponse resp =
              await sl.get<AccountService>().requestReceive(wallet.representative, accountResp.frontier, item.amount, item.hash, link_as_account, privKey);
          // wallet.frontier = resp.hash;
          pendingRequests.remove(item.hash);
          alreadyReceived.add(item.hash);
        } catch (e) {
          pendingRequests.remove(item.hash);
          sl.get<Logger>().e("Error creating receive", e);
        }
      }

      // receive any other pendings first?:
      //{
      // BigInt totalTransferred = BigInt.zero;
      // AccountBalanceItem balanceItem = new AccountBalanceItem();
      // // Get frontiers first
      // if (!accountResp.unopened) {
      //   balanceItem.frontier = accountResp.frontier;
      // }
      // // Receive pending blocks
      // PendingResponse pr = await sl.get<AccountService>().getPending(link_as_account, 20);
      // Map<String, PendingResponseItem> pendingBlocks = pr.blocks;
      // for (String hash in pendingBlocks.keys) {
      //   PendingResponseItem item = pendingBlocks[hash];
      //   if (balanceItem.frontier != null) {
      //     ProcessResponse resp = await sl
      //         .get<AccountService>()
      //         .requestReceive(AppWallet.defaultRepresentative, balanceItem.frontier, item.amount, hash, link_as_account, balanceItem.privKey);
      //     if (resp.hash != null) {
      //       balanceItem.frontier = resp.hash;
      //       totalTransferred += BigInt.parse(item.amount);
      //     }
      //   } else {
      //     ProcessResponse resp = await sl.get<AccountService>().requestOpen(item.amount, hash, link_as_account, balanceItem.privKey);
      //     if (resp.hash != null) {
      //       balanceItem.frontier = resp.hash;
      //       totalTransferred += BigInt.parse(item.amount);
      //     }
      //   }
      //   // Hack that waits for blocks to be confirmed
      //   await Future.delayed(const Duration(milliseconds: 300));
      // }
      //}

      // don't add to the history view since we're on the wrong account:
      return null;
      // throw Exception("Not on the correct account to receive this");
    } else if (wallet.openBlock == null) {
      // Publish open
      sl.get<Logger>().d("Handling ${item.hash} as open");
      try {
        ProcessResponse resp = await sl.get<AccountService>().requestOpen(item.amount, item.hash, wallet.address, await _getPrivKey());
        wallet.openBlock = resp.hash;
        wallet.frontier = resp.hash;
        pendingRequests.remove(item.hash);
        alreadyReceived.add(item.hash);
        return resp.hash;
      } catch (e) {
        pendingRequests.remove(item.hash);
        sl.get<Logger>().e("Error creating open", e);
      }
    } else {
      // Publish receive
      sl.get<Logger>().d("Handling ${item.hash} as receive");
      try {
        ProcessResponse resp =
            await sl.get<AccountService>().requestReceive(wallet.representative, wallet.frontier, item.amount, item.hash, wallet.address, await _getPrivKey());

        wallet.frontier = resp.hash;
        pendingRequests.remove(item.hash);
        alreadyReceived.add(item.hash);
        return resp.hash;
      } catch (e) {
        pendingRequests.remove(item.hash);
        sl.get<Logger>().e("Error creating receive", e);
      }
    }
    return null;
  }

  /// Request balances for accounts in our database
  Future<void> _requestBalances() async {
    List<Account> accounts = await sl.get<DBHelper>().getAccounts(await getSeed());
    List<String> addressToRequest = List();
    accounts.forEach((account) {
      if (account.address != null) {
        addressToRequest.add(account.address);
      }
    });
    AccountsBalancesResponse resp = await sl.get<AccountService>().requestAccountsBalances(addressToRequest);
    sl.get<DBHelper>().getAccounts(await getSeed()).then((accounts) {
      accounts.forEach((account) {
        resp.balances.forEach((address, balance) {
          String combinedBalance = (BigInt.tryParse(balance.balance) + BigInt.tryParse(balance.pending)).toString();
          if (address == account.address && combinedBalance != account.balance) {
            sl.get<DBHelper>().updateAccountBalance(account, combinedBalance);
          }
        });
      });
    });
  }

  Future<void> requestUpdate({bool pending = true}) async {
    if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
      String uuid = await sl.get<SharedPrefsUtil>().getUuid();
      String fcmToken;
      bool notificationsEnabled;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        notificationsEnabled = await sl.get<SharedPrefsUtil>().getNotificationsOn();
      } catch (e) {
        fcmToken = null;
        notificationsEnabled = false;
      }
      sl.get<AccountService>().clearQueue();
      sl.get<AccountService>().queueRequest(SubscribeRequest(
          account: wallet.address, currency: curCurrency.getIso4217Code(), uuid: uuid, fcmToken: fcmToken, notificationEnabled: notificationsEnabled));
      sl.get<AccountService>().queueRequest(AccountHistoryRequest(account: wallet.address, raw: true));
      sl.get<AccountService>().processQueue();
      // Request account history

      // Choose correct blockCount to minimize bandwidth
      // This is can still be improved because history excludes change/open, blockCount doesn't
      // Get largest count we have + 5 (just a safe-buffer)
      int count = 500;
      if (wallet.history != null && wallet.history.length > 1) {
        count = 50;
      }
      try {
        AccountHistoryResponse resp = await sl.get<AccountService>().requestAccountHistory(wallet.address, count: count, raw: true);
        _requestBalances();
        bool postedToHome = false;
        // Iterate list in reverse (oldest to newest block)
        for (AccountHistoryResponseItem item in resp.history) {
          // If current list doesn't contain this item, insert it and the rest of the items in list and exit loop
          if (!wallet.history.contains(item)) {
            int startIndex = 0; // Index to start inserting into the list
            int lastIndex = resp.history.indexWhere(
                (item) => wallet.history.contains(item)); // Last index of historyResponse to insert to (first index where item exists in wallet history)
            lastIndex = lastIndex <= 0 ? resp.history.length : lastIndex;
            setState(() {
              wallet.history.insertAll(0, resp.history.getRange(startIndex, lastIndex));
              // Send list to home screen
              EventTaxiImpl.singleton().fire(HistoryHomeEvent(items: wallet.history));
            });
            await updateUnified(true);
            postedToHome = true;
            break;
          }
        }
        setState(() {
          wallet.historyLoading = false;
        });
        if (!postedToHome) {
          EventTaxiImpl.singleton().fire(HistoryHomeEvent(items: wallet.history));
          await updateUnified(true);
        }

        sl.get<AccountService>().pop();
        sl.get<AccountService>().processQueue();
        // Receive pendings
        if (pending) {
          pendingRequests.clear();
          PendingResponse pendingResp = await sl.get<AccountService>().getPending(wallet.address, max(wallet.blockCount ?? 0, 10), threshold: receiveThreshold);

          // for unfulfilled payments:
          List<TXData> unfulfilledPayments = await sl.get<DBHelper>().getUnfulfilledTXs();

          // Initiate receive/open request for each pending
          for (String hash in pendingResp.blocks.keys) {
            PendingResponseItem pendingResponseItem = pendingResp.blocks[hash];
            pendingResponseItem.hash = hash;
            String receivedHash = await handlePendingItem(pendingResponseItem);
            if (receivedHash != null) {
              // payments:
              // check to see if this fulfills a payment request:

              for (int i = 0; i < unfulfilledPayments.length; i++) {
                TXData txData = unfulfilledPayments[i];
                // check destination of this request is where we're sending to:
                // check to make sure we made the request:
                // check to make sure the amounts are the same:
                if (txData.from_address == wallet.address &&
                    txData.to_address == pendingResponseItem.source &&
                    txData.amount_raw == pendingResponseItem.amount &&
                    txData.is_fulfilled == false) {
                  // this is the payment we're fulfilling
                  // update the TXData to be fulfilled
                  await sl.get<DBHelper>().changeTXFulfillmentStatus(txData.uuid, true);
                  // update the ui to reflect the change in the db:
                  await updateRequests();
                  await updateUnified(true);
                  break;
                }
              }

              AccountHistoryResponseItem histItem = AccountHistoryResponseItem(
                  type: BlockTypes.RECEIVE,
                  account: pendingResponseItem.source,
                  amount: pendingResponseItem.amount,
                  hash: receivedHash,
                  link: pendingResponseItem.hash);
              if (!wallet.history.contains(histItem)) {
                setState(() {
                  // TODO: not necessarily the best way to handle this, should get real height:
                  histItem.height = wallet.confirmationHeight + 1;
                  wallet.confirmationHeight += 1;
                  wallet.history.insert(0, histItem);
                  wallet.accountBalance += BigInt.parse(pendingResponseItem.amount);
                  // Send list to home screen
                  EventTaxiImpl.singleton().fire(HistoryHomeEvent(items: wallet.history));
                  updateUnified(true);
                });
              }
            }
          }
        }
      } catch (e) {
        // TODO handle account history error
        sl.get<Logger>().e("account_history e", e);
      }
    }
  }

  Future<void> requestSubscribe() async {
    if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
      String uuid = await sl.get<SharedPrefsUtil>().getUuid();
      String fcmToken;
      bool notificationsEnabled;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        notificationsEnabled = await sl.get<SharedPrefsUtil>().getNotificationsOn();
      } catch (e) {
        fcmToken = null;
        notificationsEnabled = false;
      }
      sl.get<AccountService>().removeSubscribeHistoryPendingFromQueue();
      sl.get<AccountService>().queueRequest(SubscribeRequest(
          account: wallet.address, currency: curCurrency.getIso4217Code(), uuid: uuid, fcmToken: fcmToken, notificationEnabled: notificationsEnabled));
      sl.get<AccountService>().processQueue();
    }
  }

  // handle data side of payment requests and other notifications:

  // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   // final Logger log = sl.get<Logger>();
  //   log.d("Handling a background message");
  //   // await handlePayments(message.data);
  //   handleMessage(message.data);
  // }

  // Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  //   // final Logger log = sl.get<Logger>();
  //   log.d("Handling a foreground message");
  //   log.d(message.data);
  //   handleMessage(message.data);
  // }

  Future<String> encryptMessage(String message, String recipientAddress, String privateKey) async {
    try {
      String builtExpression = "encrypt(\"$message\", \"$recipientAddress\", \"$privateKey\");";
      JsEvalResult jsResult = flutterJs.evaluate(builtExpression);
      return jsResult.stringResult;
    } catch (e) {
      sl.get<Logger>().e("encryptMessage error: ${e.toString()}");
      return null;
    }
  }

  Future<String> decryptMessage(String memo_enc, String senderAddress, String privateKey) async {
    try {
      String builtExpression = "decrypt(\"$memo_enc\", \"$senderAddress\", \"$privateKey\");";
      JsEvalResult jsResult = flutterJs.evaluate(builtExpression);
      return jsResult.stringResult;
    } catch (e) {
      sl.get<Logger>().e("decryptMessage error: ${e.toString()}");
      return null;
    }
  }

  Future<String> decryptMessageCurrentAccount(String memo_enc, String fromAddress, String toAddress) async {
    // decrypt the memo:
    Account correctAccount;
    // find the right account index:
    if (selectedAccount.address == toAddress) {
      correctAccount = selectedAccount;
    } else {
      String seed = await getSeed();
      List<Account> accounts = await sl.get<DBHelper>().getAccounts(seed);
      for (int i = 0; i < accounts.length; i++) {
        if (accounts[i].address == toAddress) {
          correctAccount = accounts[i];
          break;
        }
      }
    }

    if (correctAccount == null) {
      log.d("failed to decrypt memo!");
      return null;
    }

    String privKey = NanoUtil.seedToPrivate(await getSeed(), correctAccount.index);
    String memo = await decryptMessage(memo_enc, fromAddress, privKey);
    return memo;
  }

  Future<void> handlePaymentRequest(dynamic data) async {
    log.d("handling payment_request from: ${data['requesting_account']} : ${data['account']}");
    String amount_raw = data['amount_raw'];
    String requesting_account = data['requesting_account'];
    String memo_enc = data['memo_enc'];
    String request_time = data['request_time'];
    String to_address = data['account'];
    String uuid = data['uuid'];
    String local_uuid = data['local_uuid'];

    if (wallet == null || wallet.address == null || !Address(wallet.address).isValid()) {
      throw Exception("wallet or wallet.address is null!");
    }

    int currentBlockHeightInList = wallet.history?.length > 0 ? (wallet?.history[0]?.height + 1) : 1;
    String lastBlockHash = wallet?.history?.length > 0 ? wallet?.history[0]?.hash : null;

    var txData = new TXData(
      amount_raw: amount_raw,
      is_request: true,
      is_memo: false,
      from_address: requesting_account,
      to_address: to_address,
      is_fulfilled: false,
      request_time: request_time,
      block: lastBlockHash,
      uuid: uuid,
      is_acknowledged: false,
      height: currentBlockHeightInList,
    );

    // decrypt the memo:
    if (memo_enc != null && memo_enc.isNotEmpty) {
      String memo = await decryptMessageCurrentAccount(memo_enc, requesting_account, to_address);
      if (memo != null) {
        txData.memo = memo;
      } else {
        // TODO: figure out how to get localized string here:
        txData.memo = "Decryption Error!";
        txData.memo_enc = memo_enc;
      }
    }

    // check if exists in db:
    var existingTXData = await sl.get<DBHelper>().getTXDataByUUID(uuid);
    if (existingTXData != null) {
      // update with the new info:
      existingTXData.is_acknowledged = true;
      existingTXData.request_time = request_time;
      print("replacing TXData");
      await sl.get<DBHelper>().replaceTXDataByUUID(existingTXData);
    } else {
      print("adding TXData to db");
      // add it since it doesn't exist:
      await sl.get<DBHelper>().addTXData(txData);
    }

    // check for the local uuid just in case:
    if (local_uuid != null && local_uuid.isNotEmpty && local_uuid.contains("LOCAL")) {
      var localTXData = await sl.get<DBHelper>().getTXDataByUUID(local_uuid);
      if (localTXData != null) {
        // remove it:
        await sl.get<DBHelper>().deleteTXDataByUUID(local_uuid);
      }
    }

    // send acknowledgement to server / requester:
    await sl.get<AccountService>().requestACK(uuid, requesting_account, wallet.address);

    await updateRequests();
    await updateUnified(false);
  }

  Future<void> handlePaymentRecord(dynamic data) async {
    print("handling payment_record from: ${data['requesting_account']} : ${data['account']}");
    String amount_raw = data['amount_raw'];
    String requesting_account = data['requesting_account'];
    String memo_enc = data['memo_enc'];
    String request_time = data['request_time'];
    String to_address = data['account'];
    String fulfillment_time = data['fulfillment_time'];
    String block = data['block'];
    String uuid = data['uuid'];
    String local_uuid = data['local_uuid'];

    if (data.containsKey("is_request")) {
      if (wallet != null && wallet.address != null && Address(wallet.address).isValid()) {
        TXData txData;
        TXData oldTXData;

        // we have to check if this payment is already in the db:
        txData = await sl.get<DBHelper>().getTXDataByUUID(uuid);
        if (txData != null) {
          print("replacing existing txData for record!");
          // this payment is already in the db:
          // merge the two TXData objects;
          TXData newTXInfo = txData;
          newTXInfo.amount_raw = amount_raw;
          newTXInfo.from_address = requesting_account;
          newTXInfo.to_address = to_address;
          // newTXInfo.block = block;// don't overwrite the block
          // newTXInfo.memo = memo;
          newTXInfo.request_time = request_time;

          if (memo_enc != null && memo_enc.isNotEmpty) {
            String memo = await decryptMessageCurrentAccount(memo_enc, requesting_account, to_address);
            if (memo != null) {
              newTXInfo.memo = memo;
            } else {
              // TODO: figure out how to get localized string here:
              newTXInfo.memo = "Decryption Error!";
              newTXInfo.memo_enc = memo_enc;
            }
          }

          await sl.get<DBHelper>().replaceTXDataByUUID(newTXInfo);
        }

        // is this from us? if so we need to check for the local version of this payment_request:

        // check if this is a local payment_request:
        if (local_uuid != null && local_uuid.isNotEmpty && local_uuid.contains("LOCAL")) {
          oldTXData = await sl.get<DBHelper>().getTXDataByUUID(local_uuid);

          // if (requesting_account == wallet.address) {
          // var transactions = await sl.get<DBHelper>().getAccountSpecificRequests(wallet.address);
          // // go through the list and see if any of them happened within the last 5 minutes:
          // // make sure all other fields match, too:

          // print("${wallet.address} : ${to_address} : ${amount_raw}");
          // for (var tx in transactions) {
          //   // make sure we only delete local requests that were within the last 5 minutes:
          //   if (tx.uuid.contains("LOCAL")) {
          //     // print("${tx.from_address} : ${tx.to_address} : ${tx.amount_raw} : ${tx.uuid}");
          //     // make sure this is the request we made:
          //     if (tx.from_address == wallet.address && tx.to_address == to_address && tx.amount_raw == amount_raw) {
          //       if (DateTime.parse(tx.request_time).isAfter(DateTime.now().subtract(Duration(minutes: 5)))) {
          //         // this is a duplicate payment record, delete it:
          //         oldTXData = tx;
          //         // print("found a local payment record that is within the last 5 minutes");
          //         break;
          //       }
          //     }
          //   }
          // }

          if (oldTXData != null) {
            print("removing old txData!");
            // remove the old tx by the uuid:
            await sl.get<DBHelper>().deleteTXDataByUUID(oldTXData.uuid);

            // if we didn't replace an existing txData, add it to the db:
            if (txData == null) {
              // add it since it doesn't exist:
              print("adding payment_record to db");
              oldTXData.uuid = uuid;
              oldTXData.request_time = request_time;
              await sl.get<DBHelper>().addTXData(oldTXData);
            }
          }
        }

        // we didn't replace a txData??
        if (txData == null && oldTXData == null) {
          // log.d("adding txData to the database!");
          throw new Exception("\n\n@@@@@@@@this shouldn't happen!@@@@@@@@@@\n\n");
        }
        await updateRequests();
        await updateUnified(true);
      }
    }

    if (data.containsKey("is_memo")) {
      // check if exists in db:
      var existingTXData = await sl.get<DBHelper>().getTXDataByBlock(block);

      if (existingTXData == null) {
        // check if there is a local payment_memo since we didn't find it by block:
        // this case probably only happens on a slow network connection, if at all:
        if (local_uuid != null && local_uuid.isNotEmpty && local_uuid.contains("LOCAL")) {
          print("memo block wasn't found while processing payment_record!");
          existingTXData = await sl.get<DBHelper>().getTXDataByUUID(local_uuid);
        }
      }

      if (existingTXData != null) {
        // print("memo block exists");
        // delete local version and add new one:
        // existingTXData.memo = memo;
        existingTXData.block = block;
        // remove the local one if it exists:
        if (existingTXData.uuid.contains("LOCAL")) {
          print("removing the local txData for this memo: ${existingTXData.uuid}");
          await sl.get<DBHelper>().deleteTXDataByUUID(existingTXData.uuid);
          await sl.get<DBHelper>().deleteTXDataByBlock(existingTXData.block);
          // add the new one and change the uuid to be not local:
          existingTXData.uuid = uuid;
          existingTXData.status = "sent";
          await sl.get<DBHelper>().addTXData(existingTXData);
        } else {
          print("updating the txData for this memo");
          // we updated the other fields up above, so we don't need to update them here:
          // TODO: should check to make sure uuid matches:
          await sl.get<DBHelper>().replaceTXDataByUUID(existingTXData);
          // send acknowledgement to server / requester:
          // sleep for a second to make sure the txData is updated:
          await Future.delayed(Duration(seconds: 1));
          await sl.get<AccountService>().requestACK(uuid, requesting_account, wallet.address);
        }
      } else {
        throw Exception("no txData found for this memo in payment record!");
      }
    }
  }

  Future<void> handlePaymentMemo(dynamic data) async {
    print("handling payment_memo from: ${data['requesting_account']} : ${data['account']}");
    // String amount_raw = data['amount_raw'];
    String requesting_account = data['requesting_account'];
    String to_address = data['account'];
    String memo_enc = data['memo_enc'];
    String request_time = data['request_time'];
    String block = data['block'];
    String is_acknowledged = data['is_acknowledged'];
    int height = data['height'];
    String uuid = data['uuid'];
    String local_uuid = data['local_uuid'];

    TXData txData = new TXData(
      // amount_raw: amount_raw,
      is_request: false,
      is_memo: true,
      from_address: requesting_account,
      to_address: to_address,
      is_fulfilled: true,
      block: block,
      link: null,
      uuid: uuid,
      is_acknowledged: false,
      height: height,
    );

    // attempt to decrypt the memo:
    if (memo_enc != null && memo_enc.isNotEmpty) {
      String memo = await decryptMessageCurrentAccount(memo_enc, requesting_account, to_address);
      if (memo != null) {
        txData.memo = memo;
      } else {
        // TODO: figure out how to get localized string here:
        txData.memo = "Decryption Error!";
        txData.memo_enc = memo_enc;
      }
    }

    bool found = false;
    // loop through our tx history to find the first matching block:
    for (var histItem in wallet.history) {
      if (histItem.link == block) {
        // found a matching transaction, so set the block to that:
        txData.link = histItem.hash;
        found = true;
        break;
      }
    }

    // check if exists in db:
    var existingTXData = await sl.get<DBHelper>().getTXDataByUUID(uuid);
    if (existingTXData != null) {
      print("memo txData exists");
      // update with the new info:
      existingTXData.block = txData.block;
      if (found) {
        existingTXData.link = txData.link;
      }
      existingTXData.is_acknowledged = true;
      // just in case:
      existingTXData.to_address = txData.to_address;
      existingTXData.from_address = txData.from_address;
      await sl.get<DBHelper>().replaceTXDataByUUID(existingTXData);
    } else {
      print("adding memo txData to the database!");
      // TODO: check for duplicates and remove them:
      // add it since it doesn't exist in the db:
      await sl.get<DBHelper>().addTXData(txData);
    }

    // check for local_uuid just incase:
    if (local_uuid != null && local_uuid.isNotEmpty && local_uuid.contains("LOCAL")) {
      // check if there is a local payment_memo:
      var localTXData = await sl.get<DBHelper>().getTXDataByUUID(local_uuid);
      if (localTXData != null) {
        // delete the local one:
        await sl.get<DBHelper>().deleteTXDataByUUID(local_uuid);
      }
    }
    // send acknowledgement to server / requester:
    await sl.get<AccountService>().requestACK(uuid, requesting_account, wallet.address);
    await updateRequests();
    await updateTXMemos();
  }

  Future<void> handleMessage(dynamic data) async {
    // handle an incoming payment request:
    if (data.containsKey("payment_request")) {
      await handlePaymentRequest(data);
    }

    // handle an incoming memo:
    if (data.containsKey("payment_memo")) {
      await handlePaymentMemo(data);
    }

    // payment records are essentially server copies of local txData:
    if (data.containsKey("payment_record")) {
      await handlePaymentRecord(data);
    }

    if (data.containsKey("payment_ack")) {
      // print("handling payment_ack from: ${data['requesting_account']}");
      print("handling payment_ack");
      String amount_raw = data['amount_raw'];
      String requesting_account = data['requesting_account'];
      String memo = data['memo'];
      String request_time = data['request_time'];
      String to_address = data['account'];
      String uuid = data['uuid'];
      String block = data['block'];
      String is_acknowledged = data['is_acknowledged'];
      int height = data['height'];

      // sleep to prevent animations from overlapping:
      await Future.delayed(Duration(seconds: 2));

      // set acknowledged to true:
      var txData = await sl.get<DBHelper>().getTXDataByUUID(uuid);
      if (txData != null) {
        await sl.get<DBHelper>().changeTXAckStatus(uuid, true);
        print("changed ack status!");
      } else {
        print("we didn't have a txData for this payment ack!");
      }
      await updateRequests();
      await updateUnified(true);
    }
  }

  void logOut() {
    setState(() {
      wallet = AppWallet();
      encryptedSecret = null;
    });
    sl.get<DBHelper>().dropAccounts();
    sl.get<AccountService>().clearQueue();
  }

  Future<String> _getPrivKey() async {
    String seed = await getSeed();
    return NanoUtil.seedToPrivate(seed, selectedAccount.index);
  }

  Future<String> getSeed() async {
    String seed;
    if (encryptedSecret != null) {
      seed = NanoHelpers.byteToHex(NanoCrypt.decrypt(encryptedSecret, await sl.get<Vault>().getSessionKey()));
    } else {
      seed = await sl.get<Vault>().getSeed();
    }
    return seed;
  }

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
