import 'dart:convert';

class Province {
  String id;
  String provinceID;
  String provinceThai;
  String provinceEng;
  String officialRegion;
  String fourRegion;
  String tourismRegion;
  String bangkokMetropolitan;
  String area;
  String population62;
  String malePopulation62;
  String femalePopulation62;

  Province({
    required this.id,
    required this.provinceID,
    required this.provinceThai,
    required this.provinceEng,
    required this.officialRegion,
    required this.fourRegion,
    required this.tourismRegion,
    required this.bangkokMetropolitan,
    required this.area,
    required this.population62,
    required this.malePopulation62,
    required this.femalePopulation62,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'ProvinceID': provinceID,
      'ProvinceThai': provinceThai,
      'ProvinceEng': provinceEng,
      'ภูมิภาคอย่างเป็นทางการ': officialRegion,
      'ภูมิภาคแบบสี่ภูมิภาค': fourRegion,
      'ภูมิภาคท่องเที่ยวแห่งประเทศไทย': tourismRegion,
      'กรุงเทพปริมณฑลต่างจังหวัด': bangkokMetropolitan,
      'พื้นที่ ตรกม': area,
      'ประชากรรวม62': population62,
      'ประชากรชาย62': malePopulation62,
      'ประชากรหญิง62': femalePopulation62,
    };
  }

  factory Province.fromMap(Map<String, dynamic> map) {
    return Province(
      id: map['_id'].toString(),
      provinceID: map['ProvinceID'].toString(),
      provinceThai: map['ProvinceThai'],
      provinceEng: map['ProvinceEng'],
      officialRegion: map['ภูมิภาคอย่างเป็นทางการ'],
      fourRegion: map['ภูมิภาคแบบสี่ภูมิภาค'],
      tourismRegion: map['ภูมิภาคท่องเที่ยวแห่งประเทศไทย'],
      bangkokMetropolitan: map['กรุงเทพปริมณฑลต่างจังหวัด'],
      area: map['พื้นที่ ตรกม'].toString(),
      population62: map['ประชากรรวม62'].toString(),
      malePopulation62: map['ประชากรชาย62'].toString(),
      femalePopulation62: map['ประชากรหญิง62'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Province.fromJson(String source) =>
      Province.fromMap(json.decode(source));
}
