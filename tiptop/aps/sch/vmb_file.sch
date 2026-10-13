/*
================================================================================
檔案代號:vmb_file
檔案名稱:APS日行事历维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmb_file
(
vmb01       varchar2(60) DEFAULT ' ' NOT NULL, /*日行事历编号*/
vmb02       date DEFAULT sysdate NOT NULL, /*日期*/
vmb03       varchar2(60)             /*工作模式                               */
);

alter table vmb_file add  constraint vmb_pk primary key  (vmb01,vmb02) enable validate;
grant select on vmb_file to tiptopgp;
grant update on vmb_file to tiptopgp;
grant delete on vmb_file to tiptopgp;
grant insert on vmb_file to tiptopgp;
grant index on vmb_file to public;
grant select on vmb_file to ods;
