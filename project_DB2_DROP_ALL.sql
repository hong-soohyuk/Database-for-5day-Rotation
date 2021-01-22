DROP TABLE representative CASCADE constraint;
DROP TABLE customer CASCADE constraint;
DROP TABLE employee CASCADE constraint;
DROP TABLE foreigner CASCADE constraint;
DROP TABLE manufacturer CASCADE constraint;
DROP TABLE pharmacy CASCADE constraint;
DROP TABLE postofficenh CASCADE constraint;
DROP TABLE pps CASCADE constraint;
DROP TABLE resident CASCADE constraint;
DROP TABLE retailstore CASCADE constraint;
DROP TABLE retailstore_wog CASCADE constraint;
DROP TABLE saleshistory CASCADE constraint;
DROP TABLE supplyhistory CASCADE constraint;

DROP VIEW CUSTOMERVIEW;
commit;
--purge recyclebin;