/// Centralized app strings.
///
/// This is a temporary, non-localized string source. Once
/// `AppLocalizations` is wired up (via `flutter gen-l10n`), replace the
/// values below with calls to `AppLocalizations.of(context)!.xxx` inside
/// each getter/method that needs it — call sites elsewhere in the app
/// (e.g. `validators.dart`) won't need to change, since they already
/// pass `BuildContext` through.
class AppStrings {
  AppStrings._();

  // ─────────────────────────────────────────────
  // Generic
  // ─────────────────────────────────────────────

  static const String textFieldErrorEmpty = 'This field is required';

  // ─────────────────────────────────────────────
  // Email
  // ─────────────────────────────────────────────

  static const String emailIsRequired = 'Email is required';
  static const String textFieldWrongEmail = 'Enter a valid email address';

  // ─────────────────────────────────────────────
  // Password
  // ─────────────────────────────────────────────

  static const String passwordLogin = 'Password is required';

  static const String passwordMustHave8Char =
      'Password must be at least 8 characters';

  static const String passwordMustHaveUpperChar =
      'Password must contain an uppercase letter';

  static const String passwordMustHaveLowerChar =
      'Password must contain a lowercase letter';

  static const String passwordMustHaveNum =
      'Password must contain a number';

  static const String passwordMustHaveSpecialChar =
      'Password must contain a special character';

  static const String passwordMismatch =
      'Passwords do not match';

  // ─────────────────────────────────────────────
  // List Your Property
  // ─────────────────────────────────────────────

  static const String listYourPropertyTitle = 'List Your Property';

  static const String listYourPropertyStep1 = 'Step 1 of 6';

  static const String listYourPropertyPage2Title = 'Location Details';

  static const String listYourPropertyStep2 = 'Step 2 of 6';

  static const String listYourPropertyStep3 = 'Step 3 of 6';

  static const String listYourPropertyStep4 = 'Step 4 of 6';

  // ─────────────────────────────────────────────
  // Property Type
  // ─────────────────────────────────────────────

  static const String whatAreYouListing = 'What are you listing?';

  static const String forSale = 'For Sale';

  static const String forRent = 'For Rent';

  static const String propertyType = 'Property Type';

  static const String propertyApartment = 'Apartment';

  static const String propertyHouse = 'House';

  static const String propertyVilla = 'Villa';

  static const String propertyLand = 'Land';

  static const String propertyShop = 'Shop';

  static const String propertyOther = 'Other';

  static const String specifyPropertyType =
      'Specify property type';

  static const String specifyPropertyTypeHint =
      'e.g. Studio, Farm...';

  static const String continueText = 'Continue';

  // ─────────────────────────────────────────────
  // Property Location & Details
  // ─────────────────────────────────────────────

  static const String city = 'City';

  static const String district = 'District';

  static const String buildingNumber = 'Building Number';

  static const String area = 'Area (m²)';

  static const String price = 'Price';

  static const String floor = 'Floor';

  static const String rooms = 'Rooms';

  static const String bathrooms = 'Bathrooms';

  static const String buildingNumberHint = 'e.g. 12';

  static const String areaHint = 'e.g. 150';

  static const String priceHint = 'e.g. 85000';

  static const String floorHint = 'e.g. 3';

  // ─────────────────────────────────────────────
  // Property Features
  // ─────────────────────────────────────────────

  static const String elevator = 'Elevator';

  static const String parking = 'Parking';

  static const String electricity = 'Electricity';

  static const String wifi = 'Internet';

  static const String water = 'Water';

  static const String furnished = 'Furnished';

  static const String garden = 'Garden';

  static const String description = 'Description';

  static const String descriptionHint =
      'Tell buyers about the property — layout, condition, nearby landmarks...';

  static const String features = 'Features';

  // ─────────────────────────────────────────────
  // Property Photos
  // ─────────────────────────────────────────────

  static const String propertyPhotos = 'Property Photos';

  static const String addPhotosDescription =
      'Add at least 3 photos. Tap a photo to set it as the cover.';

  static const String add = 'Add';

  static const String jod = 'JOD';

  // ─────────────────────────────────────────────
  // Onboarding
  // ─────────────────────────────────────────────

  static const String onboardingTitle =
      ' Find Your Dream \nHome on the Go';

  static const String onboardingSubtitle =
      "Scroll, Select, and Let's Settle In!";

  // ─────────────────────────────────────────────
  // Authentication
  // ─────────────────────────────────────────────

  static const String continueWithEmail =
      'Continue with Email';

  static const String continueWithPhone =
      ' With Phone Number';

  static const String alreadyHaveAccount =
      'Already have an account?';

