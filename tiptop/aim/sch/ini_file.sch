/*
================================================================================
檔案代號:ini_file
檔案名稱:特性基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ini_file
(
ini01       varchar2(10) DEFAULT ' ' NOT NULL, /*特性代码*/
ini02       varchar2(40),            /*特性名称                               */
ini03       varchar2(1),             /*字段属性                               */
inidate     date,                    /*最近更改日                             */
inigrup     varchar2(10),            /*资料所有群                             */
inimodu     varchar2(10),            /*资料更改者                             */
iniorig     varchar2(10),            /*资料建立部门                           */
inioriu     varchar2(10),            /*资料建立者                             */
iniuser     varchar2(10)             /*资料所有者                             */
);

alter table ini_file add  constraint ini_pk primary key  (ini01) enable validate;
grant select on ini_file to tiptopgp;
grant update on ini_file to tiptopgp;
grant delete on ini_file to tiptopgp;
grant insert on ini_file to tiptopgp;
grant index on ini_file to public;
grant select on ini_file to ods;
