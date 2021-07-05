import 'dart:convert';

class Cuti {
  Cuti({
    this.id,
    this.noInduk,
    this.tglCuti,
    this.lamaCuti,
    this.keterangan,
  });

  String id;
  String noInduk;
  String tglCuti;
  String lamaCuti;
  String keterangan;

  Map<String, dynamic> toJson() => {
    "id": id,
    "no_induk": noInduk,
    "tgl_cuti": tglCuti,
    "lama_cuti": lamaCuti,
    "keterangan": keterangan,
  };

  factory Cuti.fromJson(Map<String, dynamic> json) => Cuti(
    id: json["id"],
    noInduk: json["no_induk"],
    tglCuti: json["tgl_cuti"],
    lamaCuti: json["lama_cuti"],
    keterangan: json["keterangan"],
  );

  List<Cuti> parseCuti(String json) {
    if (json == null) {
      return [];
    }

    final List parsed = jsonDecode(json);
    return parsed.map((json) => Cuti.fromJson(json)).toList();
  }
}

class Sisa {
  Sisa({
    this.noInduk,
    this.sisa,
  });

  String noInduk;
  int sisa;
}