/*
================================================================================
檔案代號:ryy_file
檔案名稱:POS传输单异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryy_file
(
ryy01       varchar2(20) DEFAULT ' ' NOT NULL, /*傳輸單號*/
ryy02       date,                    /*开始日期                               */
ryy03       varchar2(8),             /*开始时间                               */
ryy04       date,                    /*结束日期                               */
ryy05       varchar2(8)              /*结束时间                               */
);

alter table ryy_file add  constraint ryy_pk primary key  (ryy01) enable validate;
grant select on ryy_file to tiptopgp;
grant update on ryy_file to tiptopgp;
grant delete on ryy_file to tiptopgp;
grant insert on ryy_file to tiptopgp;
grant index on ryy_file to public;
grant select on ryy_file to ods;
