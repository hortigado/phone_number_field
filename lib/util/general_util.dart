import '../models/country_code_model.dart';
import 'country_list.dart';

class GeneralUtil {
  static List<CountryCodeModel>? _cachedCountries;

  static List<CountryCodeModel> loadJson() {
    return _cachedCountries ??=
        List<CountryCodeModel>.unmodifiable(
          countries.map((model) => CountryCodeModel.fromJson(model)),
        );
  }

  static CountryCodeModel? findByCode(String code) {
    try {
      final json = countries.firstWhere(
        (model) => (model['code'] as String).toLowerCase() == code.toLowerCase(),
      );
      return CountryCodeModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  static CountryCodeModel? findByDialCode(String dialCode) {
    try {
      final json = countries.firstWhere(
        (model) => model['dial_code'] == dialCode,
      );
      return CountryCodeModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
