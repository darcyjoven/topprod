/*
================================================================================
檔案代號:ltm_file
檔案名稱:关账资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table ltm_file
(
ltm02       date,                    /*关帐日期                               */
ltmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltmstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ltm_file add  constraint ltm_pk primary key  (ltmstore) enable validate;
grant select on ltm_file to tiptopgp;
grant update on ltm_file to tiptopgp;
grant delete on ltm_file to tiptopgp;
grant insert on ltm_file to tiptopgp;
grant index on ltm_file to public;
grant select on ltm_file to ods;
