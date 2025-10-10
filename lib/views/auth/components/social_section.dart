part of '../login/view.dart';

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Spacer(),
        _ItemSocial(img: 'google.png', onTap: () {}),
        Spacer(),
        _ItemSocial(img: 'apple.png', onTap: () {}),
        Spacer(),
      ],
    );
  }
}

class _ItemSocial extends StatelessWidget {
  final String img;
  final VoidCallback onTap;

  const _ItemSocial({super.key, required this.img, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCircleIcon(
      img: img,
      onTap: onTap,
      bgColor: Theme.of(context).scaffoldBackgroundColor,
      bgRadius: 57.h,
      radius: 37.h,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 4.r,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}