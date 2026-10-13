/*
================================================================================
檔案代號:obo_file
檔案名稱:运输途径单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obo_file
(
obo01       varchar2(20) NOT NULL,   /*运输途径编号                           */
obo02       number(5) NOT NULL,      /*运输步骤                               */
obo03       varchar2(1),             /*运输性质                               */
obo04       varchar2(1),             /*运输方式                               */
obo05       varchar2(10),            /*始起运输地点                           */
obo06       varchar2(10),            /*目的运输地点                           */
obo07       number(15,3)             /*耗用天数                               */
);

alter table obo_file add  constraint obo_pk primary key  (obo01,obo02) enable validate;
grant select on obo_file to tiptopgp;
grant update on obo_file to tiptopgp;
grant delete on obo_file to tiptopgp;
grant insert on obo_file to tiptopgp;
grant index on obo_file to public;
grant select on obo_file to ods;
