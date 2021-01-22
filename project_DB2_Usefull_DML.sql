--1.소비자는 제한된 view를 통해 소매점 이름과 주소, 재고량을 확인한다.

SELECT storename, city, street, detailaddress, onhand
FROM customerview
WHERE UPPER(City) = UPPER('&City')
ORDER BY storename ASC;

--2.소비자는 조회를 원하는 지역 소매점의 최근 입고 날짜와 입고 수량을 파악하고 가장 최근에 입고된 순서대로 정렬한다.

SELECT storename, street, detailaddress, datereceived, quantityreceived
FROM customerview
WHERE UPPER(City) = UPPER('&City')
ORDER BY datereceived DESC, storename ASC;

--3.소비자의 구매 가능요일과 오늘 날짜를 비교해 추가 구매를 결정한다.

UPDATE customer SET weeklyquantity = &NumOfProducts
--WHERE daycode = to_char(sysdate, 'd')
--WHERE daycode = '4'
AND hir_num = '74125896325' AND full_name = 'sample';

--4.10개 이상 구매한 고객이 있다면, 가장 최근에 구매한 기록과 소비자의 이름, 구매수량 그리고 해당 소매점의 이름과 전화전호를 나타낸다.  

SELECT storename, contact_num, full_name, MAX(dateofpurchase), SUM(quantitypurchased)
FROM saleshistory NATURAL JOIN retailstore
GROUP BY storename, contact_num, full_name
HAVING SUM(quantitypurchased) > 10;


--5.매주 일요일 마다 소비자들의 구매정보를 전부 삭제시킨다.
DELETE FROM saleshistory WHERE to_char(sysdate, 'd') = '1';
UPDATE customer
SET weeklyquantity = 0 WHERE to_char(sysdate, 'd') = '1';

--6.서울 지역 조달청에 마스크를 공급했던 생산 업체들 중 식약처 인증이 되었고, 누적 100만개 이상 공급했던 곳의 업체명, 주소, 연락처, 누적 공급량을 보인다. 많이 공급한 업체를 우선으로 정렬한다.

SELECT MName, MAddress, MContact_Num,
SUM(quantitysupplied) AS TOTALNUM_OF_SUPPLEMENT
FROM manufacturer NATURAL JOIN supplyhistory
WHERE manufacturer.mfds_approval = '1'
AND local_pps = 'SeoulLocalPPS'
GROUP BY MName, MAddress, MContact_Num
HAVING SUM(quantitysupplied) >= 1000000
ORDER BY TOTALNUM_OF_SUPPLEMENT DESC;

--7.각 도시 인구별 구매 수량을 확인하여, 일정 수량 이상인 도시의 이름과 각 구매량을 보인다.

SELECT city, SUM(quantitypurchased) AS TOTAL_AMOUNT
FROM retailstore,saleshistory
WHERE retailstore.blicense_num = saleshistory.blicense_num
GROUP BY city
HAVING SUM(quantitypurchased) >= 50
ORDER BY city ASC;

--8.어떤 소비자의 판매 과정에서 문제를 발견한 경우, 또는 소비자 중 확진자가 발견으로 구매를 담당했던 직원을 추적하기 위해 몇 날 며칠 어떤 소비자(이름 입력)에게 대면 판매했던 직원의 근무지명, 직원 성명, 연락처를 조회할 수 있다.

SELECT blicense_num, storename, empname, phonenum AS employee_Tel, contact_num AS store_Tel
FROM retailstore NATURAL JOIN employee
WHERE (workingday_code, blicense_num) IN
(SELECT TO_CHAR(saleshistory.dateofpurchase, 'd'), saleshistory.blicense_num
FROM dual, saleshistory, customer
WHERE saleshistory.hir_num = customer.hir_num AND
saleshistory.full_name = customer.full_name AND
customer.hir_num = '&HIR_Num' AND 
UPPER(customer.full_name) = UPPER('&Name'));

--9.대리구매 기록이 있던 소비자의 정보가 도용되는 것을 막을 수 있다. 예를들어, 거동이 불편한 장애인인데, 정보 도용으로 인한 구매를 막을 수 있다.

SELECT representative.gfull_name, customer.phonenum
FROM customer, representative
WHERE customer.hir_num = representative.dhir_num
AND customer.full_name = representative.dfull_name
AND (representative.dhir_num, representative.dfull_name) =
(SELECT dhir_num, dfull_name FROM representative WHERE
UPPER(DHIR_Num) = UPPER('&HIR_Num') AND UPPER(DFULL_NAME) = UPPER('&Full_Name'));

--10.약국에서의 전체 판매량과 우체국 농협에서의 전체 판매량을 비교할 수 있다.

SELECT SUM(quantitypurchased)
FROM retailstore, pharmacy, saleshistory
WHERE retailstore.blicense_num = pharmacy.pblicense_num 
AND retailstore.blicense_num = saleshistory.blicense_num
UNION
SELECT SUM(quantitypurchased)
FROM retailstore, postofficenh, saleshistory
WHERE retailstore.blicense_num = postofficenh.nblicense_num 
AND retailstore.blicense_num = saleshistory.blicense_num;