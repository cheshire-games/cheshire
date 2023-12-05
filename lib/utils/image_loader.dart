import 'package:photo_manager/photo_manager.dart';

class ImageLoader {
  static Future<List<AssetEntity>> loadImages() async {
    var result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      // Fetch all images within the albums
      List<AssetEntity> images = [];
      for (var album in albums) {
        final assetCount = await album.assetCountAsync;
        final albumImages =
            await album.getAssetListPaged(page: 0, size: assetCount);
        images.addAll(albumImages);
      }

      return images;
    } else {
      // Handle the scenario where the user denies permission
      PhotoManager.openSetting();
      return [];
    }
  }
}
