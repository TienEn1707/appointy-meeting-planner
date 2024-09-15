import 'package:get/get.dart';
import '../db/db_helper.dart';
import '../models/company.dart';

class CompanyController extends GetxController {
  var companyList = <Company>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getCompanies();
  }

  Future<void> getCompanies() async {
    isLoading.value = true;
    try {
      List<Map<String, dynamic>> companies = await DBHelper.queryCompanies();
      companyList
          .assignAll(companies.map((data) => Company.fromJson(data)).toList());
    } catch (e) {
      print("Error fetching companies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> addCompany({required Company company}) async {
    int id = await DBHelper.insertCompany(company.companyName!);
    await getCompanies();
    return id;
  }

  Future<void> updateCompany(int id, String newCompanyName) async {
    await DBHelper.updateCompany(id, newCompanyName);
    await getCompanies();
  }

  Future<void> deleteCompany(Company company) async {
    await DBHelper.deleteCompany(company.id!);
    await getCompanies();
  }

  Future<bool> isCompanyNameExists(String companyName) async {
    return companyList.any((company) =>
        company.companyName?.toLowerCase() == companyName.toLowerCase());
  }
}
