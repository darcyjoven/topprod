/*
================================================================================
檔案代號:pjm_file
檔案名稱:wbs累计设备需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjm_file
(
pjm01       varchar2(30) NOT NULL,   /*WBS编码                                */
pjm02       varchar2(10) NOT NULL,   /*设备类型                               */
pjm03       number(10),              /*台数                                   */
pjm04       number(15,3)             /*需求量                                 */
);

alter table pjm_file add  constraint pjm_pk primary key  (pjm01,pjm02) enable validate;
grant select on pjm_file to tiptopgp;
grant update on pjm_file to tiptopgp;
grant delete on pjm_file to tiptopgp;
grant insert on pjm_file to tiptopgp;
grant index on pjm_file to public;
grant select on pjm_file to ods;
