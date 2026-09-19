import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;

import '../../models/offer_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/rating_stars.dart';

/// Shows competing provider offers for a request — the InDrive-style
/// bidding step: providers set their own price around the fair-price
/// estimate and the client is free to pick whoever they prefer.
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requestId = ModalRoute.of(context)!.settings.arguments as String;

    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final request = appState.requestById(requestId);
      final offers = appState.offersForRequest(requestId);

      return Scaffold(
        appBar: AppBar(title: const Text('عروض مقدمي الخدمة')),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    const Icon(Icons.price_check, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'السعر العادل المتوقع: ${request.fairPriceMin.toStringAsFixed(0)} - ${request.fairPriceMax.toStringAsFixed(0)} ج.م',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: offers.isEmpty
                    ? const _WaitingForOffers()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: offers.length,
                        itemBuilder: (context, i) => _OfferCard(
                          offer: offers[i],
                          onSelect: () {
                            appState.selectOffer(requestId, offers[i].id);
                            Navigator.of(context).pushReplacementNamed('/client/tracking', arguments: requestId);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _WaitingForOffers extends StatelessWidget {
  const _WaitingForOffers();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('بنبعت طلبك لمقدمي الخدمة القريبين منك...', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onSelect;
  const _OfferCard({required this.offer, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return pv.Consumer<AppState>(builder: (context, appState, _) {
      final provider = appState.userById(offer.providerId);
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryLight,
                child: Text((provider != null && provider.name.isNotEmpty) ? provider.name.substring(0, 1) : '؟'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(provider?.name ?? 'مقدم خدمة', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingStars(rating: provider?.ratingAverage ?? 0),
                        const SizedBox(width: 6),
                        Text('(${provider?.ratingCount ?? 0})', style: const TextStyle(fontSize: 12, color: Colors.black45)),
                        if (provider?.isTopRated == true) ...[
                          const SizedBox(width: 6),
                          const Text('⭐ مميز', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
                        ],
                      ],
                    ),
                    if (offer.message.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(offer.message, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${offer.price.toStringAsFixed(0)} ج.م', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: PrimaryButton(label: 'اختيار', onPressed: onSelect),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
