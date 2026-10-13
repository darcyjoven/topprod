/*
================================================================================
檔案代號:cac_file
檔案名稱:成本项目分摊系数资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cac_file
(
cac01       varchar2(10) NOT NULL,   /*成本中心                               */
cac02       varchar2(10) NOT NULL,   /*成本项目                               */
                                     /*成本項目                               */
cac03       number(15,3)             /*分摊系数                               */
                                     /*分攤係數                               */
);

alter table cac_file add  constraint cac_pk primary key  (cac01,cac02) enable validate;
grant select on cac_file to tiptopgp;
grant update on cac_file to tiptopgp;
grant delete on cac_file to tiptopgp;
grant insert on cac_file to tiptopgp;
grant index on cac_file to public;
grant select on cac_file to ods;
