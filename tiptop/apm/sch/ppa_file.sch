/*
================================================================================
檔案代號:ppa_file
檔案名稱:供应商评核项目明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ppa_file
(
ppa01       number(5) NOT NULL,      /*项次                                   */
ppa02       varchar2(10) NOT NULL,   /*评核项目代码                           */
ppa03       varchar2(80)             /*评核项目说明                           */
);

alter table ppa_file add  constraint ppa_pk primary key  (ppa01,ppa02) enable validate;
grant select on ppa_file to tiptopgp;
grant update on ppa_file to tiptopgp;
grant delete on ppa_file to tiptopgp;
grant insert on ppa_file to tiptopgp;
grant index on ppa_file to public;
grant select on ppa_file to ods;
