/*
================================================================================
檔案代號:rwu_file
檔案名稱:营运中心门店人员销售目标设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rwu_file
(
rwu01       varchar2(10) DEFAULT ' ' NOT NULL, /*目标营运中心*/
rwu02       number(5) DEFAULT '0' NOT NULL, /*目标年度*/
rwu03       varchar2(10) DEFAULT ' ' NOT NULL, /*员工编号*/
rwu201      number(20,6) DEFAULT '0' NOT NULL, /*1月目标金额*/
rwu202      number(20,6) DEFAULT '0' NOT NULL, /*2月目标金额*/
rwu203      number(20,6) DEFAULT '0' NOT NULL, /*3月目标金额*/
rwu204      number(20,6) DEFAULT '0' NOT NULL, /*4月目标金额*/
rwu205      number(20,6) DEFAULT '0' NOT NULL, /*5月目标金额*/
rwu206      number(20,6) DEFAULT '0' NOT NULL, /*6月目标金额*/
rwu207      number(20,6) DEFAULT '0' NOT NULL, /*7月目标金额*/
rwu208      number(20,6) DEFAULT '0' NOT NULL, /*8月目标金额*/
rwu209      number(20,6) DEFAULT '0' NOT NULL, /*9月目标金额*/
rwu210      number(20,6) DEFAULT '0' NOT NULL, /*10月目标金额*/
rwu211      number(20,6) DEFAULT '0' NOT NULL, /*11月目标金额*/
rwu212      number(20,6) DEFAULT '0' NOT NULL /*12月目标金额*/
);

alter table rwu_file add  constraint rwu_pk primary key  (rwu01,rwu02,rwu03) enable validate;
grant select on rwu_file to tiptopgp;
grant update on rwu_file to tiptopgp;
grant delete on rwu_file to tiptopgp;
grant insert on rwu_file to tiptopgp;
grant index on rwu_file to public;
grant select on rwu_file to ods;
