/*
================================================================================
檔案代號:rcg_file
檔案名稱:竞争对手销售资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rcg_file
(
rcg01       varchar2(20) DEFAULT ' ' NOT NULL, /*竞争对手销售单号*/
rcg02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rcg03       varchar2(10),            /*竞争对手编码                           */
rcg04       number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
rcglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rcgplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table rcg_file add  constraint rcg_pk primary key  (rcg01,rcg02) enable validate;
grant select on rcg_file to tiptopgp;
grant update on rcg_file to tiptopgp;
grant delete on rcg_file to tiptopgp;
grant insert on rcg_file to tiptopgp;
grant index on rcg_file to public;
grant select on rcg_file to ods;
