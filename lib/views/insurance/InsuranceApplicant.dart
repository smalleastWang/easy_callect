import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsuranceApplicantPage extends ConsumerStatefulWidget {
  const InsuranceApplicantPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InsuranceApplicantPageState();
}

class _InsuranceApplicantPageState extends ConsumerState<InsuranceApplicantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.insuranceApplicant.title),
      ),
      body: ListWidget<InsuranceApplicantListFamily>(
        provider: insuranceApplicantListProvider,
        builder: (data) {
          return Column(
            children: [
              ListCardTitle(
                hasDetail: false,
                title: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D8FFD),
                        borderRadius: BorderRadius.circular(3)
                      ),
                      child: Text(data['otherCardNumber'], style: const TextStyle(color: Colors.white)),
                    ),
                    Text(data['farmerName'], style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // ListCardCell(label: '机构名称', value: data['farmerName']),
              ListCardCell(label: '身份证号', value: data['idCardNumber']),
              // ListCardCell(label: '证件类型', value: data['otherCardNumber']),
              ListCardCell(label: '机构地址', value: data['farmerAdress']),
              ListCardCell(label: '联系电话', value: data['phone']),
              ListCardCell(label: '养殖地点', value: data['breedingBase']),
              ListCardCell(label: '养殖数量', value: data['totalNum']),
            ],
          );
        },
      ),
    );
  }
}