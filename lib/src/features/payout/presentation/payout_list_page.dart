import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paywize/src/common/utils/slide_animation.dart';
import 'package:paywize/src/features/payout/presentation/providers/payout_stream_provider.dart';
import 'package:paywize/src/features/payout/presentation/widgets/payout_card.dart';

class PayoutListScreen extends ConsumerWidget {
  const PayoutListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payoutStreams = ref.watch(payoutStreamProvider);
    return Scaffold(
      body: payoutStreams.when(
        data: (data) {
          final _payouts = data;
          if (_payouts.isEmpty) {
            return Center(
              child: SlideAnimation(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment_outlined, size: 80),
                    const SizedBox(height: 24),
                    const Text(
                      'No payouts found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your payout history will appear here',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Click the below plus button to create payouts',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Custom App Bar
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Payouts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_payouts.length} total',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Payout List
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          child: SlideAnimation(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(
                                top: 24,
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              itemCount: _payouts.length,
                              itemBuilder: (context, index) {
                                final payout = _payouts[index];
                                return PayoutCard(payout: payout);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        error: (error, stackTrace) {},
        loading: () {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading payouts...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
