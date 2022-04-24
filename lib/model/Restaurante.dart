import 'package:flutter/material.dart';

class Restaurante {
  String strDrink = "";
  String strDrinkThumb = "";
  String idDrink = "";
  String strCategory = "";
  String strInstructions = "";

  Restaurante(strDrink, strDrinkThumb, idDrink, strCategory, strInstructions) {
    this.strDrink = strDrink;
    this.strDrinkThumb = strDrinkThumb;
    this.idDrink = idDrink;
    this.strCategory = strCategory;
    this.strInstructions = strInstructions;
  }
}
