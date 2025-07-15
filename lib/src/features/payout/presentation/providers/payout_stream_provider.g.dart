// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_stream_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$payoutStreamHash() => r'649fe6701050f39db62af5fe8ea26b010ebeb8ff';

/// [payoutStream] returns the payouts from local sqldatabase
///
/// Copied from [payoutStream].
@ProviderFor(payoutStream)
final payoutStreamProvider = StreamProvider<List<PayoutModel>>.internal(
  payoutStream,
  name: r'payoutStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$payoutStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PayoutStreamRef = StreamProviderRef<List<PayoutModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
