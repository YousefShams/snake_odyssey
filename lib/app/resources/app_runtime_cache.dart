class AppRuntimeCache {

  static List<String> deletedImagesIds = [];

  static addDeletedImageId(String id) {
    deletedImagesIds.add(id);
  }

  static List<String> getDeletedImageIds() {
    return deletedImagesIds.toList();
  }

}