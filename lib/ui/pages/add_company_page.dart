import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/company_controller.dart';
import '../../models/company.dart';
import '../widgets/gradients/gradient_button.dart';
import '../widgets/custom_app_bar2.dart';
import '../widgets/custom_snackBar.dart';
import '../widgets/input_field.dart';
import '../theme.dart';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({super.key});

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final CompanyController _companyController = Get.put(CompanyController());
  final TextEditingController _companyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar2(
        title: 'Add Company',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            InputField(
              title: 'Company Name',
              hint: 'Enter company name here',
              controller: _companyNameController,
              hintOpacity: 0.4,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Add Company',
                gradientColors: gradientClr3,
                onPressed: () async => await _validateData(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: primaryClr1,
                child: _buildCompanyList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyList() {
    return Obx(() {
      if (_companyController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_companyController.companyList.isEmpty) {
        return _noCompanyMsg();
      }
      return ListView.builder(
        itemCount: _companyController.companyList.length,
        itemBuilder: (context, index) {
          final company = _companyController.companyList[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: ShapeDecoration(
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(
                  color: shadowClr,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    company.companyName ?? '',
                    style: customTextCompany,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/icon_images/edited_icon.svg',
                        color: blueClr,
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () => _editCompany(company),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/icon_images/trash_icon.svg',
                        color: redClr,
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () => _deleteCompany(company),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _noCompanyMsg() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/icon_images/company_icon.svg',
            color: primaryClr1.withOpacity(0.5),
            height: 70,
            semanticsLabel: 'No Company',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'There are no companies yet.\nPlease add a new company!',
                style: subHomeStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editCompany(Company company) {
    _companyNameController.text = company.companyName ?? '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Company'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputField(
                title: 'Company Name',
                hint: 'Enter company name here',
                hintOpacity: 0.4,
                controller: _companyNameController,
              ),
              const SizedBox(height: 16),
              const Text('Edit the company name and press Save to update.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 16, color: darkGreyClr)),
              onPressed: () {
                _companyNameController.text = company.companyName ?? '';
                Navigator.of(context).pop();
              },
            ),
            GradientButton(
              text: 'Save',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              gradientColors: gradientClr3,
              width: 84,
              height: 46,
              onPressed: () async {
                String companyName = _companyNameController.text.trim();
                if (companyName.isNotEmpty) {
                  if (companyName != company.companyName) {
                    bool exists = await _companyController
                        .isCompanyNameExists(companyName);
                    if (exists) {
                      CustomSnackbar.showFailed(
                          'A company with this name already exists!');
                      return;
                    }
                  }
                  await _companyController.updateCompany(
                      company.id!, companyName);
                  Navigator.of(context).pop();
                  CustomSnackbar.showSuccess(
                      'Company name updated successfully!');
                } else {
                  CustomSnackbar.showRequired('Company name cannot be empty!');
                }
              },
            ),
          ],
        );
      },
    ).then((_) => _companyNameController.clear());
  }

  void _deleteCompany(Company company) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Company'),
          content: const Text('Are you sure you want to delete this company?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 16, color: darkGreyClr)),
              onPressed: () => Get.back(),
            ),
            GradientButton(
              text: 'Yes',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              gradientColors: gradientClr3,
              width: 76,
              height: 46,
              onPressed: () async {
                await _companyController.deleteCompany(company);
                Get.back();
                CustomSnackbar.showSuccess(
                    'Company name successfully deleted!');
              },
            ),
          ],
        );
      },
    );
  }

  _validateData() async {
    String companyName = _companyNameController.text.trim();
    if (companyName.isNotEmpty) {
      bool exists = await _companyController.isCompanyNameExists(companyName);
      if (exists) {
        CustomSnackbar.showFailed('A company with this name already exists!');
      } else {
        _addCompanyToDb(companyName);
      }
    } else {
      CustomSnackbar.showRequired('Company name cannot be empty!');
    }
  }

  Future<void> _onRefresh() async {
    await _companyController.getCompanies();
  }

  _addCompanyToDb(String companyName) async {
    try {
      await _companyController.addCompany(
        company: Company(
          companyName: companyName,
        ),
      );
      CustomSnackbar.showSuccess('Company added successfully!');
      _companyNameController.clear();
    } catch (e) {
      debugPrint('Error adding company: $e');
      CustomSnackbar.showFailed('Failed to add company. Please try again.');
    }
  }
}
