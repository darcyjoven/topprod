/*
================================================================================
檔案代號:pjc_file
檔案名稱:项目资料备注说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjc_file
(
pjc01       varchar2(30) NOT NULL,   /*wbs编码                                */
pjc02       number(5) NOT NULL,      /*行序                                   */
pjc03       varchar2(255)            /*备注说明                               */
);

alter table pjc_file add  constraint pjc_pk primary key  (pjc01,pjc02) enable validate;
grant select on pjc_file to tiptopgp;
grant update on pjc_file to tiptopgp;
grant delete on pjc_file to tiptopgp;
grant insert on pjc_file to tiptopgp;
grant index on pjc_file to public;
grant select on pjc_file to ods;
