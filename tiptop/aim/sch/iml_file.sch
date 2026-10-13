/*
================================================================================
檔案代號:iml_file
檔案名稱:料件成本项目结构资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table iml_file
(
iml01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
iml02       varchar2(10) NOT NULL,   /*成本项目                               */
                                     /*成本項目                               */
iml031      number(20,6),            /*标准成本                               */
                                     /*標準成本                               */
iml032      number(20,6),            /*现时成本                               */
                                     /*現時成本                               */
iml033      number(20,6)             /*缺省成本                               */
                                     /*預設成本                               */
);

alter table iml_file add  constraint iml_pk primary key  (iml01,iml02) enable validate;
grant select on iml_file to tiptopgp;
grant update on iml_file to tiptopgp;
grant delete on iml_file to tiptopgp;
grant insert on iml_file to tiptopgp;
grant index on iml_file to public;
grant select on iml_file to ods;
