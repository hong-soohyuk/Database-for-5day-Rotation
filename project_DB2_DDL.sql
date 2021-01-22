CREATE TABLE Manufacturer(
    Manufacturer_ID varchar2(10) not null,
    MName varchar2(15) not null,
    MAddress varchar2(40) not null,
    MContact_Num varchar2(15),
    MFDS_Approval varchar2(2) not null,
CONSTRAINT manufacturer_pk PRIMARY KEY (Manufacturer_ID)
);

CREATE TABLE PPS(
    Local_PPS varchar2(20) not null,
    PAddress varchar2(40) not null,
    PContact_Num varchar2(15),
    Quantity_Avail NUMBER(7,0),
    Accum_Volume NUMBER(9,0),
CONSTRAINT pps_pk PRIMARY KEY (Local_PPS)
);

CREATE TABLE SupplyHistory(
    Local_PPS varchar2(20) not null,
    Manufacturer_ID varchar2(10) not null,
    DateOfSupplement DATE not null,
    QuantitySupplied NUMBER(7,0),
CONSTRAINT supply_pk PRIMARY KEY (Local_PPS, Manufacturer_ID, DateOfSupplement),
CONSTRAINT supply_pps FOREIGN KEY(Local_PPS) REFERENCES pps(Local_PPS),
CONSTRAINT supply_manu FOREIGN KEY(Manufacturer_ID) REFERENCES manufacturer (Manufacturer_ID)
);

CREATE TABLE RetailStore(
    BLicense_Num varchar2(12) not null,
    StoreName varchar2(30) not null,
    City varchar2(10),
    Street varchar2(5),
    DetailAddress varchar2(50),
    Contact_Num varchar2(15),
    OnHand NUMBER(4,0),
CONSTRAINT retail_pk PRIMARY KEY (BLicense_Num)
);

CREATE TABLE RetailStore_WOG(
    BLicense_Num varchar2(12) not null,
    Local_PPS varchar2(20) not null,
    DateReceived DATE not null,
    QuantityReceived NUMBER(4,0),

CONSTRAINT warehousing_pk PRIMARY KEY (BLicense_Num,Local_PPS,DateReceived),
CONSTRAINT warehousing_retail FOREIGN KEY(BLicense_Num) REFERENCES retailstore(BLicense_Num),
CONSTRAINT warehousing_pps FOREIGN KEY(Local_PPS) REFERENCES pps(Local_PPS)
);

CREATE TABLE Pharmacy(
    PBLicense_Num varchar2(12) not null,
    InstitutionNum varchar2(8) not null,
CONSTRAINT pharmacy_pk PRIMARY KEY (PBLicense_Num,InstitutionNum),
CONSTRAINT pharmacy_store FOREIGN KEY(PBLicense_Num) REFERENCES retailstore(BLicense_Num)
);

CREATE TABLE PostOfficeNH(
    NBLicense_Num varchar2(12) not null,
    BranchNum varchar2(7) not null,
CONSTRAINT postNH_pk PRIMARY KEY (NBLicense_Num,BranchNum),
CONSTRAINT postNH_branch FOREIGN KEY(NBLicense_Num) REFERENCES retailstore(BLicense_Num)
);

CREATE TABLE Employee(
    Employee_ID varchar2(2) not null,
    BLicense_Num varchar2(12) not null,
    EmpName varchar2(20),
    PhoneNum varchar2(15),
    WorkingDay_Code char(1) not null,

CONSTRAINT employee_pk PRIMARY KEY(Employee_ID, BLicense_Num),
CONSTRAINT employee_works FOREIGN KEY(BLicense_Num) REFERENCES retailstore(BLicense_Num)
);

CREATE TABLE customer(
    HIR_Num varchar2(11) not null,
    Full_Name varchar2(20) not null,
    PhoneNum varchar2(15),
    Address varchar2(30),
    WeeklyQuantity NUMBER(2) not null,
    DayCode char(1) not null,
CONSTRAINT customer_pk PRIMARY KEY (HIR_Num,Full_Name)
);

CREATE TABLE Foreigner(
    FHIR_Num varchar2(11) not null,
    ForeignFull_Name varchar2(20) not null,
    FRegistration_Num varchar2(15) not null,
CONSTRAINT foreigner_pk PRIMARY KEY (FHIR_Num, ForeignFull_Name, FRegistration_Num),
CONSTRAINT foreigner_fk FOREIGN KEY(FHIR_Num, ForeignFull_Name) REFERENCES customer(HIR_Num, Full_Name)
);

CREATE TABLE Resident(
    RHIR_Num varchar2(11) not null,
    RegisterFull_Name varchar2(20) not null,
    SSN varchar2(15) not null,
CONSTRAINT resident_pk PRIMARY KEY (RHIR_Num, RegisterFull_Name, SSN),
CONSTRAINT resident_fk FOREIGN KEY(RHIR_Num, RegisterFull_Name) REFERENCES customer(HIR_Num, Full_Name)
);

CREATE TABLE Representative(
    GHIR_Num varchar2(11) not null,
    GFull_Name varchar2(20) not null,
    DHIR_Num varchar2(11) not null,
    DFull_Name varchar2(20) not null,
    Relationship varchar2(10) not null,
CONSTRAINT rep_pk PRIMARY KEY (GHIR_Num, GFull_Name, DHIR_Num, DFull_Name),
CONSTRAINT guardian_fk FOREIGN KEY(GHIR_Num,GFull_Name) REFERENCES customer(HIR_Num,Full_Name),
CONSTRAINT dependent_fk FOREIGN KEY(DHIR_Num,DFull_Name) REFERENCES customer(HIR_Num, Full_Name)
);

CREATE TABLE SalesHistory(
    HIR_Num varchar2(11) not null,
    Full_Name varchar2(20) not null,
    BLicense_Num varchar2(12) not null,
    DateOfPurchase DATE not null,
    QuantityPurchased NUMBER(2) not null,

CONSTRAINT sales_pk PRIMARY KEY (HIR_Num, Full_Name, BLicense_Num, DateOfPurchase),
CONSTRAINT sales_customer FOREIGN KEY(HIR_Num,Full_Name) REFERENCES customer(HIR_Num,Full_Name),
CONSTRAINT sales_store FOREIGN KEY(BLicense_Num) REFERENCES retailstore(BLicense_Num)
);

CREATE VIEW customerview AS
SELECT *
FROM retailstore NATURAL JOIN retailstore_wog;
