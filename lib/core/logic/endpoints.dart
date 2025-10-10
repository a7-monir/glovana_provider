
class ApiEndPoints {
  static const baseUrl = 'https://glovana.net/api/v1/';

  static const imagesUrl = 'https://glovana.net/assets/admin/uploads/';

  // static const smsUrl = "https://api.releans.com/v2/otp/send";
  // static const verifySms = "https://api.releans.com/v2/otp/check";
  // static const smsToken =
  //     "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6ImY5NmM3YjU2LTQ4MWItNGJkNC05NDdlLWU3OGU0NDk5MmIzMyIsImlhdCI6MTcyNDg2NDE5MCwiaXNzIjoxOTk1MX0.wtUSVvdfT41TBXBhMu5aXx5KTEZVSrwjZ_Y-SvEITUA";

  // static const baseUrl = 'https://vertex-jordan.com/api/v1/user/';

  // static const guestToken = 'https://vertex-jordan.com/api/v1/guest/';

  // static const imagesUrl = 'https://vertex-jordan.com/public/storage/';

//    static const baseUrl = 'https://dev.vertex-world.com/api/v1/user/';

//   static const guestToken = 'https://dev.vertex-world.com/api/v1/guest/';

//  static const imagesUrl = 'https://dev.vertex-world.com/public/storage/';

  //====================auth======================

  static const register = 'user/register';

  static const login = 'user/login';
  static const deleteUser = 'user/delete-account';

  static const updateProfile = 'provider/update_profile';

  static const categories = '/categories';

  static const banners = '/banners';

  static const getTypes = 'user/getTypes';
  static const getServices = 'user/getServices';

  static const getProviderVip = '/provider/vip';

  static const allProviders = '/allProviders';

  static const typeProviders = '/providers/type';
  static const userProviders = '/providers';
  static const String searchProviders = '/provider/search';

  static const String products = '/products';

  static const String productFavorites = '/productFavourites';

  static const String providerFavourites = '/providerFavourites';

  static const gettingAddresses = '/addresses';
  static const getDelivery = '/get_deliveryfee';
  static const delivery = '/deliveries';
  static const carts = '/cart';
  static const orders = '/orders';

  static const cancel = '/cancel';

  static const refund = '/refund';
  static const coupons = '/coupons/validate';

  static const searchProduct = '/products/search';
  static const appointments = 'provider/appointments';
  static const ratings = 'provider/ratings';
  static const uploadFiles = '/uploadPhotoVoice';
  static const points = '/points';
  static const pointsConvert = '/points/convert';
  static const wallet = 'provider/wallet/transactions';
  static const appointmentsForStatus = '/provider/appointments';
  static const String completeProfile = '/provider/complete-profile';

  static const String providerTypes = 'provider/types';

  static const String providerProfile = 'provider/providerProfile';

  static const String providerImages = '/provider/images';

  static const String providerGalleries = '/provider/gallery';
  static const sendNotifications = 'user/notifications';
  static const getNotifications = 'provider/notifications';
  static const String paymentReport =
      'provider/appointments/provider/payment-report';

  static const String updateProviderStatus = 'provider/updateStatus';
  static const String deleteAccount = "/user/delete_account";
}
