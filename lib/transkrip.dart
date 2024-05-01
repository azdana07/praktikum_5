import 'dart:convert';

void main() {
  String transkripJson = '''
{
  "nama": "Budi Martami",
  "nim": "A101",
  "prodi": "Teknik Informatika",
  "semester": [
    {
      "nama_semester": "Semester 1",
      "mata_kuliah": [
        {
          "nama_mk": "Algoritma dan Pemrograman",
          "nilai": "A",
          "sks": 4
        },
        {
          "nama_mk": "Matematika Dasar",
          "nilai": "B+",
          "sks": 3
        },
        {
          "nama_mk": "Fisika Dasar",
          "nilai": "B",
          "sks": 2
        }
      ]
    },
    {
      "nama_semester": "Semester 2",
      "mata_kuliah": [
        {
          "nama_mk": "Struktur Data",
          "nilai": "A",
          "sks": 4
        },
        {
          "nama_mk": "Kalkulus",
          "nilai": "A-",
          "sks": 3
        },
        {
          "nama_mk": "Statistika Dasar",
          "nilai": "B+",
          "sks": 3
        }
      ]
    }
  ]
}
''';

  // Parsing JSON
  var transkrip = jsonDecode(transkripJson);

  // Fungsi untuk mengonversi nilai ke angka
  double nilaiKeAngka(String nilai) {
    Map<String, double> konversi = {
      'A': 4.0, 'A-': 3.7, 'B+': 3.3,
      'B': 3.0, 'B-': 2.7, 'C+': 2.3,
      'C': 2.0, 'D': 1.0, 'E': 0.0
    };
    return konversi[nilai] ?? 0.0;
  }

  // Menghitung IPK
  double totalSks = 0;
  double totalNilai = 0;

  for (var semester in transkrip['semester']) {
    for (var mk in semester['mata_kuliah']) {
      double sks = mk['sks'].toDouble();
      double nilai = nilaiKeAngka(mk['nilai']);
      totalSks += sks;
      totalNilai += nilai * sks;
    }
  }

  double ipk = totalNilai / totalSks;
  
  // Cetak dengan format yang lebih rapi
  print('Nama: ${transkrip['nama']}');
  print('NIM: ${transkrip['nim']}');
  print('Program Studi: ${transkrip['prodi']}');
  print('IPK: ${ipk.toStringAsFixed(2)}');
}
