import 'package:cek_ongkir/app/data/models/city_model.dart';
import 'package:cek_ongkir/app/data/models/province_model.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ONGKOS KIRIM'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
              menuProps: MenuProps(align: MenuAlign.bottomCenter),
              fit: FlexFit.loose,
              itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
                title: Text("${item.province}"),
              ),
              showSearchBox: true,
            ),
            items: (filter, loadProps) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {"key": dotenv.env['API_KEY']},
              );

              return Province.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
            compareFn: (item, selectedItem) => item == selectedItem,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Provinsi Asal",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) =>
                controller.provAsalId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 15,
          ),
          DropdownSearch<City>(
            popupProps: PopupProps.menu(
              menuProps: MenuProps(align: MenuAlign.bottomCenter),
              fit: FlexFit.loose,
              itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
                title: Text("${item.type} ${item.cityName}"),
              ),
              showSearchBox: true,
            ),
            items: (filter, loadProps) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provAsalId}",
                queryParameters: {"key": dotenv.env['API_KEY']},
              );

              return City.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
            compareFn: (item, selectedItem) => item == selectedItem,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Kota Asal",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) =>
                controller.cityAsalId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 15,
          ),
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
              menuProps: MenuProps(align: MenuAlign.bottomCenter),
              fit: FlexFit.loose,
              itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
                title: Text("${item.province}"),
              ),
              showSearchBox: true,
            ),
            items: (filter, loadProps) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {"key": dotenv.env['API_KEY']},
              );

              return Province.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
            compareFn: (item, selectedItem) => item == selectedItem,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Provinsi Tujuan",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) =>
                controller.provTujuanId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 15,
          ),
          DropdownSearch<City>(
            popupProps: PopupProps.menu(
              menuProps: MenuProps(align: MenuAlign.bottomCenter),
              fit: FlexFit.loose,
              itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
                title: Text("${item.type} ${item.cityName}"),
              ),
              showSearchBox: true,
            ),
            items: (filter, loadProps) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provTujuanId}",
                queryParameters: {"key": dotenv.env['API_KEY']},
              );

              return City.fromJsonList(
                response.data["rajaongkir"]["results"],
              );
            },
            compareFn: (item, selectedItem) => item == selectedItem,
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Kota Tujuan",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) =>
                controller.cityTujuanId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 15,
          ),
          DropdownSearch<Map<String, dynamic>>(
            compareFn: (item, selectedItem) => item == selectedItem,
            items: (filter, loadProps) => [
              {
                "code": "jne",
                "name": "JNE",
              },
              {
                "code": "pos",
                "name": "POS Indonesia",
              },
              {
                "code": "tiki",
                "name": "TIKI",
              },
            ],
            popupProps: PopupProps.menu(
              menuProps: MenuProps(align: MenuAlign.bottomCenter),
              fit: FlexFit.loose,
              itemBuilder: (context, item, isDisabled, isSelected) => ListTile(
                title: Text("${item['name']}"),
              ),
              showSearchBox: true,
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: "Pilih Kurir",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            dropdownBuilder: (context, selectedItem) => Text(
              "${selectedItem?['name'] ?? 'Pilih Kurir'}",
            ),
            onChanged: (value) =>
                controller.codeKurir.value = value?['code'] ?? "",
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: controller.beratC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Berat dalam gram",
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.cekOngkir();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "Cek Ongkos Kirim"
                  : "Loading"),
            ),
          ),
        ],
      ),
    );
  }
}
