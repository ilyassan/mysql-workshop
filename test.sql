
DROP TABLE IF EXISTS Factures;
DROP TABLE IF EXISTS RendezVous;
DROP TABLE IF EXISTS Utilisateurs;

-- CREATION DES TABLEUX

CREATE TABLE Utilisateurs (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    type_utilisateur ENUM('patient', 'médecin') NOT NULL
);

CREATE TABLE RendezVous (
    id_rdv INT AUTO_INCREMENT PRIMARY KEY,
    id_patient INT NOT NULL,
    id_medecin INT NOT NULL,
    date_rdv DATE NOT NULL,
    status ENUM('confirmé', 'non confirmé') NOT NULL,
    FOREIGN KEY (id_patient) REFERENCES Utilisateurs(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_medecin) REFERENCES Utilisateurs(id_utilisateur) ON DELETE CASCADE
);

CREATE TABLE Factures (
    id_facture INT AUTO_INCREMENT PRIMARY KEY,
    id_rdv INT NOT NULL,
    montant DECIMAL(10, 2) NOT NULL,
    date_facture DATE NOT NULL,
    FOREIGN KEY (id_rdv) REFERENCES RendezVous(id_rdv) ON DELETE CASCADE
);



-- INSERTION

INSERT INTO Utilisateurs (nom, prenom, type_utilisateur) VALUES
('Dupont', 'Jean', 'patient'),
('Martin', 'Sophie', 'patient'),
('Lemoine', 'Alice', 'médecin'),
('Moreau', 'Pierre', 'médecin'),
('Durand', 'Claire', 'patient');

INSERT INTO RendezVous (id_patient, id_medecin, date_rdv, status) VALUES
(1, 3, '2024-01-10', 'confirmé'),
(2, 4, '2024-01-15', 'non confirmé'),
(1, 4, '2024-02-05', 'confirmé'),
(3, 3, '2024-02-10', 'non confirmé'),
(2, 3, '2024-03-01', 'confirmé'),
(5, 3, '2024-03-01', 'confirmé'),
(5, 3, '2024-03-01', 'confirmé');

INSERT INTO Factures (id_rdv, montant, date_facture) VALUES
(1, 50.00, '2024-01-11'),
(3, 75.00, '2024-02-06'),
(5, 60.00, '2024-03-02'),
(2, 0.00, '2024-01-16'),
(4, 0.00, '2024-02-11'),
(3, 75.00, '2024-02-06'),
(5, 60.00, '2024-03-02'),
(2, 0.00, '2024-01-16'),
(4, 0.00, '2024-02-11');



-- SELECTION DES DONNEES

SELECT * FROM RendezVous r
WHERE r.id_patient = 1;

SELECT * FROM RendezVous;

SELECT
    r.*,
    u1.nom as patient_name,
    u2.nom as medecin_name
FROM RendezVous r
JOIN Utilisateurs u1
ON r.id_patient = u1.id_utilisateur
JOIN Utilisateurs u2
ON r.id_medecin =  u2.id_utilisateur;


-- MODIFIER LES DONNEES

UPDATE RendezVous r
SET r.status = "confirmé"
WHERE r.status = "non confirmé"
LIMIT 1;

-- SUPPRESSION DES DONNEES

DELETE FROM Utilisateurs
LIMIT 1;


-- Les fonctions d'aggregation

SELECT
    u.nom,
    COUNT(u.nom) as rendez_vous
FROM Utilisateurs u
JOIN RendezVous r
ON u.type_utilisateur = "patient" AND r.id_patient = u.id_utilisateur
GROUP BY u.nom;


SELECT
    u.nom,
    u.prenom,
    SUM(f.montant)
FROM Utilisateurs u
JOIN RendezVous r
ON u.id_utilisateur = r.id_patient
JOIN Factures f
ON r.id_rdv = f.id_rdv
GROUP BY u.id_utilisateur;


SELECT AVG(f.montant)
FROM RendezVous r
JOIN Factures f
ON f.id_rdv = r.id_rdv
WHERE r.status = "confirmé";

SELECT AVG(f.montant)
FROM RendezVous r
JOIN Factures f
ON  r.status = "confirmé" AND f.id_rdv = r.id_rdv;


SELECT
    MAX(r.date_rdv) as plus_ancient_date,
    MIN(r.date_rdv) as plus_recent_date
FROM RendezVous r;


SELECT
    *,
    COUNT(r.id_rdv) as nombre_rdv
FROM Utilisateurs u
JOIN RendezVous r
ON u.id_utilisateur = r.id_medecin
GROUP BY u.id_utilisateur
ORDER BY nombre_rdv;