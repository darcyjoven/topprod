/*
================================================================================
檔案代號:sko_file
檔案名稱:报工群组工单资料档
檔案目的:报工群组工单资料单身档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sko_file
(
sko01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
sko02       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
sko03       number(15,3) DEFAULT '0' NOT NULL, /*预计生产数量*/
sko04       date,                    /*预计开工日期                           */
sko05       date,                    /*预计完工日期                           */
skoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sko_file add  constraint sko_pk primary key  (sko01,sko02,sko03) enable validate;
grant select on sko_file to tiptopgp;
grant update on sko_file to tiptopgp;
grant delete on sko_file to tiptopgp;
grant insert on sko_file to tiptopgp;
grant index on sko_file to public;
grant select on sko_file to ods;
