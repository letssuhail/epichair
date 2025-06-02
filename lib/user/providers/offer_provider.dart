import 'package:epic/user/api%20services/offer_service.dart';
import 'package:epic/user/models/offer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offerServiceProvider = Provider<OfferService>((ref) => OfferService());

final getOfferProvider = FutureProvider<List<Offer>>((ref) async {
  return ref.watch(offerServiceProvider).getOffers();
});
