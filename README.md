🚒 Superviseur OPE – Localisation de la caserne la plus proche

Superviseur OPE est un logiciel desktop développé en C++ avec Qt permettant de déterminer la caserne de pompiers la plus proche d’un sinistre.

L'application utilise des données issues de OpenStreetMap, stockées dans une base SQLite, et calcule les distances grâce à la formule de Haversine.

Une fois la caserne la plus proche déterminée, le logiciel envoie automatiquement un formulaire d’intervention au serveur de la caserne concernée.

📌 Fonctionnalités

Import de données de casernes depuis OpenStreetMap (via Overpass Turbo)

Stockage des données dans une base SQLite

Filtrage des casernes par département / SDIS (ex : SDIS 22)

Conversion des coordonnées latitude / longitude

Calcul de la distance géographique (formule de Haversine)

Interface graphique avec Qt Widgets et Qt Quick

Affichage de la distance entre le sinistre et la caserne

Envoi automatique d’une alerte d’intervention à la caserne la plus proche

🗺️ Source des données

Les données proviennent de OpenStreetMap, récupérées via Overpass Turbo.

Les champs utilisés sont :

@id

name

lat

lon

addr:city

addr:postcode

operator (ex : SDIS 22, SDIS 29…)

Les données sont :

Exportées au format CSV

Nettoyées

Importées dans la base SQLite

🖥️ Interface opérateur

Interface utilisée par l’opérateur pour :

déclarer un sinistre

localiser la caserne la plus proche

envoyer une alerte d’intervention

Aperçu
<img width="1919" height="1034" alt="Interface opérateur 1" src="https://github.com/user-attachments/assets/b9b63612-1b01-403c-aa14-1ec4f9aaeaed" /> <img width="1919" height="1034" alt="Interface opérateur 2" src="https://github.com/user-attachments/assets/3e63a959-9a1c-4c88-bf97-2ebf1b28e022" />
🗃️ Structure de la base de données
Table casernes_tmp

Cette table contient les informations des casernes importées depuis OpenStreetMap.

CREATE TABLE casernes_tmp (
    id TEXT PRIMARY KEY,
    name TEXT,
    lat REAL,
    lon REAL,
    city TEXT,
    postcode TEXT,
    operator TEXT
);
Description des champs
Champ	Description
id	Identifiant OpenStreetMap
name	Nom de la caserne
lat	Latitude
lon	Longitude
city	Ville
postcode	Code postal
operator	Organisme opérateur (ex : SDIS 22)
📬 Serveur Caserne OPE

Le Serveur Caserne OPE est une application installée dans chaque caserne.

Ce serveur :

fonctionne 24h/24

reçoit les alertes d’intervention

enregistre les alertes dans une base MariaDB

permet l’intégration avec d’autres systèmes internes.

Table servers

Cette table permet d’associer une caserne à son serveur de réception d’alertes.

CREATE TABLE servers (
    id INTEGER,
    ip TEXT NOT NULL,
    port INTEGER NOT NULL,
    FOREIGN KEY (id) REFERENCES casernes_tmp(id)
);
Description des champs
Champ	Description
id	Identifiant de la caserne
ip	Adresse IP du serveur de la caserne
port	Port d’écoute du serveur
⚙️ Architecture simplifiée
           +----------------------+
           |  Superviseur OPE     |
           |  (poste opérateur)   |
           +----------+-----------+
                      |
                      | Calcul distance
                      | (Haversine)
                      v
           +----------------------+
           |  Base SQLite         |
           |  Casernes OSM        |
           +----------+-----------+
                      |
                      | Envoi alerte
                      v
           +----------------------+
           | Serveur Caserne OPE  |
           | (MariaDB + écoute)   |
           +----------------------+
