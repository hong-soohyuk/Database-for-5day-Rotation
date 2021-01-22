# Database-for-5day-Rotation
COVID-19 마스크 5부제 운영을 위한 데이터베이스.   
2020년도 - 2학기 명지대학교 응용소프트웨어 전공 "DB설계 및 구현2" 그룹 프로젝트   
그룹원 : 강다교, 김자윤, 양지선, 홍수혁(본인)

## Purpose with the database of the project
코로나의 전파를 막기 위해 마스크의 공급이 중요해지면서, 일정 수량을 모든 사람들에게 원활히 공급하고 일정 기간 동안의 중복적인 구매를 막는 시스템의 도움이 필요한 상황이다.   

소비자가 각 소매점의 재고량을 파악할 수 있고, 필요 이상의 구매를 막아 사재기를 예방할 수 있다.   
이를 위해, 공급 판매 과정에서 소비자의 구매 이력을 남기고, 약국의 지점마다 재고를 파악하기 위한 데이터베이스를 구축한다.

## User/Data requirements and business rules.
소매점은 다른 소매점과 구분되는 고유한 사업자등록번호를 가지고, 소매점은 약국, 우체국/농협의 유형이 존재한다.   
약국은 사업자등록번호와 요양기관번호를 통해 고유하게 식별되며, 우체국/농협은 사업자등록번호와 지점번호를 통해 고유하게 식별된다.   
각 지점에 대한 상호명, 주소(시, 도로번호, 세부주소), 연락처, 재고량을 데이터베이스에 저장한다.   
마스크를 소비자에게 판매할 때에는 구매일시, 구매수량, 판매담당직원이 데이터베이스에 기록된다.   

각 소매점은 여러 명의 소비자에게 마스크를 판매할 수 있고, 반드시 이전 판매기록이 있어야 하는 것은 아니다.   
데이터베이스의 소비자는 적어도 하나 이상의 구매를 해야하며, 여러 곳의 지점에서 구입할 수 있다.   
각 소매점에는 적어도 한 명 이상의 직원이 있고, 모든 직원은 반드시 하나의 소매점에 소속되어야 한다.   

직원은 각 판매처의 직원 ID, 성명, 연락처를 기록한다.   
직원 ID는 같은 소매점 내에서 한 명의 직원을 다른 직원들과 구분짓는데 사용될 수는 있지만, 직원 자체를 유일하게 식별하는데 사용할 수는 없다.   

각 조달청은 여러 곳의 판매기관에 마스크를 분배할 수 있고, 판매기관은 해당 주소지의 지방 조달청에게만 재고를 받을 수 있다.   
조달청은 반드시 입고기록을 가질 필요는 없지만, 모든 소매점은 적어도 한번 이상 마스크를 입고 받아야한다.   

각각의 소비자는 건강보험등록코드와 성명으로 고유하게 식별된다. 소비자의 성명, 전화번호, 주소, 금주 구매수량, 구매가능 요일코드를 저장한다.   
관계를 가진 소비자의 경우 법정 대리인을 통해 대리구매가 가능하다. 대리 구매 시, 구매인의 법적 관계를 명시해 기록한다.   
법정대리인은 피보호자 한 명 혹은 그 이상에 대해 마스크 대리구매가 가능하다. 피보호자는 한 명 이상의 법정대리인을 통해 구매할 수 있다.   

또한, 소비자는 반드시 내국인의 경우와 외국인의 경우로 분류된다.   
내국인은 다른 사람들과 식별될 수 있는 고유한 주민등록번호를 가지고, 외국인은 고유한 외국인등록번호로 식별된다.   
소비자는 일주일 동안 수 차례 구매가 가능하지만 금주 구매수량을 통해 최대 구매량을 넘길 수 없도록 한다.   
소비자는 최소한 한 번 이상 구매 이력이 있어야 한다.   

조달청은 생산업체로부터 마스크를 공급받으며 지방 조달청명을 통해 구분되며, 조달청의 주소, 연락처, 공급가능수량, 누적입고량을 저장한다.   
조달청에 마스크를 공급하는 각 생산업체는 생산 업체 ID를 통해 유일하게 식별된다. 또, 생산 업체명, 주소, 연락처, 식품의약처 인증 여부를 기록한다.    

각 조달청은 여러 개의 생산업체로부터 마스크를 제공받으며, 생산업체는 여러 지역의 조달청에 마스크를 공급할 수 있다.   
모든 생산업체는 반드시 한번 이상의 공급을 해야하지만, 조달청은 반드시 공급 기록이 존재해야 하는 것은 아니다.   
생산업체가 조달청에 마스크를 공급할 때 공급 날짜와, 공급 수량 또한 기록한다.   

