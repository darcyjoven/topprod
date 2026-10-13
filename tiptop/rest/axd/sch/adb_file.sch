/*
================================================================================
檔案代號:adb_file
檔案名稱:集團組織單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adb_file
(
adb01       varchar2(10),            /*上層公司編號                           */
adb02       varchar2(10),            /*下層公司編號                           */
adb03       date,                    /*生效日期                               */
adb04       date,                    /*失效日期                               */
adb05       varchar2(1),             /*轉撥計價方式                           */
adb06       number(6,4)              /*轉撥百分比                             */
);

create unique index adb_01 on adb_file (adb01,adb02);
create        index adb_02 on adb_file (adb02);
grant select on adb_file to public;
grant index on adb_file to public;
grant update on adb_file to public;
grant delete on adb_file to public;
grant insert on adb_file to public;
