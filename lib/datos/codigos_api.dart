// PASO 5 · PERSONA A (datos)
// La API no manda el nombre de la facción, solo un número ("camp": 2).
// Este mapa traduce cada número a su nombre.
// Si sale un agente con facción "Desconocida", es que la API ha añadido
// un número nuevo: basta con añadirlo aquí.

// PASO 6: carpeta de la API donde están las imágenes de ZZZ.
const String urlImagenesApi = 'https://static.nanoka.cc/assets/zzz';

const Map<int, String> faccionesApi = {
  1: 'Cunning Hares',
  2: 'Victoria Housekeeping',
  3: 'Belobog Heavy Industries',
  4: 'Sons of Calydon',
  5: 'Defensa de Nueva Eridu',
  6: 'Sección 6',
  7: 'Seguridad Pública de Nueva Eridu',
  8: 'Stars of Lyra',
  9: 'Mockingbird',
  10: 'Yunkui Summit',
  11: 'Spook Shack',
  12: 'Krampus Compliance Authority',
  13: 'Angels of Delusion',
  15: 'Phaethon',
  16: 'Roscaelifer',
  17: 'Covenant of Dayat',
};