## Conceptual Design (Entity-Relationship Diagram)
![ERDiagram-for-requirement](https://user-images.githubusercontent.com/63241308/105463347-475c0580-5cd3-11eb-8d1c-a9df165e1e9b.jpg)

## Logical Design (Relation schema)

>>GHIR_Num : Guardian Health insurance registration number   
>>DHIR_Num : Dependent Health insurance registration number

Customer (HIR_Num, Full_Name, PhoneNum, Address, WeeklyQuantity, DayCode)   

Representative (GHIR_Num, DHIR_Num, GFull_Name, DFull_Name, Relationship)   
>Foreign Key(GHIR_Num) references Customer(HIR_Num)   
>Foreign Key(DHIR_Num) references Customer(HIR_Num)   
>Foreign Key(GFull_Name) references Customer(GFull_Name)   
>Foreign Key(DFull_Name) references Customer(DFull_Name)   

>>SSN : Social Security Number (주민등록번호)   

Resident (HIR_Num, SSN, ResidentFull_Name)   
>Foreign Key(HIR_Num) references Customer(HIR_Num)   
>Foreign Key(ResidentFull_Name) references Customer(Full_Name)

>>FRegistrantion_Num : Resident registration number   

Foreigner (FHIR_Num, FRegistration_Num, ForeignFull_Name)   
>Foreign Key(FHIR_Num) references Customer(HIR_Num)   
>Foreign Key(ForeignFull_Name) references Customer(Full_Name)   

>>BLicesnse_Num : Business license number   

RetailStore (BLicense_Num, City, Street, DetailAddress, Contact_Num, OnHand)   

Pharmacy (PBLicense_Num, InstitutionNum)   
>Foreign Key(PBLicense_Num) references RetailStore(BLicense_Num)   

PostOffice/NH (NBLicense_Num, BranchNum)   
>Foreign Key(NBLicense_Num) references RetailStore(BLicense_Num)   

SalesHistory(HIR_Num, Full_Name, BLicense_Num, DateOfPurchase, QuantityPurchased)   
>Foreign Key(HIR_Num) references Customer(HIR_Num)   
>Foreign Key(Full_Name) references Customer(Full_Name)   
>Foreign Key(BLicense_Num) references RetailStore(BLicense_Num)   

>>PPS : Public Procurement Service(조달청)   
>>Local_PPS : Local Procurement Agency   
>>Qunatity_Avail : Public Procurement Service Quantity   
>>Accum_Volume : Accumulated receiving volume   

PPS (Local_PPS, PAddress, PContact_Num, Quantity_Avail, Accum_Volume)   
>>WOG : Warehousing of Goods   

RetailStore_WOG (BLicense_Num, Local_PPS, DateReceived, QuantityReceived )    
>Foreign Key(BLicense_Num) references RetailStore(BLicense_Num)   
>Foreign Key(Local_PPS) references PPS(Local_PPS )   

>>MFDS_Approval : Ministry of Food and Drug Safety Approval(식약처인증여부)   

Manufacturer (Manufacturer_ID, MName, MAddress, MContact_Num, MFDS_Approval)   

SupplyHistory (Local_PPS, Manufacturer_ID, DateOfSupply, QuantitySupplied)   
>Foreign Key(Local_PPS) references PPS(Local_PPS )   
>Foreign Key(Manufacturer_ID) references Manufacturer(Manufacturer_ID)   

Employee (Employee_ID, BLicense_Num, EmpName, PhoneNum, WorkingDay_Code)   
>Foreign Key(BLicense_Num) references RetailStore(BLicense_Num)

## How To Use 10 useful queries.
(Sunday : 1, Monday : 2, Tuesday : 3, Wednesday : 4, Thursday : 5, Friday : 6, Saturday : 7)   

- 1, 2 : Seoul, Busan, Daejeon 중 하나를 입력한다. 영어로 입력해야하고, 대소문자 구분이 없다.   

- 3 : 샘플 데이터(full_name = ‘sample’, hir_num = '74125896325') 구매 가능 코드를 1 (일요일)에 설정한 상태이다.
SQL을 일요일에 실행한다면 변화가 생기는 샘플 레코드가 1개 생기게 된다.
나머지 월~토요일에는 조건을 만족하는 Record가 존재하지 않아 수정되는 레코드는 0개가 된다.
두 비교를 위해 조건문 두 개를 주석처리 하였음.

- 5 : 한 테이블의 모든 Record를 전부 지우고, 다른 테이블의 모든 Record의 Attribute를 변경시키는 명령어이므로, 마지막에 수행한다.

- 8 : 실험 예제 입력 값은 30181231231, hong soo hyuk.   
영어로 입력해야 하며, 대소문자 구분이 없지만 띄어쓰기와 성명의 순서는 지켜져야한다.

- 9 : 샘플 입력 값은 30181231231, hong dependent2
영어로 입력해야 하며, 대소문자 구분이 없지만 띄어쓰기와 성명의 순서는 지켜져야한다
