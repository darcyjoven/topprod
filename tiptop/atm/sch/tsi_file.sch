/*
================================================================================
檔案代號:tsi_file
檔案名稱:订单/采购单抛转单别设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsi_file
(
tsi01       varchar2(5) NOT NULL,    /*订单单别                               */
tsi02       varchar2(5) NOT NULL,    /*采购单别                               */
tsiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsi_file add  constraint tsi_pk primary key  (tsi01) enable validate;
grant select on tsi_file to tiptopgp;
grant update on tsi_file to tiptopgp;
grant delete on tsi_file to tiptopgp;
grant insert on tsi_file to tiptopgp;
grant index on tsi_file to public;
grant select on tsi_file to ods;
