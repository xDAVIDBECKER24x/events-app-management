import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;
String? currentUID = FirebaseAuth.instance.currentUser?.uid;

bool themeMode = false;
const List<String> midiaCategories = <String>['pictures', 'banners'];



const googlePlaceTypeListRaw = ["accounting", "airport", "amusement_park", "aquarium", "art_gallery", "atm", "bakery", "bank", "bar",
  "beauty_salon", "bicycle_store", "book_store", "bowling_alley", "bus_station", "cafe", "campground", "car_dealer", "car_rental",
  "car_repair", "car_wash", "casino", "cemetery", "church", "city_hall", "clothing_store", "convenience_store", "courthouse", "dentist",
  "department_store", "doctor", "drugstore", "electrician", "electronics_store", "embassy", "fire_station", "florist", "funeral_home",
  "furniture_store", "gas_station", "gym", "hair_care", "hardware_store", "hindu_temple", "home_goods_store", "hospital", "insurance_agency",
  "jewelry_store", "laundry", "lawyer", "library", "light_rail_station", "liquor_store", "local_government_office", "locksmith", "lodging",
  "meal_delivery", "meal_takeaway", "mosque", "movie_rental", "movie_theater", "moving_company", "museum", "night_club", "painter", "park",
  "parking", "pet_store", "pharmacy", "physiotherapist", "plumber", "police", "post_office", "primary_school", "real_estate_agency",
  "restaurant", "roofing_contractor", "rv_park", "school", "secondary_school", "shoe_store", "shopping_mall", "spa", "stadium", "storage",
  "store", "subway_station", "supermarket", "synagogue", "taxi_stand", "tourist_attraction", "train_station", "transit_station",
  "travel_agency", "university", "veterinary_care", "zoo"];

const googlePlaceTypeListPTBR = ["contabilidade", "aeroporto", "parque de diversões", "aquário", "galeria de arte", "caixa eletrônico", "padaria", "banco", "bar",
  "salão de beleza", "loja de bicicletas", "livraria", "pista de boliche", "estação de ônibus", "café", "camping", "revendedor de carros", "aluguel de carros",
  "reparação de automóveis", "lavagem de carros", "cassino", "cemitério", "igreja", "prefeitura", "loja de roupas", "loja de conveniência", "tribunal", "dentista",
  "loja de departamentos", "médico", "droga", "eletricista", "loja de eletrônicos", "embaixada", "corpo de bombeiros", "florista", "funerária",
  "loja de móveis", "posto de gasolina", "academia", "cuidados com os cabelos", "loja de ferragens", "templo hindu", "loja de artigos para o lar", "hospital", "agência de seguros",
  "joalheria", "lavanderia", "advogado", "biblioteca", "estação de trem leve", "loja de bebidas", "escritório do governo local", "seralheiro", "hospedagem",
  "entrega de refeições", "refeição para levar", "mesquita", "aluguel de filmes", "cinema", "empresa de mudanças", "museu", "boate", "pintor", "parque",
  "estacionamento", "pet shop", "farmácia", "fisioterapeuta", "encanador", "polícia", "correio", "escola primária", "agência imobiliária",
  "restaurante", "empreiteiro de telhados", "parque de trailers", "escola", "escola secundária", "loja de sapatos", "centro comercial", "spa", "estádio", "armazenamento",
  "loja", "estação de metrô", "supermercado", "sinagoga", "ponto de táxi", "atração turística", "estação de trem", "estação de trânsito",
  "agência de viagens", "universidade", "atendimento veterinário", "zoológico"];

const trendPlaceTypeList = ['parque de diversões',"galeria de arte","bar","pista de boliche","café","cassino","hospedagem","loja de bebidas" ,"museu", "boate",
  "parque", "refeição para levar","restaurante","centro comercial","spa", "universidade","show","exposição",];