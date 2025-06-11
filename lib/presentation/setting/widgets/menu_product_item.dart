import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../components/buttons.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/variable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/model/response/product_response_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first


class MenuProductItem extends StatelessWidget {
  final Product data;
  final Function() onTapEdit;
  const MenuProductItem({
    super.key,
    required this.data,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 3, color: AppColors.blueLight),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: buildList(context),
        ));
  }

  List<Widget> buildList(BuildContext context) {
    return [
      Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: CachedNetworkImage(
                imageUrl: '${Variable.baseUrl}/${data.image}',
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(
                  Icons.food_bank_outlined,
                  size: 80,
                ),
                width: 54,
                height: 54,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              data.name!,
              style: const TextStyle(
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              data.category?.name ?? '-',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Row(
              children: [
                Flexible(
                  child: Button.outlined(
                    onPressed: () {
                      showDialog(
                          context: context,
                          // backgroundColor: AppColors.white,
                          builder: (context) {
                            //container for product detail
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(16.0),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data.name!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  const SpaceHeight(10.0),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${Variable.baseUrl}${data.image}',
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.food_bank_outlined,
                                        size: 80,
                                      ),
                                      width: 80,
                                    ),
                                  ),
                                  const SpaceHeight(10.0),
                                  Text(
                                    data.category?.name ?? '-',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SpaceHeight(10.0),
                                  Text(
                                    data.price.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SpaceHeight(10.0),
                                  Text(
                                    data.stock.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SpaceHeight(10.0),
                                ],
                              ),
                            );
                          });
                    },
                    label: 'View',
                    fontSize: 12.0,
                    height: 30,
                    borderRadius: 10,
                  ),
                ),
                const SpaceWidth(6.0),
                Flexible(
                  child: Button.outlined(
                    onPressed: onTapEdit,
                    label: 'Edit',
                    fontSize: 12.0,
                    height: 30,
                    borderRadius: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
