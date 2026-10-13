/*
================================================================================
檔案代號:vin_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vin_file
(
vin01       varchar2(10) NOT NULL,   /*VIP种类编号                            */
vin02       number(5) NOT NULL,      /*项次                                   */
vin03       varchar2(10),            /*积分规则编码                           */
vinacti     varchar2(1)              /*资料有效码                             */
);

alter table vin_file add  constraint vin_pk primary key  (vin01,vin02) enable validate;
grant select on vin_file to tiptopgp;
grant update on vin_file to tiptopgp;
grant delete on vin_file to tiptopgp;
grant insert on vin_file to tiptopgp;
grant index on vin_file to public;
grant select on vin_file to ods;
