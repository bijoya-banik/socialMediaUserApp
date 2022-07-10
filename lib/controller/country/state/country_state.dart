import 'package:buddyscripts/models/country_model.dart';

abstract class CountryState {
  const CountryState();
}

class CountryInitialState extends CountryState {
  const CountryInitialState();
}

class CountryLoadingState extends CountryState {
  const CountryLoadingState();
}

class CountrySuccessState extends CountryState {
  final List<CountryModel> countryModel;
  const CountrySuccessState(this.countryModel);
}

class CountryErrorState extends CountryState {
  const CountryErrorState();
}
