/*
================================================================================
檔案代號:giy_file
檔案名稱:现金流量表揭露事项说明文件(总账)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giy_file
(
giy01       number(5) DEFAULT '0' NOT NULL, /*顺序*/
giy02       varchar2(80),            /*说明                                   */
giy03       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
giy04       number(5) DEFAULT '0' NOT NULL, /*年度*/
giy05       number(5) DEFAULT '0' NOT NULL /*期别*/
);

alter table giy_file add  constraint giy_pk primary key  (giy01,giy04,giy05) enable validate;
grant select on giy_file to tiptopgp;
grant update on giy_file to tiptopgp;
grant delete on giy_file to tiptopgp;
grant insert on giy_file to tiptopgp;
grant index on giy_file to public;
grant select on giy_file to ods;
