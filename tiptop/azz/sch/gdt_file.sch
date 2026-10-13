/*
================================================================================
檔案代號:gdt_file
檔案名稱:出货作业MD5存放文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdt_file
(
gdt01       varchar2(5) DEFAULT ' ' NOT NULL, /*模组*/
gdt02       varchar2(80) DEFAULT ' ' NOT NULL, /*程序ID*/
gdt03       varchar2(80),            /*MD5                                    */
gdt04       date,                    /*程式最后改版日期                       */
gdt05       varchar2(10),            /*纪录单位                               */
gdtdate     date,                    /*最近更改日                             */
gdtuser     varchar2(10)             /*记录人ID                               */
);

alter table gdt_file add  constraint gdt_pk primary key  (gdt01,gdt02) enable validate;
grant select on gdt_file to tiptopgp;
grant update on gdt_file to tiptopgp;
grant delete on gdt_file to tiptopgp;
grant insert on gdt_file to tiptopgp;
grant index on gdt_file to public;
grant select on gdt_file to ods;
