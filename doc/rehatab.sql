/*
Navicat SQLite Data Transfer

Source Server         : rehatab
Source Server Version : 30623
Source Host           : localhost:0

Target Server Type    : SQLite
Target Server Version : 30623
File Encoding         : 65001

Date: 2012-11-09 16:09:59
*/

PRAGMA foreign_keys = OFF;

-- ----------------------------
-- Table structure for "main"."Appointment"
-- ----------------------------
DROP TABLE "main"."Appointment";
CREATE TABLE "Appointment" (
"appointmentId"  INTEGER,
"name"  VARCHAR(255),
"description"  VARCHAR(1000),
"time"  TIME NOT NULL,
"minutes"  INTEGER NOT NULL,
"iteration"  TEXT,
"validFrom"  DATETIME NOT NULL,
"validTo"  DATETIME,
"date"  DATE NOT NULL,
PRIMARY KEY ("appointmentId" ASC)
);

-- ----------------------------
-- Records of Appointment
-- ----------------------------
INSERT INTO ""."Appointment" VALUES (1, 'test', 'test', '1900-01-01T10:00:00', 60, 'w 2 123', '2012-11-09T12:14:50', null, '2012-11-09T12:14:50');

-- ----------------------------
-- Table structure for "main"."Contract"
-- ----------------------------
DROP TABLE "main"."Contract";
CREATE TABLE Contract ( contractId INTEGER PRIMARY KEY,clientId INTEGER NOT NULL,validFrom DATE NOT NULL,validTo DATE NOT NULL,value INTEGER NOT NULL,type INTEGER NOT NULL,deleted DATETIME,FOREIGN KEY ( clientId ) REFERENCES Person ( personId ));

-- ----------------------------
-- Records of Contract
-- ----------------------------
INSERT INTO ""."Contract" VALUES (1, 1, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (2, 1, '2012-10-01', '2012-10-31', 50, 0, null);
INSERT INTO ""."Contract" VALUES (3, 1, '2012-12-01', '2012-12-31', 50, 0, null);
INSERT INTO ""."Contract" VALUES (4, 1, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (5, 1, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (6, 2, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (7, 2, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (8, 2, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (9, 2, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (10, 2, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (11, 2, '2012-11-01', '2012-11-30', 50, 0, null);
INSERT INTO ""."Contract" VALUES (12, 2, '2012-11-17', '2012-11-09', 50, 0, null);

-- ----------------------------
-- Table structure for "main"."Group2Person"
-- ----------------------------
DROP TABLE "main"."Group2Person";
CREATE TABLE Group2Person (
group2PersonId INTEGER PRIMARY KEY,
groupId       INTEGER NOT NULL,
contractId                 INTEGER,
clientId                   INTEGER NOT NULL,
validFrom                   DATE,
validTo                     DATE,
FOREIGN KEY ( groupId ) REFERENCES PersonGroup ( groupId ),
FOREIGN KEY ( contractId ) REFERENCES Contract ( contractId ),
FOREIGN KEY ( clientId ) REFERENCES Person ( personId )
);

-- ----------------------------
-- Records of Group2Person
-- ----------------------------
INSERT INTO ""."Group2Person" VALUES (1, 1, -1, 2, null, null);
INSERT INTO ""."Group2Person" VALUES (2, 1, -1, 2, '2012-11-09T12:15:09', null);
INSERT INTO ""."Group2Person" VALUES (3, 1, -1, 3, '2012-11-09T12:15:57', null);
INSERT INTO ""."Group2Person" VALUES (6, 1, -1, 5, '2012-11-09T12:18:20', null);

-- ----------------------------
-- Table structure for "main"."Person"
-- ----------------------------
DROP TABLE "main"."Person";
CREATE TABLE Person ( name VARCHAR(255) NOT NULL,forename VARCHAR(255) NOT NULL,birth DATE NOT NULL,personId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,updated DATETIME,created DATETIME NOT NULL,deleted DATETIME);

-- ----------------------------
-- Records of Person
-- ----------------------------
INSERT INTO ""."Person" VALUES ('asdfasfd', 'asdfasf', '1999-12-27', 2, null, '2012-11-01T12:34:53', null);
INSERT INTO ""."Person" VALUES ('marx', 'Makur', '2012-10-12', 3, null, '2012-11-01T13:09:17', null);
INSERT INTO ""."Person" VALUES ('Marx', 'Markus ', '2000-03-12', 4, null, '2012-11-01T13:15:06', null);
INSERT INTO ""."Person" VALUES ('Marx', 'Marksu', '1979-04-12', 5, null, '2012-11-01T13:22:01', null);
INSERT INTO ""."Person" VALUES ('Marx', 'Markus', '1976-03-15', 6, null, '2012-11-01T14:12:20', null);
INSERT INTO ""."Person" VALUES ('Name', 'Neuer', '1979-02-09', 7, null, '2012-11-01T14:12:36', null);
INSERT INTO ""."Person" VALUES ('asdfasf', 'asdfsdf', '2012-10-29', 8, null, '2012-11-02T14:03:29', null);
INSERT INTO ""."Person" VALUES ('Markus', 'Hallo', '2012-11-09', 9, null, '2012-11-09T12:23:48', null);

-- ----------------------------
-- Table structure for "main"."PersonGroup"
-- ----------------------------
DROP TABLE "main"."PersonGroup";
CREATE TABLE "PersonGroup" (
"groupId"  INTEGER,
"name"  VARCHAR(255) NOT NULL,
"date"  DATETIME NOT NULL,
"minutes"  INTEGER NOT NULL,
"iterationModel"  VARCHAR(10),
"validFrom"  DATETIME,
"validTo"  DATETIME,
"appointmentId"  INTEGER,
PRIMARY KEY ("groupId" ASC),
CONSTRAINT "appointmentId" FOREIGN KEY ("appointmentId") REFERENCES "Appointment" ("appointmentId") ON DELETE CASCADE
);

-- ----------------------------
-- Records of PersonGroup
-- ----------------------------
INSERT INTO ""."PersonGroup" VALUES (1, 'fasdfasdf', '2012-11-01', '1900-01-01T12:00:00', , null, null, 1);

-- ----------------------------
-- Table structure for "main"."sqlite_sequence"
-- ----------------------------
DROP TABLE "main"."sqlite_sequence";
CREATE TABLE sqlite_sequence(name,seq);

-- ----------------------------
-- Records of sqlite_sequence
-- ----------------------------
INSERT INTO ""."sqlite_sequence" VALUES ('Person', 9);
