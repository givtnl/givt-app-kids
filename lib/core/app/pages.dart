enum Pages {
  splash(path: '/', name: 'SPLASH'),
  login(path: '/login', name: 'LOGIN'),
  profileSelection(path: '/profile-selection', name: 'PROFILE_SELECTION'),
  wallet(path: '/wallet', name: 'WALLET'),
  camera(path: '/camera', name: 'CAMERA'),
  success(path: '/success', name: 'SUCCESS'),
  chooseAmountSlider(
      path: '/choose-amount-slider', name: 'CHOOSE_AMOUNT_SLIDER'),
  test(path: '/test', name: 'TEST'),
  scanNFC(path: '/scan-nfc', name: 'SCAN_NFC'),
  history(path: '/history', name: 'HISTORY'),
  avatarSelection(path: '/avatar-selection', name: 'AVATAR_SELECTION'),

  //recommendation flow
  recommendationStart(
      path: '/recommendation-start', name: 'RECOMMENDATION_START'),
  locationSelection(path: '/location-selection', name: 'LOCATION_SELECTION'),
  interestsSelection(path: '/interests-selection', name: 'INTERESTS_SELECTION'),
  recommendedOrganisations(path: '/organisations', name: 'ORGANISATIONS'),

  //coin flow
  searchForCoin(path: '/search-for-coin', name: 'SEARCH_FOR_COIN'),
  outAppCoinFlow(path: '/out-app-coin-flow', name: 'OUT_APP_COIN_FLOW'),
  successCoin(path: '/success-coin', name: 'SUCCESS_COIN'),
  redirectPopPage(path: '/redirect-pop-page', name: 'REDIRECT_POP_PAGE'),

  //exhibition flow
  voucherCodeScreen(path: '/voucher-code-screen', name: 'VOUCHER_CODE_SCREEN'),
  exhibitionOrganisations(
      path: '/exhibition-organisations', name: 'EXHIBITION_ORGANISATIONS'),
  successExhibitionCoin(
      path: '/success-exhibition-coin', name: 'SUCCESS_EXHIBITION_COIN'),
  ;

  final String path;
  final String name;

  const Pages({
    required this.path,
    required this.name,
  });
}
