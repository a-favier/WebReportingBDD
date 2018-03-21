-- Creation de la BDD
CREATE DATABASE webReporting
    CHARACTER SET utf8
    COLLATE utf8_general_ci;

CREATE TABLE webReporting.user
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`pseudo` VARCHAR(100) UNIQUE NOT NULL,
	`mdp` VARCHAR(100) NOT NULL,
	`admin` BOOLEAN NOT NULL,
	`actif` BOOLEAN NOT NULL
)ENGINE = InnoDB;

CREATE TABLE webReporting.service
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`nom` VARCHAR(100) UNIQUE NOT NULL,
	`adresse` VARCHAR(100) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE webReporting.atelier
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`nom` VARCHAR(100) NOT NULL,
	`idService` INT,
	FOREIGN KEY(idService) REFERENCES webReporting.service(id) ON DELETE CASCADE
)ENGINE = InnoDB;

CREATE TABLE webReporting.accesService
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`idUser` INT NOT NULL,
	`idService` INT NOT NULL,
	FOREIGN KEY(idService) REFERENCES webReporting.service(id) ON DELETE CASCADE, 
	FOREIGN KEY(idUser) REFERENCES webReporting.user(id) ON DELETE CASCADE
)ENGINE = InnoDB;

CREATE TABLE webReporting.accesAtelier
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`idUser` INT NOT NULL,
	`idAtelier` INT NOT NULL,
	FOREIGN KEY(idAtelier) REFERENCES webReporting.atelier(id) ON DELETE CASCADE,
	FOREIGN KEY(idUser) REFERENCES webReporting.user(id) ON DELETE CASCADE
)ENGINE = InnoDB;

CREATE TABLE webReporting.libel
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`idService` INT NOT NULL,
	`champs` VARCHAR(255) NOT NULL,
	`libel` VARCHAR(255) NOT NULL,
	FOREIGN KEY(idService) REFERENCES webReporting.service(id) ON DELETE CASCADE
)ENGINE = InnoDB;

CREATE TABLE webReporting.req
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) UNIQUE NOT NULL,
	`text` TEXT NOT NULL,
	`nbVariable` INT NOT NULL,
	`result` BOOLEAN NOT NULL,
	`error` VARCHAR(255) NOT NULL,
	`idService` INT,
	FOREIGN KEY(idService) REFERENCES webReporting.service(id) ON DELETE CASCADE
)ENGINE = InnoDB;

