/*
================================================================================
檔案代號:fib_file
檔案名稱:设备附件资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fib_file
(
fib01       varchar2(20) NOT NULL,   /*设备编号                               */
fib02       number(5) NOT NULL,      /*项次                                   */
fib03       varchar2(70)             /*文件路径档名                           */
);

alter table fib_file add  constraint fib_pk primary key  (fib01,fib02) enable validate;
grant select on fib_file to tiptopgp;
grant update on fib_file to tiptopgp;
grant delete on fib_file to tiptopgp;
grant insert on fib_file to tiptopgp;
grant index on fib_file to public;
grant select on fib_file to ods;
