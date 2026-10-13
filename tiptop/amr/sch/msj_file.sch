/*
================================================================================
檔案代號:msj_file
檔案名稱:MRP 订单模拟资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msj_file
(
msj01       varchar2(10) DEFAULT ' ' NOT NULL, /*订单模拟编号*/
msj02       varchar2(20) DEFAULT ' ' NOT NULL, /*订单编号*/
msjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
msjplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table msj_file add  constraint msj_pk primary key  (msj01,msj02) enable validate;
grant select on msj_file to tiptopgp;
grant update on msj_file to tiptopgp;
grant delete on msj_file to tiptopgp;
grant insert on msj_file to tiptopgp;
grant index on msj_file to public;
grant select on msj_file to ods;
