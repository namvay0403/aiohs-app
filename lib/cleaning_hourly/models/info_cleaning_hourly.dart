class InfoCleaningHourly {
  //late String? name;
  //late String? phone;
  late String? shortAddress;
  late String? address;
  late int? duration;
  late bool? cooking;
  late bool? iron;
  late bool? bringTool;
  late bool? bringVaccum;
  late int? realDuration;
  late bool? hasPet;
  late DateTime? date;
  late DateTime? time;
  late String? note;
  late int price;
  late String? paymentMethod;

  InfoCleaningHourly({
    //this.name,
    //this.phone,
    this.shortAddress,
    this.address,
    this.duration = 2,
    this.cooking = false,
    this.iron = false,
    this.bringTool = false,
    this.bringVaccum = false,
    this.realDuration = 2,
    this.hasPet = false,
    this.date,
    this.time,
    this.note = "",
    this.price = 0,
    this.paymentMethod = "PAYMENT_METHOD_CASH",
  });

  InfoCleaningHourly.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    cooking = json['cooking'];
    iron = json['iron'];
    bringTool = json['bringTool'];
    bringVaccum = json['bringVaccum'];
    realDuration = json['realDuration'];
    hasPet = json['hasPet'];
    date = DateTime.parse(json['date']);
    time = DateTime.parse(json['time']);
    note = json['note'];
    price = json['price'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() => {
    'duration': duration,
    'cooking': cooking,
    'iron': iron,
    'bringTool': bringTool,
    'bringVaccum': bringVaccum,
    'realDuration': realDuration,
    'hasPet': hasPet,
    'date': date!.toIso8601String(),
    'time': time!.toIso8601String(),
    'note': note,
    'price': price,
    'paymentMethod': paymentMethod,
  };
}