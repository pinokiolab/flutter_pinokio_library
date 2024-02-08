import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pinokio_library/flutter_pinokio_package.dart';

class SearchImageList extends StatelessWidget {
  const SearchImageList(
      {Key? key,
      required this.data,
      required this.bl,
      required this.dataRowHeight,
      required this.jwt})
      : super(key: key);

  final List<String> data;
  final String bl;
  final double dataRowHeight;
  final String jwt;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: getImageUrlList(jwt, data),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<InkWell>.generate(
              data.length,
              (index) {
                return InkWell(
                  onTap: () async {
                    (await customSwipeImageGallery(
                            context, index, data, bl, jwt))
                        .show();
                  },
                  child: SizedBox.square(
                    dimension: dataRowHeight,
                    child: (!snapshot.hasData)
                        ? const Center(child: CircularProgressIndicator())
                        : CachedNetworkImage(
                            cacheKey: 'Thumbnail${data[index]}',
                            cacheManager: SearchCacheManager.instance,
                            imageUrl: snapshot.data![index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class SearchCacheManager {
  static const key = "search";
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 1),
      maxNrOfCacheObjects: 500,
    ),
  );
}
