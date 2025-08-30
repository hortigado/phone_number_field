import '../models/country_code_model.dart';
import 'country_list.dart';

class GeneralUtil {
  static List<CountryCodeModel> loadJson() {
    List<CountryCodeModel> listCountryCodeModel = List<CountryCodeModel>.from(countries.map((model) => CountryCodeModel.fromJson(model)));

    return listCountryCodeModel;
  }
}
