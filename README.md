# ☎️ Logiciel Superviseur OPE

**Superviseur OPE** est un logiciel desktop développé en **C++** avec **Qt** permettant de déterminer la caserne de pompiers la plus proche d'un sinistre.

L'application utilise des données issues de **OpenStreetMap**, stockées dans une base **SQLite**, et calcule les distances géographiques grâce à la formule de **Haversine**.

Une fois la caserne la plus proche identifiée, le logiciel transmet automatiquement une alerte d'intervention au serveur de la caserne concernée.

## 📌 Fonctionnalités

- ✅ Stockage des casernes dans une base SQLite
- ✅ Filtrage des casernes par département / SDIS (ex : SDIS 22)
- ✅ Conversion des coordonnées du sinistre latitude / longitude à partir de l'adresse 
- ✅ Calcul de la distance géographique avec la formule de Haversine
- ✅ Interface graphique réalisée avec Qt Quick
- ✅ Affichage de la distance entre le sinistre et la caserne
- ✅ Envoi d'une alerte d'intervention à la caserne la plus proche
- ✅ Stockage des alerters "en cours" et "terminée" dans la BDD sqlite3

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
- 📢 Envoyer une alerte d'intervention à la caserne la plus proche
- 💽 Visionnage des alertes "en cours" ou "terminée"


### Aperçu de l'application

![Interface opérateur](https://github.com/user-attachments/assets/b9b63612-1b01-403c-aa14-1ec4f9aaeaed)
<img width="1919" height="1027" alt="image" src="https://github.com/user-attachments/assets/084e49b2-d347-49d6-abe3-c75820c8db4a" />


## 🗃️ Structure de la base de données

### `CasernesBZH.db` comprend 4 tables : 

- casernes_tmp
- interventions
- servers
- sinistres

#### Description des champs

casernes_tmp

| Champ      | Type | Description                        |
| ---------- | ---- | ---------------------------------- |
| `id`       | TEXT | Identifiant OpenStreetMap          |
| `name`     | TEXT | Nom de la caserne                  |
| `lat`      | REAL | Latitude                           |
| `lon`      | REAL | Longitude                          |
| `city`     | TEXT | Ville                              |
| `postcode` | TEXT | Code postal                        |
| `operator` | TEXT | Organisme opérateur (ex : SDIS 22) |

interventions

| Champ              | Type    | Description                   |
| ------------------ | ------- | ----------------------------- |
| `id`               | INTEGER | Identifiant de l'intervention |
| `adresse`          | TEXT    | Adresse de l'intervention     |
| `casernes_assigne` | TEXT    | Casernes assignées            |
| `type`             | TEXT    | Type d'intervention           |
| `gravite`          | TEXT    | Gravité de l'intervention     |
| `date`             | TEXT    | Date de l'intervention        |
| `heure`            | TEXT    | Heure de l'intervention       |
| `victimes`         | INTEGER | Nombre de victimes            |
| `commentaire`      | TEXT    | Commentaire associé           |
| `statut`           | TEXT    | Statut de l'intervention      |

servers

| Champ  | Type    | Description              |
| ------ | ------- | ------------------------ |
| `id`   | INTEGER | Identifiant du serveur   |
| `ip`   | TEXT    | Adresse IP du serveur    |
| `port` | INTEGER | Port d'écoute du serveur |

sinistres

| Champ         | Type     | Description               |
| ------------- | -------- | ------------------------- |
| `id`          | INTEGER  | Identifiant du sinistre   |
| `type`        | TEXT     | Type de sinistre          |
| `description` | TEXT     | Description du sinistre   |
| `latitude`    | REAL     | Latitude du sinistre      |
| `longitude`   | REAL     | Longitude du sinistre     |
| `created_at`  | DATETIME | Date et heure de création |


## 📬 Serveur Caserne OPE

Le Serveur Caserne OPE est un logiciel serveur console (C++ et Qt) installé dans chaque caserne.

- 🔄 Fonctionne 24h/24
- 📨 Reçoit les alertes d'intervention depuis le logiciel operateur
- 💾 Enregistre les alertes dans une base MariaDB
- 🎛️ Permet une gestion locale des interventions

Image fonctionnement server lors de la reception d'une alerte:
  <img width="1003" height="377" alt="image" src="https://github.com/user-attachments/assets/fce7aa76-ad4d-4809-82f5-e3a97e0cc195" />

<img width="1080" height="402" alt="image" src="https://github.com/user-attachments/assets/0f41ad10-d4dc-4f4e-bf1f-36f771122851" />


## ✏️ Structure HeaderPacket pour TCP

Le struct HeaderPacket est utilsé pour définir l’en-tête d’un paquet TCP. L’idée est que chaque paquet envoyé sur le réseau commence par ce header, qui contient les informations nécessaires pour que le destinataire (serveur de la caserne) comprenne comment traiter le reste des données (le payload).

```c++
struct HeaderPacket {
    uint32_t size;       // Taille du payload (données JSON) en octets
    uint16_t type;       // Type de paquet (ex : intervention, sinistre, statut serveur…)
    uint16_t server_id;  // Identifiant du centre d’appel émetteur (0 = phase de test)
};
```
