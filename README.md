# 🚒 Superviseur OPE – Localisation de la caserne la plus proche

Application desktop développée en **C++ avec Qt** permettant de déterminer la **caserne de pompiers la plus proche d’un sinistre**, à partir de données **OpenStreetMap** stockées en **SQLite** et d’un calcul de distance via la **formule de Haversine**.

---

## 📌 Fonctionnalités

- Import de données de casernes issues d’OpenStreetMap (Overpass Turbo)
- Stockage des casernes dans une base de données **SQLite**
- Filtrage des casernes par département (ex : SDIS 22)
- Conversion latitude / longitude
- Calcul de la distance géographique (Haversine)
- Interface graphique avec **Qt Widgets** et **Qt Quick**
- Affichage de la distance entre un sinistre et la caserne

---

## 🗺️ Source des données

Les données proviennent de **OpenStreetMap** via **Overpass Turbo**.

Champs utilisés :
- `@id`
- `name`
- `lat`
- `lon`
- `addr:city`
- `addr:postcode`
- `operator` (ex : SDIS 22, SDIS 29, etc.)

Les données sont exportées au format **CSV**, nettoyées puis importées dans SQLite.

---

## 🗃️ Structure de la base de données

### Table `casernes_tmp`

```sql
CREATE TABLE casernes_tmp (
    id TEXT PRIMARY KEY,
    name TEXT,
    lat REAL,
    lon REAL,
    city TEXT,
    postcode TEXT,
    operator TEXT
);

# 📬 Serveur Caserne OPE

Logiciel Serveur côté caserne (tourne h24). reçois les alertes et les enregistres dans la BDD mariadb. 

```sql
CREATE TABLE servers (
    id INTEGER,
    ip TEXT NOT NULL,
    port INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES casernes_tmp(id)
);

<img width="1919" height="244" alt="image" src="https://github.com/user-attachments/assets/7c8fd230-9a11-43f5-a715-c3504e15992e" />
