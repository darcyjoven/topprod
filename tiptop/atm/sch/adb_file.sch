/*
================================================================================
檔案代號:adb_file
檔案名稱:集团组织单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adb_file
(
adb01       varchar2(10) NOT NULL,   /*上层公司编号                           */
adb02       varchar2(10) NOT NULL,   /*下层公司编号                           */
adb03       date,                    /*生效日期                               */
adb04       date,                    /*失效日期                               */
adb05       varchar2(1),             /*调拨计价方式                           */
adb06       number(9,4)              /*调拨百分比                             */
);

create        index adb_02 on adb_file (adb02);
alter table adb_file add  constraint adb_pk primary key  (adb01,adb02) enable validate;
grant select on adb_file to tiptopgp;
grant update on adb_file to tiptopgp;
grant delete on adb_file to tiptopgp;
grant insert on adb_file to tiptopgp;
grant index on adb_file to public;
grant select on adb_file to ods;
