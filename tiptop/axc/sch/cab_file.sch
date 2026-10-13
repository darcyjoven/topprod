/*
================================================================================
檔案代號:cab_file
檔案名稱:成本项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cab_file
(
cab01       varchar2(10) NOT NULL,   /*成本项目                               */
                                     /*成本項目                               */
cab02       varchar2(80)             /*成本项目名称                           */
                                     /*成本項目名稱  no.7300  alter           */
);

alter table cab_file add  constraint cab_pk primary key  (cab01) enable validate;
grant select on cab_file to tiptopgp;
grant update on cab_file to tiptopgp;
grant delete on cab_file to tiptopgp;
grant insert on cab_file to tiptopgp;
grant index on cab_file to public;
grant select on cab_file to ods;
