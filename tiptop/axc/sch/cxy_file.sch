/*
================================================================================
檔案代號:cxy_file
檔案名稱:仅暂存用
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxy_file
(
cxy01       varchar2(20) NOT NULL,   /*工单编号                               */
cxylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cxy_file add  constraint cxy_pk primary key  (cxy01) enable validate;
grant select on cxy_file to tiptopgp;
grant update on cxy_file to tiptopgp;
grant delete on cxy_file to tiptopgp;
grant insert on cxy_file to tiptopgp;
grant index on cxy_file to public;
grant select on cxy_file to ods;
