import 'package:flutter_test/flutter_test.dart';
import 'package:geny_test_app/core/enums/data_fetching_state.dart';
import 'package:geny_test_app/core/models/business_model.dart';
import 'package:geny_test_app/core/repositories/business_repository.dart';
import 'package:geny_test_app/features/home/notifiers/business_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'business_notifier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BusinessRepository>()])
void main() {
  late BusinessNotifier businessNotifier;
  late BusinessRepository mockBusinessRepository;

  setUpAll(() {
    mockBusinessRepository = MockBusinessRepository();
    businessNotifier = BusinessNotifier(
      businessRepository: mockBusinessRepository,
    );
  });
  group('Business Notifier', () {
    test(
      'State should be update to fetched data when fetchBusinesses returns data',
      () async {
        // arrange
        final mockBusinesses = [
          const BusinessModel(
            name: 'Glow & Go Salon',
            location: 'Atlanta',
            phone: '+1 404 123 4567',
          ),
          const BusinessModel(
            name: 'Fresh Cuts Barbershop',
            location: 'Lagos',
            phone: '+234 802 555 1212',
          ),
        ];
        when(
          mockBusinessRepository.getBusinesses(),
        ).thenAnswer((_) async => mockBusinesses);

        // act
        await businessNotifier.fetchBusinesses();

        // assert
        verify(mockBusinessRepository.getBusinesses()).called(1);
        expect(businessNotifier.state.item, isA<List<BusinessModel>>());
        expect(
          businessNotifier.state.connectionState,
          DataFetchingState.success,
        );
      },
    );

    test(
      'State should be update to failure when fetchBusinesses throws an error',
      () async {
        // arrange
        when(
          mockBusinessRepository.getBusinesses(),
        ).thenThrow(Exception('Something went wrong'));

        // act
        await businessNotifier.fetchBusinesses();

        // assert
        verify(mockBusinessRepository.getBusinesses()).called(1);
        expect(businessNotifier.state.item, isNull);
        expect(
          businessNotifier.state.connectionState,
          DataFetchingState.failure,
        );
      },
    );
  });
}
