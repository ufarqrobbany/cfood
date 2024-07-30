import 'package:cfood/custom/shimmer.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class CategoryCardBox extends StatelessWidget {
  final Icon? icon;
  final IconData? icons;
  final Color? iconColors;
  final String? text;
  final VoidCallback? onTap;
  const CategoryCardBox(
      {super.key,
      this.icon,
      this.text = '',
      this.icons,
      this.iconColors,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 0,
                  color: Warna.shadow.withOpacity(0.12),
                  offset: const Offset(0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon!,
            Icon(
              icons,
              color: iconColors,
              size: 30,
            ),
            Text(
              text!,
              style: AppTextStyles.textRegular,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class ProductCardBox extends StatelessWidget {
  final String? productId;
  final String? imgUrl;
  final String? productName;
  final String? storeName;
  final String? price;
  final String? rate;
  final String? likes;
  final bool? itsLoading;
  final VoidCallback? onPressed;
  const ProductCardBox({
    super.key,
    this.productId,
    this.imgUrl,
    this.productName,
    this.storeName,
    this.price,
    this.rate,
    this.likes,
    this.itsLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                spreadRadius: 0,
                color: Warna.shadow.withOpacity(0.12),
                offset: const Offset(0, 0))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customShimmer(
              enabled: itsLoading,
              child: Container(
                // width: double.infinity,
                height: 120,
                constraints: const BoxConstraints(
                  minWidth: 160,
                  maxWidth: double.infinity,
                ),
                decoration: BoxDecoration(
                  color: Warna.abu,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: imgUrl == null
                    ? const Center(
                        child: Icon(Icons.image),
                      )
                    : Image.network(imgUrl!),
              ),
            ),
            itsLoading == true
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        shimmerBox(enabled: itsLoading, width: 120, height: 20),
                        const SizedBox(
                          height: 5,
                        ),
                        shimmerBox(enabled: itsLoading, width: 80, height: 20),
                        const SizedBox(
                          height: 5,
                        ),
                        shimmerBox(enabled: itsLoading, width: 80, height: 20),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            shimmerBox(
                                enabled: itsLoading, width: 50, height: 20),
                            const SizedBox(
                              width: 5,
                            ),
                            shimmerBox(
                                enabled: itsLoading, width: 50, height: 20),
                          ],
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName!,
                          style: AppTextStyles.productName,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.store,
                              size: 15,
                              color: Warna.biru,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              storeName!,
                              style: AppTextStyles.productStoreName,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          Constant.currencyCode + price!,
                          style: AppTextStyles.productPrice,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: Warna.kuning, width: 1),
                                color: Warna.kuning.withOpacity(0.10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Warna.kuning,
                                  ),
                                  Text(
                                    rate!,
                                    style: TextStyle(
                                        color: Warna.kuning, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Warna.like, width: 1),
                                  color: Warna.like.withOpacity(0.10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 10,
                                    color: Warna.like,
                                  ),
                                  Text(
                                    likes!,
                                    style: TextStyle(
                                        color: Warna.like, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class ProductCardBoxHorizontal extends StatelessWidget {
  final String? productId;
  final String? imgUrl;
  final String? productName;
  final String? description;
  final String? price;
  final String? rate;
  final String? likes;
  final String? count;
  final int sold;
  final VoidCallback? onPressed;
  final VoidCallback? onTapAdd;
  final VoidCallback? onTapRemove;
  final VoidCallback? onTapEditProduct;
  final double?
      innerContentSize; //size for image width & height , height for info column
  final bool isCustom;
  final bool hideBorder;
  final bool isOwner;
  const ProductCardBoxHorizontal({
    super.key,
    this.productId,
    this.imgUrl,
    this.productName,
    this.description,
    this.price,
    this.rate,
    this.likes,
    this.count,
    this.sold = 0,
    this.onPressed,
    this.onTapAdd,
    this.onTapRemove,
    this.onTapEditProduct,
    this.innerContentSize,
    this.isCustom = false,
    this.hideBorder = false,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isCustom
          ? const EdgeInsets.fromLTRB(0, 25, 0, 15)
          : const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: hideBorder
            ? null
            : Border(bottom: BorderSide(color: Warna.shadow.withOpacity(0.10))),
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 20,
        //     spreadRadius: 0,
        //     color: Warna.shadow.withOpacity(0.12),
        //     offset: const Offset(0, 0)
        //   )
        // ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isCustom
                ? Container(
                    //
                    height: innerContentSize ?? 133,
                    constraints: BoxConstraints(
                      minWidth: innerContentSize ?? 120,
                      maxWidth: double.infinity,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          // width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 13),
                          height: innerContentSize ?? 133,
                          constraints: BoxConstraints(
                            minWidth: innerContentSize ?? 120,
                            maxWidth: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Warna.abu,
                              borderRadius: BorderRadius.circular(8)
                              // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                              ),
                          child: imgUrl == null
                              ? const Center(
                                  child: Icon(Icons.image),
                                )
                              : Image.network(imgUrl!),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Warna.kuning, width: 1.5),
                                borderRadius: BorderRadius.circular(18)),
                            child: const Text(
                              'Bisa Custom',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    // width: double.infinity,
                    height: innerContentSize ?? 120,
                    constraints: BoxConstraints(
                      minWidth: innerContentSize ?? 120,
                      maxWidth: double.infinity,
                    ),
                    decoration: BoxDecoration(
                        color: Warna.abu, borderRadius: BorderRadius.circular(8)
                        // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                        ),
                    child: imgUrl == null
                        ? const Center(
                            child: Icon(Icons.image),
                          )
                        : Image.network(imgUrl!),
                  ),
            Expanded(
              child: Container(
                height: innerContentSize ?? 120,
                padding: isCustom
                    ? const EdgeInsets.fromLTRB(10, 0, 10, 6)
                    : const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productName!,
                      style: AppTextStyles.productName,
                    ),
                    rate == null && likes == null
                        ? Container(
                            height: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Warna.kuning, width: 1),
                                    color: Warna.kuning.withOpacity(0.10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Warna.kuning,
                                      ),
                                      Text(
                                        rate!,
                                        style: TextStyle(
                                            color: Warna.kuning, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Warna.like, width: 1),
                                      color: Warna.like.withOpacity(0.10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 10,
                                        color: Warna.like,
                                      ),
                                      Text(
                                        likes!,
                                        style: TextStyle(
                                            color: Warna.like, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '$sold Terjual',
                                  style: TextStyle(
                                      color: Warna.regulerFontColor,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Icon(
                        //   Icons.store,
                        //   size: 15,
                        //   color: Warna.biru,
                        // ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        Text(
                          description!.toString(),
                          style: AppTextStyles.productStoreName,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Constant.currencyCode + price!.toString(),
                          style: AppTextStyles.productPrice,
                        ),
                        isOwner
                            ? SizedBox(
                                width: 25,
                                height: 25,
                                child: IconButton(
                                  onPressed: onTapEditProduct,
                                  icon: Icon(
                                    UIcons.solidRounded.pencil,
                                  ),
                                  iconSize: 16,
                                  color: Colors.white,
                                  padding: EdgeInsets.zero,
                                  style: IconButton.styleFrom(
                                      elevation: 0,
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Warna.biru,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)))),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  count != '0'
                                      ? SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: IconButton(
                                            onPressed: onTapRemove,
                                            icon: Icon(
                                              UIcons.solidRounded.minus_small,
                                            ),
                                            iconSize: 23,
                                            color: Colors.white,
                                            padding: EdgeInsets.zero,
                                            style: IconButton.styleFrom(
                                                elevation: 0,
                                                padding: EdgeInsets.zero,
                                                backgroundColor: Warna.biru,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)))),
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 0,
                                        ),
                                  count != '0'
                                      ? SizedBox(
                                          height: 25,
                                          width: 40,
                                          child: Center(
                                            child: Text(
                                              count!,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.textRegular,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 0,
                                        ),
                                  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: IconButton(
                                      onPressed: onTapAdd,
                                      icon: Icon(
                                        UIcons.solidRounded.plus_small,
                                      ),
                                      iconSize: 23,
                                      color: Colors.white,
                                      padding: EdgeInsets.zero,
                                      style: IconButton.styleFrom(
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Warna.biru,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)))),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrganizationCard extends StatelessWidget {
  final String? imgUrl;
  final IconData? icons;
  final Color? iconColors;
  final String? text;
  final VoidCallback? onPressed;
  const OrganizationCard({
    super.key,
    this.imgUrl,
    this.text = '',
    this.icons,
    this.iconColors,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 0,
                  color: Warna.shadow.withOpacity(0.12),
                  offset: const Offset(0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon!,
            // Icon(icons, color: iconColors, size: 30,),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: imgUrl != null
                  ? Image.network(
                      imgUrl!,
                      width: 80,
                      height: 80,
                    )
                  : Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Warna.abu,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Center(child: Icon(Icons.image))),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              text!,
              style: AppTextStyles.textRegular,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class CanteenCardBox extends StatelessWidget {
  final String? canteenId;
  final String? imgUrl;
  final String? canteenName;
  final String? price;
  final String? rate;
  final String? likes;
  final String? menuList;
  final String? type;
  final VoidCallback? onPressed;
  final bool open;
  final bool danus;
  const CanteenCardBox({
    super.key,
    this.canteenId,
    this.imgUrl,
    this.canteenName,
    this.price,
    this.rate,
    this.likes,
    this.menuList,
    this.type = 'kantin',
    this.onPressed,
    this.open = false,
    this.danus = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                spreadRadius: 0,
                color: Warna.shadow.withOpacity(0.12),
                offset: const Offset(0, 0))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Warna.abu,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
                child: imgUrl == null
                    ? const Center(
                        child: Icon(Icons.image),
                      )
                    : Image.network(
                        imgUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          type! == 'kantin'
                              ? Icons.store
                              : CommunityMaterialIcons.handshake,
                          size: 15,
                          color: type! == 'kantin' ? Warna.biru : Warna.kuning,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          canteenName!,
                          style: AppTextStyles.canteenName,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    menuList == null
                        ? Container()
                        : Text(
                            menuList!,
                            style: AppTextStyles.productStoreName,
                            maxLines: 1,
                          ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        danus
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: Warna.like, width: 1),
                                    color: Warna.like.withOpacity(0.10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      UIcons.regularRounded.money,
                                      size: 15,
                                      color: Warna.like,
                                    ),
                                    Text(
                                      ' Danusan',
                                      style: TextStyle(
                                          color: Warna.like, fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        danus
                            ? const SizedBox(
                                width: 8,
                              )
                            : Container(),
                        open
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border:
                                        Border.all(color: Warna.like, width: 1),
                                    color: Warna.like.withOpacity(0.10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      UIcons.solidRounded.time_oclock,
                                      size: 13,
                                      color: Warna.like,
                                    ),
                                    Text(
                                      ' Tutup',
                                      style: TextStyle(
                                          color: Warna.like, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                        open
                            ? Container()
                            : const SizedBox(
                                width: 8,
                              ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Warna.like, width: 1),
                              color: Warna.like.withOpacity(0.10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 10,
                                color: Warna.like,
                              ),
                              Text(
                                likes!,
                                style:
                                    TextStyle(color: Warna.like, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Warna.kuning, width: 1),
                            color: Warna.kuning.withOpacity(0.10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: 10,
                                color: Warna.kuning,
                              ),
                              Text(
                                rate!,
                                style: TextStyle(
                                    color: Warna.kuning, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onPressed,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Spacer(),
                          const Text(
                            'Lihat Menu',
                            style: AppTextStyles.productStoreName,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Warna.abu,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Warna.biru,
                                size: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrganizationCardBox extends StatelessWidget {
  final String? canteenId;
  final String? imgUrl;
  final String? organizationName;
  final String? price;
  final String? rate;
  final String? likes;
  final String? menuList;
  final VoidCallback? onPressed;
  const OrganizationCardBox({
    super.key,
    this.canteenId,
    this.imgUrl,
    this.organizationName,
    this.price,
    this.rate,
    this.likes,
    this.menuList,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              blurRadius: 20,
              spreadRadius: 0,
              color: Warna.shadow.withOpacity(0.12),
              offset: const Offset(0, 0))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Container(
          //   width: 140,
          //   height: 140,
          //   decoration: BoxDecoration(
          //     color: Warna.abu,
          //     borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
          //   ),
          //   child: imgUrl == null ? const Center(child: Icon(Icons.image),) : Image.network(imgUrl!),
          // ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: imgUrl != null
                  ? Image.network(
                      imgUrl!,
                      width: 80,
                      height: 80,
                    )
                  : Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Warna.abu,
                          borderRadius: BorderRadius.circular(100)),
                      child: const Center(child: Icon(Icons.image))),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Icon(
                      //   type! == 'kantin' ?
                      //   Icons.store :
                      //   CommunityMaterialIcons.handshake,
                      //   size: 15,
                      //   color: type! == 'kantin' ?
                      //   Warna.biru :
                      //   Warna.kuning,
                      // ),
                      // const SizedBox(width: 10,),
                      Text(
                        organizationName!,
                        style: AppTextStyles.canteenName,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    menuList!,
                    style: AppTextStyles.productStoreName,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Warna.like, width: 1),
                            color: Warna.like.withOpacity(0.10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 10,
                              color: Warna.like,
                            ),
                            Text(
                              likes!,
                              style: TextStyle(color: Warna.like, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Warna.kuning, width: 1),
                          color: Warna.kuning.withOpacity(0.10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 10,
                              color: Warna.kuning,
                            ),
                            Text(
                              rate!,
                              style:
                                  TextStyle(color: Warna.kuning, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Spacer(),
                      const Text(
                        'Lihat Selengkapnya',
                        style: AppTextStyles.productStoreName,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 25,
                        width: 25,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Warna.abu,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Warna.biru,
                            size: 13,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InboxCardItems extends StatelessWidget {
  final String? chatId;
  final String? inboxId;
  final String? userId;
  final String? imgUrl;
  final String? name;
  final String? lastMassage;
  final String? lastDateTime;
  final String? totalNewMessage;
  final GestureTapCallback? onPressed;
  const InboxCardItems({
    super.key,
    this.chatId,
    this.inboxId,
    this.userId,
    this.imgUrl,
    this.name,
    this.lastMassage,
    this.lastDateTime,
    this.totalNewMessage,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      height: 120,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onPressed,
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: totalNewMessage != null
                      ? Border.all(
                          color: Warna.kuning,
                          width: 1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 0,
                        color: Warna.shadow.withOpacity(0.12),
                        offset: const Offset(0, 0))
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      // margin: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                      decoration: BoxDecoration(
                        color: Warna.abu,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: imgUrl == null
                          ? const Center(
                              child: Icon(Icons.image),
                            )
                          : Image.network(imgUrl!),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name!,
                              style: AppTextStyles.canteenName,
                            ),
                            Text(
                              lastMassage!,
                              style: AppTextStyles.productStoreName,
                            ),
                            const Spacer(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Spacer(),
                                Text(
                                  'date-time-hours',
                                  style: AppTextStyles.productStoreName,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Warna.kuning,
                ),
                child: Center(
                  child: Text(
                    totalNewMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
