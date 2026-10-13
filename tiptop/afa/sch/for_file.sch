/*
================================================================================
檔案代號:for_file
檔案名稱:仪器校验记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table for_file
(
for01       varchar2(10) NOT NULL,   /*校验编号                               */
for02       number(5) NOT NULL,      /*项次                                   */
for03       varchar2(6) NOT NULL,    /*校订项目                               */
for04       varchar2(255)            /*检验结果                               */
);

alter table for_file add  constraint for_pk primary key  (for01,for02,for03) enable validate;
grant select on for_file to tiptopgp;
grant update on for_file to tiptopgp;
grant delete on for_file to tiptopgp;
grant insert on for_file to tiptopgp;
grant index on for_file to public;
grant select on for_file to ods;
