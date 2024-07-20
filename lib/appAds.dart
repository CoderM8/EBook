import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

import 'consttants.dart';

String get getBannerAdUnitId {
  if (Platform.isIOS) {
    return bannerIOS.value;
  } else if (Platform.isAndroid) {
    return bannerAndroid.value;
  }
  return 'Platform Exception';
}

RxString openAdIdAndroid = ''.obs;
RxString openAdIdIOS = ''.obs;

RxString bannerIOS = ''.obs;
RxString bannerAndroid = ''.obs;
RxString interstitialAndroid = ''.obs;
RxString interstitialIOS = ''.obs;
InterstitialAd? interstitialAd;
bool openAdLoad = false;
AppOpenAd? appOpenAd;

void showInterstitialAdOnClickEvent() {
  if (clickCount.value == int.parse(interstitialAdClick)) {
    print('show ad success :: ❓❓❓❓');
    AdmobAds().showInterstitialAd();
    isLoopActive.value = true;
    clickCount.value = 0;
  } else {
    print('click count :: ${clickCount.value}');
    clickCount.value++;
  }
}

RxInt clickCount = 0.obs;
RxBool isLoopActive = false.obs;
String interstitialAdClick = '';

getAdData() async {
  await MobileAds.instance.initialize();
  try {
    final response = await http.get(Uri.parse(apiLink + 'api.php?method_name=app_details'));
    if (response.statusCode == 200) {
      var finalResponse = jsonDecode(response.body);
      privacypolicy = finalResponse['EBOOK_APP'][0]['app_privacy_policy'];

      interstitialAdClick = finalResponse['EBOOK_APP'][0]['interstital_ad_click'];

      if (finalResponse['EBOOK_APP'][0]['banner_ad_id_ios_status'] == '1') {
        bannerIOS.value = finalResponse['EBOOK_APP'][0]['banner_ad_id_ios'];
      }
      if (finalResponse['EBOOK_APP'][0]['banner_ad_id_status'] == '1') {
        bannerAndroid.value = finalResponse['EBOOK_APP'][0]['banner_ad_id'];
      }
      if (finalResponse['EBOOK_APP'][0]['interstital_ad_id_status'] == '1') {
        interstitialAndroid.value = finalResponse['EBOOK_APP'][0]['interstital_ad_id'];
      }
      if (finalResponse['EBOOK_APP'][0]['interstital_ad_id_ios_status'] == '1') {
        interstitialIOS.value = finalResponse['EBOOK_APP'][0]['interstital_ad_id_ios'];
      }
      if (finalResponse['EBOOK_APP'][0]['app_open_ad_id_status'] == '1') {
        openAdIdAndroid.value = finalResponse['EBOOK_APP'][0]['app_open_ad_id'];
      }
      if (finalResponse['EBOOK_APP'][0]['ios_app_open_ad_id_status'] == '1') {
        openAdIdIOS.value = finalResponse['EBOOK_APP'][0]['ios_app_open_ad_id'];
      }

      privacypolicy = finalResponse['EBOOK_APP'][0]["app_privacy_policy"];
    } else {
      print("Response of body ==${null}");
    }
    print('this is indastial add id :: ${intersTitleAd}');
    AdmobAds().loadAppOpenAd();
    AdmobAds().bannerAds();
    AdmobAds().createInterstitialAd();
  } catch (e) {
    print('error in get data $e');
  }
}

String get intersTitleAd {
  if (Platform.isIOS) {
    return interstitialIOS.value;
  } else if (Platform.isAndroid) {
    return interstitialAndroid.value;
  }
  return 'Platform Exception';
}

String? openAd() {
  if (Platform.isIOS) {
    return openAdIdIOS.value;
  } else if (Platform.isAndroid) {
    return openAdIdAndroid.value;
  }
  return null;
}

class AdmobAds {
  Widget bannerAds() {
    final googleBannerAd = BannerAd(
      adUnitId: getBannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    )..load();
    return Container(
      alignment: Alignment.bottomCenter,
      width: googleBannerAd.size.width.toDouble(),
      height: googleBannerAd.size.height.toDouble(),
      child: AdWidget(ad: googleBannerAd),
    );
  }

  loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: openAd()!, //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
        appOpenAd = ad;
        openAdLoad = true;
        print('open add loaded $openAdLoad');
      }, onAdFailedToLoad: (error) {
        print('adds benner errorr  ====> ${error.message}');
        print('adds benner errorr all ====> ${error}');
      }),
    );
  }

  int maxFailedLoadAttempts = 3;
  int numInterstialAdLoadAttempt = 0;

  static final AdRequest request = AdRequest(
    keywords: ['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? createInterstitialAd() {
    try {
      InterstitialAd.load(
          // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
          adUnitId: intersTitleAd,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              interstitialAd = ad;
              maxFailedLoadAttempts = 0;
              interstitialAd!.setImmersiveMode(true);
              print('add load success :: 👌👌');
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('add load failed :: 👌👌 :: ${error.message}');
              numInterstialAdLoadAttempt += 1;
              if (numInterstialAdLoadAttempt < maxFailedLoadAttempts) {
                AdmobAds().createInterstitialAd();
              }
            },
          ));
    } catch (e) {
      print("error ad load :: 🤢🤢🤢 :: ${e}");
    }
    return null;
  }

  /// Show IntertitialAd
  void showInterstitialAd() {
    if (interstitialAd == null) {
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
        print('failed to load :: InterstitialAd add :: ${error.message}');
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }
}
