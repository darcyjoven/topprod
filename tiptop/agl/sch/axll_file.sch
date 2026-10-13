/*
================================================================================
檔案代號:axll_file
檔案名稱:股东权益群组对应会计科目表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axll_file
(
axll01      varchar2(10) NOT NULL,
axll02      varchar2(24) NOT NULL,   /*会计科目                               */
axll03      varchar2(1),
axll04      varchar2(255)
);

alter table axll_file add  constraint axll_pk primary key  (axll01,axll02) enable validate;
grant select on axll_file to tiptopgp;
grant update on axll_file to tiptopgp;
grant delete on axll_file to tiptopgp;
grant insert on axll_file to tiptopgp;
grant index on axll_file to public;
grant select on axll_file to ods;