  static const String signIn = 'Sign in';

  static const String enterEmail = 'Enter Email';

  static const String emailHintText =
      'example@mail.com';

  static const String sendCode = 'Send Code';

  static const String getStarted =
      'Let\'s get started!';

  static const String enterYourEmailAdd =
      'Enter your email address to create your account';

  static const String featureNotAvailable =
      'Feature Unavailable';

  static const String featureWillBeAvailbleLater =
      'This feature is currently not available. Please try again later.';

  // ─────────────────────────────────────────────
  // Verification
  // ─────────────────────────────────────────────

  static const String codeSent = 'Code Sent!';

  static const String checkEmailForVerificationCode =
      'Check your Email for the verification code';

  static const String welcomeBack = 'Welcome back!';
  static const String signInToContinueSearch = 'Sign in to continue your search';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signUp = 'Sign up';

  static const String enterPhoneNumberToSignIn =
      'Enter your phone number to sign in your account';
  static const String enterPhoneNumber = 'Enter Phone Number';

  static const String enterEmailAddressToSignIn =
      'Enter your email address to sign in your account';
  static const String emailHint = 'example@mail.com';
  static const String letGetStarted = "You're in! Let's get started";
  static const String welcomeToWathiq = 'Welcome to Wathiq' ;
  static const String pleaseEnterFullOtp = 'Please enter the full OTP';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  static const String verificationFailed = 'Verification failed';
// ─────────────────────────────────────────────
// OTP
// ─────────────────────────────────────────────

  static const String enterCode = 'Enter Code';

  static const String otpVerificationInstruction =
      'We sent a 6-digit verification code to your email. Please enter it below.';

  static const String verifyAndProceed = 'Verify and Proceed';

  static const String didntReceiveCode = "Didn't receive the code?";

  static const String resend = 'Resend';

// ─────────────────────────────────────────────
// Error Messages
// ─────────────────────────────────────────────

  static const String emailNotRegistered =
      'This email is not registered. Please register first';

  static const String emailAlreadyRegistered =
      'This email is already registered. Please login instead';

  static const String otpExpiredOrInvalid =
      'This code has expired or is invalid. Please request a new one';

  static const String tooManyAttempts =
      'Too many attempts. Please wait before trying again';

  static const String otpExpired =
      'This code has expired. Please request a new one';

  static const String incorrectOtp =
      'The code you entered is incorrect';

  static const String accountSuspended =
      'Your account has been suspended';

  static const String checkInternetConnection =
      'Check your internet connection and try again';

  static String tooManyAttemptsWithRetry(int retryAfter) =>
      'Too many attempts. Please wait ${retryAfter}s before trying again';

  static const String home = 'Home';

  static const String search = 'Search';

  static const String favourite = 'Favourite';

  static const String profile = 'Profile';

  static const String hello = 'Hello';
  static const String findYourPerfectProperty =
      'Find Your Perfect Property';

  static const String buySellOrRent =
      'Buy, sell, or rent verified properties with confidence.';

  static const String getStartedHome = 'Get Started';

  static const String searchByLocation =
      'Search by location';


  static const String allProperties = 'All Properties';
  static const String viewAll = 'View all';

  static const String apartmentThreeRooms =
      'Apartment — 3 rooms';

  static const String ramallah = 'Ramallah';
  static const String alBireh = 'Al-Bireh';

  static const String threeRooms = '3 rooms';
  static const String eightyFiveThousandJod = '85,000 JOD';
  static const String myProperties = 'My Properties';
  static const String addNewProperty = 'Add New';
  static const String propertiesListedCount = 'Properties Listed';
  static const String allStatus = 'All Status';
  static const String editProperty = 'Edit Property';
  static const String deleteProperty = 'Delete Property';
  static const String editAction = 'Edit';
  static const String deleteAction = 'Delete';
  static const String saveAction = 'Save';
  static const String discardChanges = 'Discard Changes';
  static const String deleteThisProperty = 'Delete this property';
  static const String cancelAction = 'Cancel';
  static const String viewDetails = 'View Details';
  static const String listingType = 'Listing Type';
  static const String propertyEditedSuccessfully =
      'Property Edited Successfully';
  static const String propertyDeletedSuccessfully =
      'Property Deleted Successfully';
  static const String listingActive = 'Active';
  static const String listingInactive = 'Inactive';
  static const String statusActive = 'Active';
  static const String statusReview = 'Review';
  static const String statusRejected = 'Rejected';
  static const String statusSuspended = 'Suspended';
  static const String deletePropertyWarning =
      'This action cannot be undone. Are you sure you want to delete this property?';
}