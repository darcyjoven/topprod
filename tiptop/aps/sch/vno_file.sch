/*
================================================================================
檔案代號:vno_file
檔案名稱:APS工模具保修明细维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vno_file
(
vno01       varchar2(60) NOT NULL,   /*工模具大类编号                         */
vno02       number(1)                /*产能类型                               */
);

alter table vno_file add  constraint vno_pk primary key  (vno01) enable validate;
grant select on vno_file to tiptopgp;
grant update on vno_file to tiptopgp;
grant delete on vno_file to tiptopgp;
grant insert on vno_file to tiptopgp;
grant index on vno_file to public;
grant select on vno_file to ods;
