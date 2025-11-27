-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`PurchaseOrder_Master`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PurchaseOrder_Master` (
  `PO_ID` VARCHAR(45) NOT NULL,
  `OrderDate` DATE NOT NULL,
  `RequestedDeliveryDate` DATE NOT NULL,
  `Quantity Ordered` INT NOT NULL,
  `Price/Unit` DECIMAL NOT NULL,
  `Part_ID` VARCHAR(45) NOT NULL,
  `InboundShipment_ShipmentID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PO_ID`),
  UNIQUE INDEX `PO_ID_UNIQUE` (`PO_ID` ASC) VISIBLE,
  INDEX `fk_PurchaseOrder_Master_InboundShipment1_idx` (`InboundShipment_ShipmentID` ASC) VISIBLE,
  CONSTRAINT `fk_PurchaseOrder_Master_InboundShipment1`
    FOREIGN KEY (`InboundShipment_ShipmentID`)
    REFERENCES `mydb`.`InboundShipment` (`ShipmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`InboundShipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`InboundShipment` (
  `ShipmentID` VARCHAR(45) NOT NULL,
  `ReceivingPlantID` VARCHAR(45) NOT NULL,
  `SupplierPlantID` VARCHAR(45) NOT NULL,
  `TrackingNumber` VARCHAR(45) NOT NULL,
  `ActualArrivalTimestamp` DATETIME NOT NULL,
  `PurchaseOrder_Master_PO_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ShipmentID`),
  UNIQUE INDEX `TrackingNumber_UNIQUE` (`TrackingNumber` ASC) VISIBLE,
  UNIQUE INDEX `ShipmentID_UNIQUE` (`ShipmentID` ASC) VISIBLE,
  INDEX `fk_InboundShipment_PurchaseOrder_Master1_idx` (`PurchaseOrder_Master_PO_ID` ASC) VISIBLE,
  CONSTRAINT `fk_InboundShipment_PurchaseOrder_Master1`
    FOREIGN KEY (`PurchaseOrder_Master_PO_ID`)
    REFERENCES `mydb`.`PurchaseOrder_Master` (`PO_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Component_Parts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Component_Parts` (
  `Part_ID` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(45) NOT NULL,
  `Material_Type` VARCHAR(45) NOT NULL,
  `unit_of_measure` VARCHAR(45) NOT NULL,
  `is_critical` TINYINT NOT NULL,
  `Standard_cost` DECIMAL NOT NULL,
  `LineItems_SourcingContract_LineItemID` VARCHAR(45) NOT NULL,
  `PO_LineItems_PO_ID` VARCHAR(45) NOT NULL,
  `PO_LineItems_PartID` VARCHAR(45) NOT NULL,
  `InboundShipment_ShipmentID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Part_ID`),
  UNIQUE INDEX `Part_ID_UNIQUE` (`Part_ID` ASC) VISIBLE,
  INDEX `fk_Component_Parts_InboundShipment1_idx` (`InboundShipment_ShipmentID` ASC) VISIBLE,
  CONSTRAINT `fk_Component_Parts_InboundShipment1`
    FOREIGN KEY (`InboundShipment_ShipmentID`)
    REFERENCES `mydb`.`InboundShipment` (`ShipmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Suppliers` (
  `Supplier_ID` VARCHAR(45) NOT NULL,
  `Supplier_Name` VARCHAR(100) NOT NULL,
  `Supplier_Location_city` VARCHAR(100) NOT NULL,
  `Supplier_Location_country` VARCHAR(100) NOT NULL,
  `Supplier_Tier` VARCHAR(5) NOT NULL,
  `Supplier_ph_no` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Supplier_ID`),
  UNIQUE INDEX `Supplier_ID_UNIQUE` (`Supplier_ID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProductionStatusRecord`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProductionStatusRecord` (
  `ModelID` VARCHAR(45) NOT NULL,
  `BuildStatus` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`ModelID`),
  UNIQUE INDEX `ModelID_UNIQUE` (`ModelID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Plants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Plants` (
  `Plant_ID` VARCHAR(45) NOT NULL,
  `Plant_Name` VARCHAR(100) NOT NULL,
  `Plant_Type` VARCHAR(45) NOT NULL,
  `Geographic_region` CHAR(10) NOT NULL,
  `Plant_Address` VARCHAR(200) NOT NULL,
  `ProductionStatusRecord_ModelID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Plant_ID`, `ProductionStatusRecord_ModelID`),
  UNIQUE INDEX `Plant_ID_UNIQUE` (`Plant_ID` ASC) VISIBLE,
  INDEX `fk_Plants_ProductionStatusRecord1_idx` (`ProductionStatusRecord_ModelID` ASC) VISIBLE,
  CONSTRAINT `fk_Plants_ProductionStatusRecord1`
    FOREIGN KEY (`ProductionStatusRecord_ModelID`)
    REFERENCES `mydb`.`ProductionStatusRecord` (`ModelID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`OutboundShipments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`OutboundShipments` (
  `shipment_id` VARCHAR(45) NOT NULL,
  `CarrierID` VARCHAR(45) NOT NULL,
  `sales_order_id` VARCHAR(45) NOT NULL,
  `TrackingNumber` VARCHAR(20) NOT NULL,
  `ShipmentDate` DATE NOT NULL,
  `DeliveryStatus` VARCHAR(20) NOT NULL,
  `CustomerID` VARCHAR(45) NULL,
  PRIMARY KEY (`shipment_id`),
  UNIQUE INDEX `shipment_id_UNIQUE` (`shipment_id` ASC) VISIBLE,
  UNIQUE INDEX `TrackingNumber_UNIQUE` (`TrackingNumber` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Customer` (
  `CustomerID` VARCHAR(45) NOT NULL,
  `CustomerName` VARCHAR(45) NOT NULL,
  `CustomerType` VARCHAR(45) NOT NULL,
  `ShippingAddress` VARCHAR(200) NOT NULL,
  `BillingContactno.` VARCHAR(45) NOT NULL,
  `CreditLimit` DECIMAL NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `CustomerID_UNIQUE` (`CustomerID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`SalesOrders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SalesOrders` (
  `sales_order_id` VARCHAR(45) NOT NULL,
  `OrderDate` DATE NOT NULL,
  `RequiredShipDate` DATE NOT NULL,
  `OrderStatus` VARCHAR(20) NOT NULL,
  `Quanrityordered` INT NOT NULL,
  `Price` DECIMAL NOT NULL,
  `Customer_CustomerID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sales_order_id`),
  UNIQUE INDEX `sales_order_id_UNIQUE` (`sales_order_id` ASC) VISIBLE,
  INDEX `fk_SalesOrders_Customer1_idx` (`Customer_CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_SalesOrders_Customer1`
    FOREIGN KEY (`Customer_CustomerID`)
    REFERENCES `mydb`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Vehicle_Model_Config`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Vehicle_Model_Config` (
  `Model_ID` VARCHAR(45) NOT NULL,
  `ModelName` VARCHAR(45) NOT NULL,
  `BaseMSRP` DECIMAL NOT NULL,
  `TargetLeadTimeDays` INT NOT NULL,
  `OutboundShipments_shipment_id` VARCHAR(45) NOT NULL,
  `SalesOrders_sales_order_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Model_ID`),
  UNIQUE INDEX `ModelName_UNIQUE` (`ModelName` ASC) VISIBLE,
  UNIQUE INDEX `Model_ID_UNIQUE` (`Model_ID` ASC) VISIBLE,
  INDEX `fk_Vehicle_Model_Config_OutboundShipments1_idx` (`OutboundShipments_shipment_id` ASC) VISIBLE,
  INDEX `fk_Vehicle_Model_Config_SalesOrders1_idx` (`SalesOrders_sales_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_Vehicle_Model_Config_OutboundShipments1`
    FOREIGN KEY (`OutboundShipments_shipment_id`)
    REFERENCES `mydb`.`OutboundShipments` (`shipment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Vehicle_Model_Config_SalesOrders1`
    FOREIGN KEY (`SalesOrders_sales_order_id`)
    REFERENCES `mydb`.`SalesOrders` (`sales_order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`InventoryTransaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`InventoryTransaction` (
  `TransactionID` VARCHAR(45) NOT NULL,
  `PartID` VARCHAR(45) NOT NULL,
  `PlantID` VARCHAR(45) NOT NULL,
  `MovementType` VARCHAR(45) NOT NULL,
  `Quantity` INT NOT NULL,
  `TransactionDate` DATETIME NOT NULL,
  PRIMARY KEY (`TransactionID`),
  UNIQUE INDEX `TransactionID_UNIQUE` (`TransactionID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`BillofMaterials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`BillofMaterials` (
  `ModelID` VARCHAR(45) NOT NULL,
  `PartID` VARCHAR(45) NOT NULL,
  `QuantityPerUnit` INT NOT NULL,
  `PriceperUnit` DECIMAL NOT NULL,
  PRIMARY KEY (`ModelID`),
  UNIQUE INDEX `ModelID_UNIQUE` (`ModelID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ProductionSchedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProductionSchedule` (
  `ScheduleID` VARCHAR(45) NOT NULL,
  `ModelID` VARCHAR(45) NOT NULL,
  `PlannedQuantity` INT NOT NULL,
  `EstimatedDaysForCompletion` INT NOT NULL,
  PRIMARY KEY (`ScheduleID`),
  UNIQUE INDEX `ScheduleID_UNIQUE` (`ScheduleID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Carriers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Carriers` (
  `carrier_id` VARCHAR(45) NOT NULL,
  `carrier_name` VARCHAR(45) NOT NULL,
  `contact_info` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`carrier_id`),
  UNIQUE INDEX `contact_info_UNIQUE` (`contact_info` ASC) VISIBLE,
  UNIQUE INDEX `carrier_id_UNIQUE` (`carrier_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Component_Parts_has_Suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Component_Parts_has_Suppliers` (
  `Component_Parts_Part_ID` VARCHAR(45) NOT NULL,
  `Suppliers_Supplier_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Component_Parts_Part_ID`, `Suppliers_Supplier_ID`),
  INDEX `fk_Component_Parts_has_Suppliers_Suppliers1_idx` (`Suppliers_Supplier_ID` ASC) VISIBLE,
  INDEX `fk_Component_Parts_has_Suppliers_Component_Parts_idx` (`Component_Parts_Part_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Component_Parts_has_Suppliers_Component_Parts`
    FOREIGN KEY (`Component_Parts_Part_ID`)
    REFERENCES `mydb`.`Component_Parts` (`Part_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Component_Parts_has_Suppliers_Suppliers1`
    FOREIGN KEY (`Suppliers_Supplier_ID`)
    REFERENCES `mydb`.`Suppliers` (`Supplier_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PurchaseOrder_Master_has_Suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PurchaseOrder_Master_has_Suppliers` (
  `PurchaseOrder_Master_PO_ID` VARCHAR(45) NOT NULL,
  `Suppliers_Supplier_ID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PurchaseOrder_Master_PO_ID`, `Suppliers_Supplier_ID`),
  INDEX `fk_PurchaseOrder_Master_has_Suppliers_Suppliers1_idx` (`Suppliers_Supplier_ID` ASC) VISIBLE,
  INDEX `fk_PurchaseOrder_Master_has_Suppliers_PurchaseOrder_Master1_idx` (`PurchaseOrder_Master_PO_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PurchaseOrder_Master_has_Suppliers_PurchaseOrder_Master1`
    FOREIGN KEY (`PurchaseOrder_Master_PO_ID`)
    REFERENCES `mydb`.`PurchaseOrder_Master` (`PO_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PurchaseOrder_Master_has_Suppliers_Suppliers1`
    FOREIGN KEY (`Suppliers_Supplier_ID`)
    REFERENCES `mydb`.`Suppliers` (`Supplier_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Plants_has_ProductionSchedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Plants_has_ProductionSchedule` (
  `Plants_Plant_ID` VARCHAR(45) NOT NULL,
  `ProductionSchedule_ScheduleID` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Plants_Plant_ID`, `ProductionSchedule_ScheduleID`),
  INDEX `fk_Plants_has_ProductionSchedule_ProductionSchedule1_idx` (`ProductionSchedule_ScheduleID` ASC) VISIBLE,
  INDEX `fk_Plants_has_ProductionSchedule_Plants1_idx` (`Plants_Plant_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Plants_has_ProductionSchedule_Plants1`
    FOREIGN KEY (`Plants_Plant_ID`)
    REFERENCES `mydb`.`Plants` (`Plant_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Plants_has_ProductionSchedule_ProductionSchedule1`
    FOREIGN KEY (`ProductionSchedule_ScheduleID`)
    REFERENCES `mydb`.`ProductionSchedule` (`ScheduleID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Carriers_has_OutboundShipments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Carriers_has_OutboundShipments` (
  `Carriers_carrier_id` VARCHAR(45) NOT NULL,
  `OutboundShipments_shipment_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Carriers_carrier_id`, `OutboundShipments_shipment_id`),
  INDEX `fk_Carriers_has_OutboundShipments_OutboundShipments1_idx` (`OutboundShipments_shipment_id` ASC) VISIBLE,
  INDEX `fk_Carriers_has_OutboundShipments_Carriers1_idx` (`Carriers_carrier_id` ASC) VISIBLE,
  CONSTRAINT `fk_Carriers_has_OutboundShipments_Carriers1`
    FOREIGN KEY (`Carriers_carrier_id`)
    REFERENCES `mydb`.`Carriers` (`carrier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Carriers_has_OutboundShipments_OutboundShipments1`
    FOREIGN KEY (`OutboundShipments_shipment_id`)
    REFERENCES `mydb`.`OutboundShipments` (`shipment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`InboundShipment_has_Carriers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`InboundShipment_has_Carriers` (
  `InboundShipment_ShipmentID` VARCHAR(45) NOT NULL,
  `Carriers_carrier_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InboundShipment_ShipmentID`, `Carriers_carrier_id`),
  INDEX `fk_InboundShipment_has_Carriers_Carriers1_idx` (`Carriers_carrier_id` ASC) VISIBLE,
  INDEX `fk_InboundShipment_has_Carriers_InboundShipment1_idx` (`InboundShipment_ShipmentID` ASC) VISIBLE,
  CONSTRAINT `fk_InboundShipment_has_Carriers_InboundShipment1`
    FOREIGN KEY (`InboundShipment_ShipmentID`)
    REFERENCES `mydb`.`InboundShipment` (`ShipmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_InboundShipment_has_Carriers_Carriers1`
    FOREIGN KEY (`Carriers_carrier_id`)
    REFERENCES `mydb`.`Carriers` (`carrier_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Inventory Transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`InventoryTransaction` (
  `TransactionID` VARCHAR(45) NOT NULL,
  `PartID` VARCHAR(45) NOT NULL,
  `PlantID` VARCHAR(45) NOT NULL,
  `MovementType` VARCHAR(45) NOT NULL,
  `Quantity` INT NOT NULL,
  `TransactionDate` DATETIME NOT NULL,
  PRIMARY KEY (`TransactionID`),
  UNIQUE INDEX `TransactionID_UNIQUE` (`TransactionID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bill of Materials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`BillofMaterials` (
  `ModelID` VARCHAR(45) NOT NULL,
  `PartID` VARCHAR(45) NOT NULL,
  `QuantityPerUnit` INT NOT NULL,
  `Price/Unit` DECIMAL NOT NULL,
  PRIMARY KEY (`ModelID`),
  UNIQUE INDEX `ModelID_UNIQUE` (`ModelID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`VehicleAssemblyLine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`VehicleAssemblyLine` (
  `VIN` VARCHAR(17) NOT NULL,
  `ModelID` VARCHAR(45) NOT NULL,
  `PlantID` VARCHAR(45) NOT NULL,
  `BuildStatus` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`VIN`),
  UNIQUE INDEX `VIN_UNIQUE` (`VIN` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- Suppliers
INSERT INTO Suppliers (Supplier_ID, Supplier_Name, Supplier_Location_city, Supplier_Location_country, Supplier_Tier, Supplier_ph_no) VALUES
('SUP001','Bosch','Stuttgart','Germany','T1','+49-711-123456'),
('SUP002','Magna','Toronto','Canada','T1','+1-416-987654'),
('SUP003','Denso','Nagoya','Japan','T1','+81-52-111222'),
('SUP004','Valeo','Paris','France','T2','+33-1-555444'),
('SUP005','ZF','Munich','Germany','T1','+49-89-333222'),
('SUP006','Lear','Detroit','USA','T2','+1-313-555777'),
('SUP007','Continental','Hanover','Germany','T1','+49-511-888999'),
('SUP008','Aisin','Tokyo','Japan','T1','+81-3-444555');

-- Customer
INSERT INTO Customer (CustomerID, CustomerName, CustomerType, ShippingAddress, `BillingContactno.`, CreditLimit) VALUES
('CUST001','Ford Dealers East','Retail','123 Main St, NY','+1-212-555111',500000),
('CUST002','Ford Dealers West','Retail','456 Sunset Blvd, LA','+1-310-555222',450000),
('CUST003','FleetCo','Fleet','789 Industrial Rd, Chicago','+1-773-555333',1000000),
('CUST004','Govt Procurement','Institutional','101 Capitol Hill, DC','+1-202-555444',2000000),
('CUST005','Ford Europe','Retail','12 Oxford St, London','+44-20-555555',600000),
('CUST006','Ford Asia','Retail','88 Orchard Rd, Singapore','+65-555666',700000),
('CUST007','Ford Africa','Retail','77 Nelson Mandela Ave, Johannesburg','+27-11-555777',300000),
('CUST008','Ford Latin America','Retail','99 Paulista Ave, Sao Paulo','+55-11-555888',400000);

-- Carriers
INSERT INTO Carriers (carrier_id, carrier_name, contact_info) VALUES
('CAR001','DHL','+49-555111'),
('CAR002','FedEx','+1-800-555222'),
('CAR003','UPS','+1-800-555333'),
('CAR004','Maersk','+45-555444'),
('CAR005','DB Schenker','+49-555555'),
('CAR006','Kuehne+Nagel','+41-555666'),
('CAR007','XPO Logistics','+1-800-555777'),
('CAR008','BlueDart','+91-22-555888');

-- ProductionStatusRecord
INSERT INTO ProductionStatusRecord (ModelID, BuildStatus) VALUES
('MOD001','InProgress'),
('MOD002','Completed'),
('MOD003','Delayed'),
('MOD004','InProgress'),
('MOD005','Completed'),
('MOD006','InProgress'),
('MOD007','Delayed'),
('MOD008','Completed');

-- Plants (composite PK requires ProductionStatusRecord_ModelID present)
INSERT INTO Plants (Plant_ID, Plant_Name, Plant_Type, Geographic_region, Plant_Address, ProductionStatusRecord_ModelID) VALUES
('PLANT001','Ford Michigan Assembly','Assembly','NA','200 Henry Ford Blvd','MOD001'),
('PLANT002','Ford Kentucky Truck','Assembly','NA','300 Louisville Rd','MOD002'),
('PLANT003','Ford Valencia','Assembly','EU','400 Valencia St','MOD003'),
('PLANT004','Ford Chennai','Assembly','AS','500 Chennai Rd','MOD004'),
('PLANT005','Ford Pretoria','Assembly','AF','600 Pretoria Rd','MOD005'),
('PLANT006','Ford Sao Paulo','Assembly','SA','700 Sao Paulo Rd','MOD006'),
('PLANT007','Ford Cologne','Assembly','EU','800 Cologne Rd','MOD007'),
('PLANT008','Ford Shanghai','Assembly','AS','900 Shanghai Rd','MOD008');

-- =========================
-- 2. Intermediate Tables
-- NOTE: PurchaseOrder_Master and InboundShipment form a circular FK.
-- We temporarily disable FK checks to insert consistent sample data.
-- =========================

SET FOREIGN_KEY_CHECKS = 0;

-- PurchaseOrder_Master
INSERT INTO PurchaseOrder_Master (`PO_ID`, `OrderDate`, `RequestedDeliveryDate`, `Quantity Ordered`, `Price/Unit`, `Part_ID`, `InboundShipment_ShipmentID`) VALUES
('PO001','2025-01-10','2025-02-01',100,50.00,'PART001','SHIP001'),
('PO002','2025-01-12','2025-02-05',200,75.00,'PART002','SHIP002'),
('PO003','2025-01-15','2025-02-10',150,120.00,'PART003','SHIP003'),
('PO004','2025-01-20','2025-02-15',300,30.00,'PART004','SHIP004'),
('PO005','2025-01-25','2025-02-20',400,45.00,'PART005','SHIP005'),
('PO006','2025-02-01','2025-02-25',250,60.00,'PART006','SHIP006'),
('PO007','2025-02-05','2025-03-01',350,80.00,'PART007','SHIP007'),
('PO008','2025-02-10','2025-03-05',500,100.00,'PART008','SHIP008');

-- InboundShipment
INSERT INTO InboundShipment (ShipmentID, ReceivingPlantID, SupplierPlantID, TrackingNumber, ActualArrivalTimestamp, PurchaseOrder_Master_PO_ID) VALUES
('SHIP001','PLANT001','SUP001','TRK001','2025-01-30 10:00:00','PO001'),
('SHIP002','PLANT002','SUP002','TRK002','2025-02-02 12:00:00','PO002'),
('SHIP003','PLANT003','SUP003','TRK003','2025-02-08 09:00:00','PO003'),
('SHIP004','PLANT004','SUP004','TRK004','2025-02-12 14:00:00','PO004'),
('SHIP005','PLANT005','SUP005','TRK005','2025-02-18 16:00:00','PO005'),
('SHIP006','PLANT006','SUP006','TRK006','2025-02-22 11:00:00','PO006'),
('SHIP007','PLANT007','SUP007','TRK007','2025-02-28 13:00:00','PO007'),
('SHIP008','PLANT008','SUP008','TRK008','2025-03-03 15:00:00','PO008');

SET FOREIGN_KEY_CHECKS = 1;

-- SalesOrders
INSERT INTO SalesOrders (sales_order_id, OrderDate, RequiredShipDate, OrderStatus, Quanrityordered, Price, Customer_CustomerID) VALUES
('SO001','2025-01-05','2025-01-20','Confirmed',50,25000,'CUST001'),
('SO002','2025-01-07','2025-01-25','Shipped',75,37500,'CUST002'),
('SO003','2025-01-10','2025-01-30','Confirmed',100,50000,'CUST003'),
('SO004','2025-01-12','2025-02-01','Pending',150,75000,'CUST004'),
('SO005','2025-01-15','2025-02-05','Confirmed',200,100000,'CUST005'),
('SO006','2025-01-18','2025-02-10','Shipped',250,125000,'CUST006'),
('SO007','2025-01-20','2025-02-15','Confirmed',300,150000,'CUST007'),
('SO008','2025-01-25','2025-02-20','Pending',400,200000,'CUST008');

-- OutboundShipments
INSERT INTO OutboundShipments (shipment_id, CarrierID, sales_order_id, TrackingNumber, ShipmentDate, DeliveryStatus, CustomerID) VALUES
('OUT001','CAR001','SO001','OUTTRK001','2025-01-21','Delivered','CUST001'),
('OUT002','CAR002','SO002','OUTTRK002','2025-01-26','Delivered','CUST002'),
('OUT003','CAR003','SO003','OUTTRK003','2025-01-31','InTransit','CUST003'),
('OUT004','CAR004','SO004','OUTTRK004','2025-02-02','Pending','CUST004'),
('OUT005','CAR005','SO005','OUTTRK005','2025-02-06','Delivered','CUST005'),
('OUT006','CAR006','SO006','OUTTRK006','2025-02-11','InTransit','CUST006'),
('OUT007','CAR007','SO007','OUTTRK007','2025-02-16','Pending','CUST007'),
('OUT008','CAR008','SO008','OUTTRK008','2025-02-21','Delivered','CUST008');

-- =========================
-- 3. Child Tables
-- =========================

-- Component_Parts
INSERT INTO Component_Parts (Part_ID, Description, Material_Type, unit_of_measure, is_critical, Standard_cost, LineItems_SourcingContract_LineItemID, PO_LineItems_PO_ID, PO_LineItems_PartID, InboundShipment_ShipmentID) VALUES
('PART001','Engine Block','Steel','pcs',1,500.00,'LINE001','PO001','PART001','SHIP001'),
('PART002','Gearbox','Aluminum','pcs',1,750.00,'LINE002','PO002','PART002','SHIP002'),
('PART003','Brake System','Composite','pcs',1,300.00,'LINE003','PO003','PART3','SHIP003'),
('PART004','Suspension','Steel','pcs',0,200.00,'LINE004','PO004','PART004','SHIP004'),
('PART005','Steering Column','Aluminum','pcs',0,150.00,'LINE005','PO005','PART005','SHIP005'),
('PART006','Fuel Pump','Plastic','pcs',1,100.00,'LINE006','PO006','PART006','SHIP006'),
('PART007','Radiator','Aluminum','pcs',1,250.00,'LINE007','PO007','PART007','SHIP007'),
('PART008','Transmission Shaft','Steel','pcs',1,400.00,'LINE008','PO008','PART008','SHIP008');

-- InventoryTransaction
INSERT INTO InventoryTransaction (TransactionID, PartID, PlantID, MovementType, Quantity, TransactionDate) VALUES
('TX001','PART001','PLANT001','Inbound',100,'2025-01-30 11:00:00'),
('TX002','PART002','PLANT002','Inbound',200,'2025-02-02 13:00:00'),
('TX003','PART003','PLANT003','Inbound',150,'2025-02-08 10:00:00'),
('TX004','PART004','PLANT004','Inbound',300,'2025-02-12 15:00:00'),
('TX005','PART005','PLANT005','Inbound',400,'2025-02-18 17:00:00'),
('TX006','PART006','PLANT006','Inbound',250,'2025-02-22 12:00:00'),
('TX007','PART007','PLANT007','Inbound',350,'2025-02-28 14:00:00'),
('TX008','PART008','PLANT008','Inbound',500,'2025-03-03 16:00:00');

-- BillofMaterials
INSERT INTO BillofMaterials (ModelID, PartID, QuantityPerUnit, PriceperUnit) VALUES
('MOD001','PART001',1,500.00),
('MOD002','PART002',1,750.00),
('MOD003','PART003',4,300.00),
('MOD004','PART004',2,200.00),
('MOD005','PART005',1,150.00),
('MOD006','PART006',1,100.00),
('MOD007','PART007',1,250.00),
('MOD008','PART008',1,400.00);

-- ProductionSchedule
INSERT INTO ProductionSchedule (ScheduleID, ModelID, PlannedQuantity, EstimatedDaysForCompletion) VALUES
('SCH001','MOD001',100,10),
('SCH002','MOD002',150,12),
('SCH003','MOD003',200,15),
('SCH004','MOD004',250,18),
('SCH005','MOD005',300,20),
('SCH006','MOD006',350,22),
('SCH007','MOD007',400,25),
('SCH008','MOD008',450,28);

-- Vehicle_Model_Config
INSERT INTO Vehicle_Model_Config (Model_ID, ModelName, BaseMSRP, TargetLeadTimeDays, OutboundShipments_shipment_id, SalesOrders_sales_order_id) VALUES
('MOD001','Ford F-150',35000,30,'OUT001','SO001'),
('MOD002','Ford Mustang',40000,25,'OUT002','SO002'),
('MOD003','Ford Explorer',32000,28,'OUT003','SO003'),
('MOD004','Ford EcoSport',22000,20,'OUT004','SO004'),
('MOD005','Ford Ranger',28000,22,'OUT005','SO005'),
('MOD006','Ford Transit',30000,26,'OUT006','SO006'),
('MOD007','Ford Focus',25000,24,'OUT007','SO007'),
('MOD008','Ford Edge',33000,27,'OUT008','SO008');
-- Suppliers
SELECT * FROM Suppliers LIMIT 2;

-- Customer
SELECT * FROM Customer LIMIT 2;

-- Carriers
SELECT * FROM Carriers LIMIT 2;

-- ProductionStatusRecord
SELECT * FROM ProductionStatusRecord LIMIT 2;

-- Plants
SELECT * FROM Plants LIMIT 2;

-- PurchaseOrder_Master
SELECT * FROM PurchaseOrder_Master LIMIT 2;

-- InboundShipment
SELECT * FROM InboundShipment LIMIT 2;

-- SalesOrders
SELECT * FROM SalesOrders LIMIT 2;

-- OutboundShipments
SELECT * FROM OutboundShipments LIMIT 2;

-- Component_Parts
SELECT * FROM Component_Parts LIMIT 2;

-- InventoryTransaction
SELECT * FROM InventoryTransaction LIMIT 2;

-- BillofMaterials
SELECT * FROM BillofMaterials LIMIT 2;

-- ProductionSchedule
SELECT * FROM ProductionSchedule LIMIT 2;

-- Vehicle_Model_Config
SELECT * FROM Vehicle_Model_Config LIMIT 2;