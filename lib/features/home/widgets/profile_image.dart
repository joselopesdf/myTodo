import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/local_user_provider.dart';

class ProfileImage extends StatelessWidget {
  double? radius;

  ProfileImage({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final photo = ref.watch(
          localUserProvider.select((user) => user.value?.photo),
        );

        return CachedNetworkImage(
          imageUrl: photo ?? '',
          imageBuilder: (context, imageProvider) =>
              CircleAvatar(radius: radius, backgroundImage: imageProvider),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
    );
  }
}
