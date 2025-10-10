part of '../login/view.dart';


class SwitchButtonSection extends StatelessWidget {
  final bool isLogin;

  const SwitchButtonSection({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color:  Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4.r,
            offset: const Offset(0, 4),
            //blurStyle: BlurStyle.
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BuildToggleButton(
            text: LocaleKeys.login.tr(),
            isActive: isLogin,
            onTap: () {
              if (!isLogin) {
                navigateTo(LoginView(),keepHistory: false);
              }
            },
          ),
          _BuildToggleButton(
            text: LocaleKeys.signUp.tr(),
            isActive: !isLogin,
            onTap: () {
              if (isLogin) {
                navigateTo(SignupView(),keepHistory: false);
              }
            },
          ),
        ],
      ),
    );
  }




}
class _BuildToggleButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;
  const _BuildToggleButton({required this.text, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [

            if(isActive)
              BoxShadow(
                  offset: Offset(0, -4),
                  blurRadius: 20.r,
                  color: Colors.white.withValues(alpha: .72),
                  blurStyle: BlurStyle.inner
              )
          ],
          color: isActive ? Theme.of(context).secondaryHeaderColor :Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:  Theme.of(context).primaryColor.withValues(alpha: isActive?1:.4) ,
          ),
        ),
      ),
    );
  }
}