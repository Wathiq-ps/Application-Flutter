import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @textFieldErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get textFieldErrorEmpty;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @textFieldWrongEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get textFieldWrongEmail;

  /// No description provided for @passwordLogin.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordLogin;

  /// No description provided for @passwordMustHave8Char.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMustHave8Char;

  /// No description provided for @passwordMustHaveUpperChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain an uppercase letter'**
  String get passwordMustHaveUpperChar;

  /// No description provided for @passwordMustHaveLowerChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a lowercase letter'**
  String get passwordMustHaveLowerChar;

  /// No description provided for @passwordMustHaveNum.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a number'**
  String get passwordMustHaveNum;

  /// No description provided for @passwordMustHaveSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a special character'**
  String get passwordMustHaveSpecialChar;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @listYourPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'List Your Property'**
  String get listYourPropertyTitle;

  /// No description provided for @listYourPropertyStep1.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 6'**
  String get listYourPropertyStep1;

  /// No description provided for @listYourPropertyPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get listYourPropertyPage2Title;

  /// No description provided for @listYourPropertyPage5Title.
  ///
  /// In en, this message translates to:
  /// **'Proof of Ownership'**
  String get listYourPropertyPage5Title;

  /// No description provided for @listYourPropertyPage6Title.
  ///
  /// In en, this message translates to:
  /// **'Review your listing'**
  String get listYourPropertyPage6Title;

  /// No description provided for @listYourPropertyStep2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 6'**
  String get listYourPropertyStep2;

  /// No description provided for @listYourPropertyStep3.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 6'**
  String get listYourPropertyStep3;

  /// No description provided for @listYourPropertyStep4.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 6'**
  String get listYourPropertyStep4;

  /// No description provided for @listYourPropertyStep5.
  ///
  /// In en, this message translates to:
  /// **'Step 5 of 6'**
  String get listYourPropertyStep5;

  /// No description provided for @listYourPropertyStep6.
  ///
  /// In en, this message translates to:
  /// **'Step 6 of 6'**
  String get listYourPropertyStep6;

  /// No description provided for @whatAreYouListing.
  ///
  /// In en, this message translates to:
  /// **'What are you listing?'**
  String get whatAreYouListing;

  /// No description provided for @forSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get forSale;

  /// No description provided for @forRent.
  ///
  /// In en, this message translates to:
  /// **'For Rent'**
  String get forRent;

  /// No description provided for @propertyType.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get propertyType;

  /// No description provided for @propertyApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartment'**
  String get propertyApartment;

  /// No description provided for @propertyHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get propertyHouse;

  /// No description provided for @propertyVilla.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get propertyVilla;

  /// No description provided for @propertyLand.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get propertyLand;

  /// No description provided for @propertyShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get propertyShop;

  /// No description provided for @propertyOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get propertyOther;

  /// No description provided for @specifyPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Specify property type'**
  String get specifyPropertyType;

  /// No description provided for @specifyPropertyTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Studio, Farm...'**
  String get specifyPropertyTypeHint;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @buildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Building Number'**
  String get buildingNumber;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area (m²)'**
  String get area;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @latitudeHint.
  ///
  /// In en, this message translates to:
  /// **'latitude'**
  String get latitudeHint;

  /// No description provided for @longitudeHint.
  ///
  /// In en, this message translates to:
  /// **'longitude'**
  String get longitudeHint;

  /// No description provided for @buildingNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 12'**
  String get buildingNumberHint;

  /// No description provided for @areaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 150'**
  String get areaHint;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 85000'**
  String get priceHint;

  /// No description provided for @floorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3'**
  String get floorHint;

  /// No description provided for @priceUnit.
  ///
  /// In en, this message translates to:
  /// **'Price Unit'**
  String get priceUnit;

  /// No description provided for @selectPriceUnit.
  ///
  /// In en, this message translates to:
  /// **'Select price unit'**
  String get selectPriceUnit;

  /// No description provided for @pleaseSelectPriceUnit.
  ///
  /// In en, this message translates to:
  /// **'Please select price unit'**
  String get pleaseSelectPriceUnit;

  /// No description provided for @elevator.
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get elevator;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get wifi;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @furnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get furnished;

  /// No description provided for @garden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get garden;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell buyers about the property — layout, condition, nearby landmarks...'**
  String get descriptionHint;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @propertyPhotos.
  ///
  /// In en, this message translates to:
  /// **'Property Photos'**
  String get propertyPhotos;

  /// No description provided for @addPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 photos. Tap a photo to set it as the cover.'**
  String get addPhotosDescription;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @jod.
  ///
  /// In en, this message translates to:
  /// **'JOD'**
  String get jod;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload documents'**
  String get uploadDocuments;

  /// No description provided for @taptpUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get taptpUpload;

  /// No description provided for @uploadDescription.
  ///
  /// In en, this message translates to:
  /// **'You can upload photos or PDF files'**
  String get uploadDescription;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @selectDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get selectDocumentType;

  /// No description provided for @pleaseSelectDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Please select document type'**
  String get pleaseSelectDocumentType;

  /// No description provided for @titleDeed.
  ///
  /// In en, this message translates to:
  /// **'Title Deed'**
  String get titleDeed;

  /// No description provided for @saleContract.
  ///
  /// In en, this message translates to:
  /// **'Sale Contract'**
  String get saleContract;

  /// No description provided for @inheritanceDeed.
  ///
  /// In en, this message translates to:
  /// **'Inheritance Deed'**
  String get inheritanceDeed;

  /// No description provided for @powerOfAttorney.
  ///
  /// In en, this message translates to:
  /// **'Power of Attorney'**
  String get powerOfAttorney;

  /// No description provided for @municipalRecord.
  ///
  /// In en, this message translates to:
  /// **'Municipal Record'**
  String get municipalRecord;

  /// No description provided for @basicDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicDetailsTitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @saveChangesBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesBtn;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **' Find Your Dream \nHome on the Go'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scroll, Select, and Let\'s Settle In!'**
  String get onboardingSubtitle;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **' With Phone Number'**
  String get continueWithPhone;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @emailHintText.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailHintText;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started!'**
  String get getStarted;

  /// No description provided for @enterYourEmailAdd.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to create your account'**
  String get enterYourEmailAdd;

  /// No description provided for @featureNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Feature Unavailable'**
  String get featureNotAvailable;

  /// No description provided for @featureWillBeAvailbleLater.
  ///
  /// In en, this message translates to:
  /// **'This feature is currently not available. Please try again later.'**
  String get featureWillBeAvailbleLater;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Code Sent!'**
  String get codeSent;

  /// No description provided for @checkEmailForVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Check your Email for the verification code'**
  String get checkEmailForVerificationCode;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @signInToContinueSearch.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your search'**
  String get signInToContinueSearch;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @enterPhoneNumberToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to sign in your account'**
  String get enterPhoneNumberToSignIn;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterEmailAddressToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to sign in your account'**
  String get enterEmailAddressToSignIn;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailHint;

  /// No description provided for @letGetStarted.
  ///
  /// In en, this message translates to:
  /// **'You\'re in! Let\'s get started'**
  String get letGetStarted;

  /// No description provided for @welcomeToWathiq.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wathiq'**
  String get welcomeToWathiq;

  /// No description provided for @pleaseEnterFullOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the full OTP'**
  String get pleaseEnterFullOtp;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// No description provided for @otpVerificationInstruction.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit verification code to your email. Please enter it below.'**
  String get otpVerificationInstruction;

  /// No description provided for @verifyAndProceed.
  ///
  /// In en, this message translates to:
  /// **'Verify and Proceed'**
  String get verifyAndProceed;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @emailNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is not registered. Please register first'**
  String get emailNotRegistered;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please login instead'**
  String get emailAlreadyRegistered;

  /// No description provided for @otpExpiredOrInvalid.
  ///
  /// In en, this message translates to:
  /// **'This code has expired or is invalid. Please request a new one'**
  String get otpExpiredOrInvalid;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait before trying again'**
  String get tooManyAttempts;

  /// No description provided for @otpExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Please request a new one'**
  String get otpExpired;

  /// No description provided for @incorrectOtp.
  ///
  /// In en, this message translates to:
  /// **'The code you entered is incorrect'**
  String get incorrectOtp;

  /// No description provided for @accountSuspended.
  ///
  /// In en, this message translates to:
  /// **'Your account has been suspended'**
  String get accountSuspended;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again'**
  String get checkInternetConnection;

  /// No description provided for @tooManyAttemptsWithRetry.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait {retryAfter}s before trying again'**
  String tooManyAttemptsWithRetry(int retryAfter);

  /// No description provided for @verifyYourIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Identity'**
  String get verifyYourIdentity;

  /// No description provided for @step1Of2.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get step1Of2;

  /// No description provided for @step2Of2.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get step2Of2;

  /// No description provided for @uploadYourId.
  ///
  /// In en, this message translates to:
  /// **'Upload your ID'**
  String get uploadYourId;

  /// No description provided for @takeClearPhotoOfId.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of the front of your ID card'**
  String get takeClearPhotoOfId;

  /// No description provided for @takeSelfieWithId.
  ///
  /// In en, this message translates to:
  /// **'Take a selfie with your ID'**
  String get takeSelfieWithId;

  /// No description provided for @holdIdNextToFace.
  ///
  /// In en, this message translates to:
  /// **'Hold your ID next to your face'**
  String get holdIdNextToFace;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tapToUpload;

  /// No description provided for @pleaseUploadIdFirst.
  ///
  /// In en, this message translates to:
  /// **'Please upload your ID first'**
  String get pleaseUploadIdFirst;

  /// No description provided for @faceAndIdClearlyVisible.
  ///
  /// In en, this message translates to:
  /// **'Face and ID both clearly visible'**
  String get faceAndIdClearlyVisible;

  /// No description provided for @goodLightingNoShadows.
  ///
  /// In en, this message translates to:
  /// **'Good lighting, no shadows'**
  String get goodLightingNoShadows;

  /// No description provided for @removeSunglassesOrHats.
  ///
  /// In en, this message translates to:
  /// **'Remove sunglasses or hats'**
  String get removeSunglassesOrHats;

  /// No description provided for @allFourCornersVisible.
  ///
  /// In en, this message translates to:
  /// **'All 4 corners visible'**
  String get allFourCornersVisible;

  /// No description provided for @noGlareOrBlur.
  ///
  /// In en, this message translates to:
  /// **'No glare or blur'**
  String get noGlareOrBlur;

  /// No description provided for @textIsReadable.
  ///
  /// In en, this message translates to:
  /// **'Text is readable'**
  String get textIsReadable;

  /// No description provided for @verificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPending;

  /// No description provided for @verificationPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your documents. This usually takes 1-2 business days. We\'ll notify you once it\'s approved.'**
  String get verificationPendingDescription;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get favourite;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @findYourPerfectProperty.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Property'**
  String get findYourPerfectProperty;

  /// No description provided for @buySellOrRent.
  ///
  /// In en, this message translates to:
  /// **'Buy, sell, or rent verified properties with confidence.'**
  String get buySellOrRent;

  /// No description provided for @getStartedHome.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedHome;

  /// No description provided for @searchByLocation.
  ///
  /// In en, this message translates to:
  /// **'Search by location'**
  String get searchByLocation;

  /// No description provided for @allProperties.
  ///
  /// In en, this message translates to:
  /// **'All Properties'**
  String get allProperties;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @apartmentThreeRooms.
  ///
  /// In en, this message translates to:
  /// **'Apartment — 3 rooms'**
  String get apartmentThreeRooms;

  /// No description provided for @ramallah.
  ///
  /// In en, this message translates to:
  /// **'Ramallah'**
  String get ramallah;

  /// No description provided for @alBireh.
  ///
  /// In en, this message translates to:
  /// **'Al-Bireh'**
  String get alBireh;

  /// No description provided for @threeRooms.
  ///
  /// In en, this message translates to:
  /// **'3 rooms'**
  String get threeRooms;

  /// No description provided for @eightyFiveThousandJod.
  ///
  /// In en, this message translates to:
  /// **'85,000 JOD'**
  String get eightyFiveThousandJod;

  /// No description provided for @myProperties.
  ///
  /// In en, this message translates to:
  /// **'My Properties'**
  String get myProperties;

  /// No description provided for @addNewProperty.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNewProperty;

  /// No description provided for @propertiesListedCount.
  ///
  /// In en, this message translates to:
  /// **'Properties Listed'**
  String get propertiesListedCount;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @editProperty.
  ///
  /// In en, this message translates to:
  /// **'Edit Property'**
  String get editProperty;

  /// No description provided for @deleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Delete Property'**
  String get deleteProperty;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardChanges;

  /// No description provided for @deleteThisProperty.
  ///
  /// In en, this message translates to:
  /// **'Delete this property'**
  String get deleteThisProperty;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @listingType.
  ///
  /// In en, this message translates to:
  /// **'Listing Type'**
  String get listingType;

  /// No description provided for @propertyEditedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Property Edited Successfully'**
  String get propertyEditedSuccessfully;

  /// No description provided for @propertyDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Property Deleted Successfully'**
  String get propertyDeletedSuccessfully;

  /// No description provided for @listingActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get listingActive;

  /// No description provided for @listingInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get listingInactive;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get statusReview;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusSuspended;

  /// No description provided for @deletePropertyWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure you want to delete this property?'**
  String get deletePropertyWarning;

  /// No description provided for @beds.
  ///
  /// In en, this message translates to:
  /// **' Beds'**
  String get beds;

  /// No description provided for @baths.
  ///
  /// In en, this message translates to:
  /// **' Baths'**
  String get baths;

  /// No description provided for @sqm.
  ///
  /// In en, this message translates to:
  /// **' m²'**
  String get sqm;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **' / week'**
  String get perWeek;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes will be lost if you leave this page.'**
  String get discardChangesMessage;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get saveChanges;

  /// No description provided for @saveChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save the changes made to this property?'**
  String get saveChangesMessage;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photo;

  /// No description provided for @statusProperty.
  ///
  /// In en, this message translates to:
  /// **'Status Property'**
  String get statusProperty;

  /// No description provided for @changeOnMap.
  ///
  /// In en, this message translates to:
  /// **'Change On Map'**
  String get changeOnMap;

  /// No description provided for @sureToEditProperty.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you\'d like to edit this property?'**
  String get sureToEditProperty;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature isn\'t available right now. It will be added soon.'**
  String get featureComingSoon;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @sureToDeleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you\'d like to delete this property?'**
  String get sureToDeleteProperty;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @personalInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your personal information'**
  String get personalInformationSubtitle;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityVerification;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get status;

  /// No description provided for @verifiedID.
  ///
  /// In en, this message translates to:
  /// **'Verified ID'**
  String get verifiedID;

  /// No description provided for @notVerifiedID.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerifiedID;

  /// No description provided for @showingSavedData.
  ///
  /// In en, this message translates to:
  /// **'Showing saved data'**
  String get showingSavedData;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search properties'**
  String get searchHint;

  /// No description provided for @noPropertiesFound.
  ///
  /// In en, this message translates to:
  /// **'No properties found'**
  String get noPropertiesFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @recentlySaved.
  ///
  /// In en, this message translates to:
  /// **'Recently Saved'**
  String get recentlySaved;

  /// No description provided for @onePropertySaved.
  ///
  /// In en, this message translates to:
  /// **'1 Property Saved'**
  String get onePropertySaved;

  /// No description provided for @propertiesSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Properties Saved'**
  String propertiesSavedCount(int count);

  /// No description provided for @noSavedPropertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Properties Found'**
  String get noSavedPropertiesTitle;

  /// No description provided for @noSavedPropertiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Properties you save will appear here. Tap the heart icon on any listing to save it.'**
  String get noSavedPropertiesSubtitle;

  /// No description provided for @unitHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get unitHour;

  /// No description provided for @unitDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get unitDay;

  /// No description provided for @unitWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get unitWeek;

  /// No description provided for @unitMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get unitMonth;

  /// No description provided for @priceUnitRequiredForRent.
  ///
  /// In en, this message translates to:
  /// **'The price unit field is required when the listing type is rent.'**
  String get priceUnitRequiredForRent;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save changes'**
  String get saveFailed;

  /// No description provided for @editSentToReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Sent for review'**
  String get editSentToReviewTitle;

  /// No description provided for @editSentToReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes will be checked by an admin, and your property status is now pending.'**
  String get editSentToReviewMessage;

  /// No description provided for @selectFeatures.
  ///
  /// In en, this message translates to:
  /// **'Select features'**
  String get selectFeatures;

  /// No description provided for @noFeaturesSelected.
  ///
  /// In en, this message translates to:
  /// **'No features selected'**
  String get noFeaturesSelected;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @searchProperties.
  ///
  /// In en, this message translates to:
  /// **'Search Properties'**
  String get searchProperties;

  /// No description provided for @onePropertyFound.
  ///
  /// In en, this message translates to:
  /// **'1 Property Found'**
  String get onePropertyFound;

  /// No description provided for @propertiesFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Properties Found'**
  String propertiesFoundCount(int count);

  /// No description provided for @noSearchResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different location or change the filter.'**
  String get noSearchResultsSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get passport;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @clearSignature.
  ///
  /// In en, this message translates to:
  /// **'Clear Signature'**
  String get clearSignature;

  /// No description provided for @editSignature.
  ///
  /// In en, this message translates to:
  /// **'Edit Signature'**
  String get editSignature;

  /// No description provided for @saveChangesCta.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesCta;

  /// No description provided for @selectNationality.
  ///
  /// In en, this message translates to:
  /// **'Select Nationality'**
  String get selectNationality;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
