/*
================================================================================
檔案代號:tuo_file
檔案名稱:寄销客户对应仓库档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tuo_file
(
tuo01       varchar2(10) NOT NULL,   /*客户编号                               */
tuo02       varchar2(10) NOT NULL,   /*送货客户                               */
tuo03       varchar2(10),            /*缺省出货仓库                           */
tuo031      varchar2(10),            /*缺省出货库位                           */
tuo04       varchar2(10),            /*缺省寄销仓库                           */
tuo05       varchar2(10)             /*缺省寄销库位                           */
);

alter table tuo_file add  constraint tuo_pk primary key  (tuo01,tuo02) enable validate;
grant select on tuo_file to tiptopgp;
grant update on tuo_file to tiptopgp;
grant delete on tuo_file to tiptopgp;
grant insert on tuo_file to tiptopgp;
grant index on tuo_file to public;
grant select on tuo_file to ods;
