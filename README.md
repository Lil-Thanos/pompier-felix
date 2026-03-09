**Superviseur OPE** est un logiciel desktop développé en **C++** avec **Qt** permettant de déterminer la caserne de pompiers la plus proche d'un sinistre.

L'application utilise des données issues de **OpenStreetMap**, stockées dans une base **SQLite**, et calcule les distances géographiques grâce à la formule de **Haversine**.

Une fois la caserne la plus proche identifiée, le logiciel transmet automatiquement une alerte d'intervention au serveur de la caserne concernée.

## 📌 Fonctionnalités

- ✅ Import de données de casernes depuis OpenStreetMap
- ✅ Extraction des données via Overpass Turbo
- ✅ Stockage des casernes dans une base SQLite
- ✅ Filtrage des casernes par département / SDIS (ex : SDIS 22)
- ✅ Conversion des coordonnées latitude / longitude
- ✅ Calcul de la distance géographique avec la formule de Haversine
- ✅ Interface graphique réalisée avec Qt Widgets et Qt Quick
- ✅ Affichage de la distance entre le sinistre et la caserne
- ✅ Envoi d'une alerte d'intervention à la caserne la plus proche

## 🗺️ Source des données

Les données des casernes proviennent de **OpenStreetMap** et sont récupérées via **Overpass Turbo**.

### Champs utilisés

| Champ | Description |
|-------|-------------|
| `@id` | Identifiant OpenStreetMap |
| `name` | Nom de la caserne |
| `lat` | Latitude |
| `lon` | Longitude |
| `addr:city` | Ville |
| `addr:postcode` | Code postal |
| `operator` | Opérateur (ex : SDIS 22, SDIS 29, etc.) |

### Processus d'import

1. Extraction via Overpass Turbo
2. Export au format CSV
3. Nettoyage des données
4. Import dans la base SQLite

## 🖥️ Interface opérateur

L'interface permet à l'opérateur de :

- 📍 Déclarer un sinistre
- 🔍 Calculer la caserne la plus proche
- 📢 Envoyer une alerte d'intervention

### Aperçu de l'application

![Interface opérateur](https://github.com/user-attachments/assets/b9b63612-1b01-403c-aa14-1ec4f9aaeaed)

## 🗃️ Structure de la base de données

### Table `casernes_tmp`

Cette table contient les informations des casernes importées depuis OpenStreetMap.

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

```

#### Description des champs

| Champ | Type | Description |
|-------|------|-------------|
| `id` | TEXT | Identifiant OpenStreetMap |
| `name` | TEXT | Nom de la caserne |
| `lat` | REAL | Latitude |
| `lon` | REAL | Longitude |
| `city` | TEXT | Ville |
| `postcode` | TEXT | Code postal |
| `operator` | TEXT | Organisme opérateur (ex : SDIS 22) |

## 📬 Serveur Caserne OPE

Le **Serveur Caserne OPE** est une application installée dans chaque caserne.

- 🔄 Fonctionne 24h/24
- 📨 Reçoit les alertes d'intervention
- 💾 Enregistre les alertes dans une base MariaDB
- 🎛️ Permet une gestion locale des interventions

### Table `servers`

Cette table associe une caserne à son serveur de réception d'alertes.

```sql
CREATE TABLE servers (
    id INTEGER,
    ip TEXT NOT NULL,
    port INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES casernes_tmp(id)
);

```

#### Description des champs

| Champ | Type | Description |
|-------|------|-------------|
| `id` | INTEGER | Identifiant de la caserne |
| `ip` | TEXT | Adresse IP du serveur |
| `port` | INTEGER | Port d'écoute du serveur |
