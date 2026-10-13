/*
================================================================================
檔案代號:pjh_file
檔案名稱:WBS累计人力需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjh_file
(
pjh01       varchar2(30) NOT NULL,   /*wbs编码                                */
pjh02       varchar2(10) NOT NULL,   /*技能编号                               */
pjh03       number(15,3)             /*需求量                                 */
);

alter table pjh_file add  constraint pjh_pk primary key  (pjh01,pjh02) enable validate;
grant select on pjh_file to tiptopgp;
grant update on pjh_file to tiptopgp;
grant delete on pjh_file to tiptopgp;
grant insert on pjh_file to tiptopgp;
grant index on pjh_file to public;
grant select on pjh_file to ods;
