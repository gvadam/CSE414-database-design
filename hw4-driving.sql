CREATE TABLE InsuranceCo (
  name TEXT PRIMARY KEY,
  phone INT
);
CREATE TABLE Vehicle (
  license_plate TEXT PRIMARY KEY,
  year INT,
  ssn INT UNIQUE REFERENCES Person
);
CREATE TABLE Insures (
  max_liability DOUBLE,
  iname TEXT UNIQUE REFERENCES InsuranceCo,
  vplate TEXT REFERENCES Vehicle,
  PRIMARY KEY (iname, vplate)
);
CREATE TABLE Truck (
  vplate TEXT REFERENCES Vehicle PRIMARY KEY,
  capacity INT
);
CREATE TABLE Car (
  vplate TEXT REFERENCES Vehicle PRIMARY KEY,
  make TEXT
);
CREATE TABLE Drives (
  v_plate TEXT REFERENCES Car,
  np_driver_id INT REFERENCES NonProfessionalDriver,
  PRIMARY KEY (v_plate, np_driver_id)
);
CREATE TABLE Operates (
  v_plate TEXT REFERENCES Truck,
  p_driver_id INT REFERENCES ProfessionalDriver,
  PRIMARY KEY (v_plate, p_driver_id)
);
CREATE TABLE Driver (
  driver_id INT,
  ssn INT REFERENCES Person PRIMARY key
);
CREATE TABLE NonProfessionalDriver (
  np_driver_id INT REFERENCES Driver PRIMARY KEY
);
CREATE TABLE ProfessionalDriver (
  p_driver_id INT REFERENCES Driver PRIMARY KEY,
  medical_history TEXT
);
CREATE TABLE Person (
  ssn INT PRIMARY KEY,
  name TEXT
);

-- 2) A vehicle must be insured by at most one Insurance Co
-- So, we make the references to Insurance Company and Vehcle
-- from the Insure table and the relation between Insures and Insurance Company
-- must be unique. We also creates the table for Insure because one Company
-- can have more than one Vehicles, and Insure has
-- its own attributes (maxLiability)
-- 3) Drives and Operates are different relationships because Car can be driven
-- by more than one drivers, but Truck must not have more than one driver
-- to operate.