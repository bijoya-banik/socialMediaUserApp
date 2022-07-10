import 'package:buddyscripts/controller/country/state/country_state.dart';
import 'package:buddyscripts/models/country_model.dart';
import 'package:buddyscripts/network/api.dart';
import 'package:buddyscripts/network/network_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final countryProvider = StateNotifierProvider<CountryController,CountryState>(
  (ref) => CountryController(ref: ref),
);

class CountryController extends StateNotifier<CountryState> {
  final Ref? ref;
  CountryController({this.ref}) : super(const CountryInitialState());

  List<CountryModel> countryModel = [];

  Future fetchCountries() async {
    state = const CountryLoadingState();
    dynamic responseBody;
    try {
      responseBody = await Network.handleResponse(
        await Network.getRequest(API.countryList),
      );
      if (responseBody != null) {
        countryModel.clear();
        countryModel.add(CountryModel(name: "Select Country", code: ""));
        List<CountryModel> countryModelInstance = (responseBody as List<dynamic>).map((x) => CountryModel.fromJson(x)).toList();

        state = CountrySuccessState(countryModel..addAll(countryModelInstance));
      } else {
        state = const CountryErrorState();
      }
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = const CountryErrorState();
    }
  }
}
