enum Pages {
  splash(path: '/', name: 'SPLASH'),
  login(path: '/login', name: 'LOGIN'),
  profileSelection(path: '/profile-selection', name: 'PROFILE_SELECTION'),
  wallet(path: '/wallet', name: 'WALLET'),
  camera(path: '/camera', name: 'CAMERA'),
  success(path: '/success', name: 'SUCCESS'),
  recommend(path: '/recommend', name: 'RECOMMEND'),
  chooseAmountSlider(
      path: '/choose-amount-slider', name: 'CHOOSE_AMOUNT_SLIDER'),
  test(path: '/test', name: 'TEST'),
  scanNFC(path: '/scan-nfc', name: 'SCAN_NFC'),
  history(path: '/history', name: 'HISTORY'),
  //coin flow
  searchForCoin(path: '/search-for-coin', name: 'SEARCH_FOR_COIN'),
  outAppCoinFlow(path: '/out-app-coin-flow', name: 'OUT_APP_COIN_FLOW'),
  successCoin(path: '/success-coin', name: 'SUCCESS_COIN'),
  redirectPopPage(path: '/redirect-pop-page', name: 'REDIRECT_POP_PAGE'),
  ;

  final String path;
  final String name;

  const Pages({
    required this.path,
    required this.name,
  });
}
