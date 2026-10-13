/*
================================================================================
檔案代號:tat_file
檔案名稱:损益类科目与权益类科目关系对应基本资料文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tat_file
(
tat01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
tat02       number(5) DEFAULT '0' NOT NULL, /*年度*/
tat03       varchar2(24) DEFAULT ' ' NOT NULL, /*损益类科目*/
tat04       varchar2(24),            /*权益类BS科目                           */
tat05       varchar2(24)             /*权益类IS科目                           */
);

alter table tat_file add  constraint tat_pk primary key  (tat01,tat02,tat03) enable validate;
grant select on tat_file to tiptopgp;
grant update on tat_file to tiptopgp;
grant delete on tat_file to tiptopgp;
grant insert on tat_file to tiptopgp;
grant index on tat_file to public;
grant select on tat_file to ods;
