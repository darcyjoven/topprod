/*
================================================================================
檔案代號:rww_file
檔案名稱:营运中心业绩分配单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rww_file
(
rww01       varchar2(20) DEFAULT ' ' NOT NULL,
rww02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rww03       varchar2(10),            /*员工编号                               */
rww04       number(20,6) DEFAULT '0' NOT NULL,
rwwlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rwwplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table rww_file add  constraint rww_pk primary key  (rww01,rww02) enable validate;
grant select on rww_file to tiptopgp;
grant update on rww_file to tiptopgp;
grant delete on rww_file to tiptopgp;
grant insert on rww_file to tiptopgp;
grant index on rww_file to public;
grant select on rww_file to ods;
