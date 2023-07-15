
// ignore_for_file: curly_braces_in_flow_control_structures

class AppStrings {

  static const onboardingTitle1 = "Welcome to PicQuery!";
  static const onboardingSubtitle1 = "Our app uses advanced Artificial Intelligence technologies to make"
      " searching for images easier than ever. Simply take a photos"
      " on your mobile and let our text recognition and object detection"
      " algorithms do the rest.";

  static const onboardingTitle2 = "Find What You're Looking For";
  static const onboardingSubtitle2 = "With PicQuery, you can quickly search through a large collection of"
      " images using keywords or tags"
      " Our advanced AI algorithms make it easy to find the image"
      " you need.";

  static const onboardingTitle3 = "Save Time and Hassle";
  static const onboardingSubtitle3 = "No more scrolling through endless pages of images. With PicQuery, you can quickly find the images you need, all in one place. Our app is designed to save you time and make your search experience hassle-free.";

  static const favoritesTitle = "Your Favourites  ❤️";

  static const processLoading = "Loading images, please wait...";
  static String imagesLoading(processed,total) => "Processing $processed out of $total images";
  static const searchLoading = "Looking for the image, please wait...";


  static const textFieldSearchLabel = "Search with a keyword";
  static const noPhotos = "No images found..";
  static const noFavs = "Your favorites images grid is empty..";


  static const infoTitle = "Image Details  📃";
  static const imageName = "Image Name";
  static const imageDate = "Created Date";
  static const imageResolution = "Image Resolution";
  static const imageSize = "Image Size";
  static const imagePath = "Image Path";
  static const imageLatLng = "Image Latitude and Longitude";

  static const analyticsTitle = "Image Analytics  💡";
  static const analyticsLabels = "Detected labels and objects";
  static const analyticsText = "Extracted Text";
  static const copiedToast = "Copied Successfully!";


  static const deleteWarning = "Do you want to delete this image?";
  static const cancel = "Cancel";
  static const delete = "Delete";

  static const copyAll = "Copy All Text";


  static String getGreetingsString() {
    final currentHour = DateTime.now().hour;

    if(currentHour >= 0 && currentHour < 12) return "Good Morning";
    else if(currentHour >= 12 && currentHour < 6) return "Good Afternoon";
    else return "Good Evening";
  }
}