CREATE TABLE webReporting.obj
(
	`id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`nom` VARCHAR(255) NOT NULL,
	`idAtelier` INT NOT NULL,
	`calcul` VARCHAR(255) NOT NULL,
	`objMax` INT,
	`objMin` INT,
	FOREIGN KEY(idAtelier) REFERENCES webReporting.atelier(id) ON DELETE CASCADE
)ENGINE = InnoDB;


INSERT INTO `webreporting`.`req` VALUES (1,'infoConnexion','SELECT user.id, user.pseudo, user.mdp, user.admin, user.actif FROM user WHERE user.pseudo = ?',1,1,'Error \'infoConnexion\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (2,'infoUser','SELECT user.id, user.pseudo, user.mdp, user.admin FROM user WHERE user.id = ?',1,1,'Error \'infoConnexion\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (3,'accesService','SELECT idService FROM accesservice WHERE idUser = ?',1,1,'Error \'accesService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (4,'accesAtelier','SELECT idAtelier FROM accesatelier WHERE idUser = ?',1,1,'Error \'accesAtelier\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (5,'infoService','SELECT service.id, service.nom, service.adresse FROM service WHERE id = ?',1,1,'Error \'infoService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (6,'infoServiceAdresse','SELECT service.id, service.nom, service.adresse FROM service WHERE service.id = ?',1,1,'Error \'infoServiceAdresse\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (7,'AtelierInService','SELECT atelier.id, atelier.nom FROM atelier WHERE atelier.idService = ?',1,1,'Error \'AtelierInService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (8,'ServiceDuAtelier','SELECT service.id, service.nom, service.adresse, atelier.id AS \'idAtelier\', atelier.nom AS \'idNom\' FROM atelier LEFT JOIN service ON atelier.idService = service.id WHERE atelier.id = ?',1,1,'Error \'ServiceDuAtelier\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (9,'getAtelierName','SELECT nom FROM atelier WHERE id = ?',1,1,'Error \'getAtelierName\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (10,'getNbColonneTable','SELECT count(*) FROM information_schema.COLUMNS WHERE table_schema = \'webreporting\' AND table_name= ?',1,1,'Error \'getNbColonneTable\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (11,'getNomChamps','SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE table_schema = \'webreporting\' AND table_name= ? AND ORDINAL_POSITION > 6',1,1,'Error \'getNbColonneTable\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (12,'getLibelChamps','SELECT libel FROM webreporting.libel WHERE idService = ? AND champs = ?',2,1,'Error \'getLibelChamps\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (13,'createService','INSERT INTO `service` (`nom`, `adresse`) VALUES (?, ?)',2,0,'Error \'createService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (14,'idOfService','SELECT `service`.`id` FROM `service` WHERE `service`.`adresse` = ?',1,1,'Error \'idOfService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (15,'createAtelier','INSERT INTO `atelier` (`nom`, `idService`) VALUES (?, ?)',2,0,'Error \'createAtelier\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (16,'addLibel','INSERT INTO `libel` (`idService`, `champs`, `libel`) VALUES (?,?,?)',3,0,'Error \'addLibel\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (17,'listeUser','SELECT id, pseudo, mdp FROM user WHERE user.actif = 1',0,1,'Error \'listeUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (18,'listeService','SELECT `service`.`id`, `service`.`nom`, `service`.`adresse` FROM `service`',0,1,'Error \'listeService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (19,'listeAtelier',"SELECT atelier.id, atelier.nom, atelier.idService, service.nom AS 'serviceName' FROM atelier LEFT JOIN service ON atelier.idService = service.id",0,1,'Error \'listeAtelier\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (20,'listeServiceForUser','SELECT accesservice.idService, service.nom FROM accesservice LEFT JOIN service ON service.id = accesservice.idService WHERE idUser = ?',1,1,'Error \'listeServiceForUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (21,'listeAtelierForUser','SELECT accesatelier.idAtelier, atelier.nom FROM accesatelier LEFT JOIN atelier ON atelier.id = accesatelier.idAtelier WHERE idUser = ?',1,1,'Error \'listeAtelierForUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (22,'listeAtelierForService','SELECT id, nom FROM atelier where idService = ?',1,1,'Error \'listeAtelierForService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (23,'delUser','DELETE FROM `user` WHERE id=?',1,0,'Error \'delUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (24,'delService','DELETE FROM `service` WHERE id=?',1,0,'Error \'delService\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (25,'delAccesServiceUser','DELETE FROM `accesservice` WHERE idUser = ?',1,0,'Error \'delAccesServiceUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (26,'delAccesAtelierUser','DELETE FROM `accesatelier` WHERE idUser = ?',1,0,'Error \'delAccesAtelierUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (27,'insertAccesServiceUser','INSERT INTO `accesservice` (`idUser`, `idService`) VALUES (?,?)',2,0,'Error \'insertAccesServiceUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (28,'insertAccesAtelierUser','INSERT INTO `accesatelier` (`idUser`, `idAtelier`) VALUES (?,?)',2,0,'Error \'insertAccesAtelierUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (29,'updateUser','UPDATE `user` SET `pseudo` = ?, `mdp` = ?, `admin` = ? WHERE `id` = ?',4,0,'Error \'updateUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (30,'insertUser','INSERT INTO `user` (`pseudo`, `mdp`, `admin`,`actif`) VALUES (?,?,?,1)',3,0,'Error \'insertUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (31,'createReq','INSERT INTO `webreporting`.`req`(`name`, `text`, `nbVariable`, `result`, `error`, `idService`) VALUES (?, ?, ?, ?, ?, ?)',6,0,'Error \'createReq',NULL);
INSERT INTO `webreporting`.`req` VALUES (32,'objParAtelier','SELECT id, nom, calcul, objMin, objMax FROM webreporting.obj WHERE idAtelier = ?',1,1,'Error \"objParAtelier\"',NULL);
INSERT INTO `webreporting`.`req` VALUES (33,'delObj','DELETE FROM `webreporting`.`obj` WHERE id= ?',1,0,'error : delObj',NULL);
INSERT INTO `webreporting`.`req` VALUES (34,'insertObj','INSERT INTO `webreporting`.`obj`(`nom`, `idAtelier`, `calcul`, `objMin`, `objMax`) VALUES (?,?,?,?,?)',5,0,'Error : insertObj',NULL);
INSERT INTO `webreporting`.`req` VALUES (35,'listeUserInactif','SELECT id, pseudo, mdp FROM user WHERE user.actif = 0',0,1,'Error \'listeUser\'',NULL);
INSERT INTO `webreporting`.`req` VALUES (36,'desactiverUser','UPDATE webreporting.user set actif = 0 WHERE id=?',1,0,'Error : desactiverUser',NULL);
INSERT INTO `webreporting`.`req` VALUES (37,'activerUser','UPDATE webreporting.user set actif = 1 WHERE id=?',1,0,'Error : activerUser',NULL);


INSERT INTO `webreporting`.`user` (`pseudo`, `mdp`, `admin`, `actif`) VALUES ('admin','admin',1,1);


