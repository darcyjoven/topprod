/*
================================================================================
檔案代號:lqs_file
檔案名稱:券回收记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqs_file
(
lqs00       varchar2(10),            /*no use 原门店编号                      */
lqs01       varchar2(20) DEFAULT ' ' NOT NULL, /*券回收单号*/
lqs02       varchar2(20) DEFAULT ' ' NOT NULL, /*券编号*/
lqslegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqsplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lqs_file add  constraint lqs_pk primary key  (lqs01,lqs02) enable validate;
grant select on lqs_file to tiptopgp;
grant update on lqs_file to tiptopgp;
grant delete on lqs_file to tiptopgp;
grant insert on lqs_file to tiptopgp;
grant index on lqs_file to public;
grant select on lqs_file to ods;
