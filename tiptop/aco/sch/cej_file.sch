/*
================================================================================
檔案代號:cej_file
檔案名稱:归并前后BOM单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cej_file
(
cej01       varchar2(10) DEFAULT ' ' NOT NULL, /*成品序号*/
cej02       varchar2(10) DEFAULT ' ' NOT NULL, /*BOM版本*/
cej03       varchar2(20) NOT NULL,   /*特性代码                               */
cej04       varchar2(40),            /*厂内料号                               */
cej05       varchar2(10),            /*归并后序号                             */
cej06       varchar2(40),            /*海关商品编号                           */
cej07       varchar2(1),             /*确认状态                               */
cej08       date,                    /*审核异动日期                           */
cejacti     varchar2(1),             /*资料有效码                             */
cejdate     date,                    /*最近更改日                             */
cejgrup     varchar2(10),            /*资料所有部门                           */
cejmodu     varchar2(10),            /*资料更改者                             */
cejuser     varchar2(10),            /*资料所有者                             */
cejoriu     varchar2(10),            /*资料建立者                             */
cejorig     varchar2(10)             /*资料建立部门                           */
);

create        index cej_01 on cej_file (cej01,cej02,cej04);
alter table cej_file add  constraint cej_pk primary key  (cej01,cej02,cej03) enable validate;
grant select on cej_file to tiptopgp;
grant update on cej_file to tiptopgp;
grant delete on cej_file to tiptopgp;
grant insert on cej_file to tiptopgp;
grant index on cej_file to public;
grant select on cej_file to ods;
