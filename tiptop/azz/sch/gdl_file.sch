/*
================================================================================
檔案代號:gdl_file
檔案名稱:用户自定义图表配置文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdl_file
(
gdl01       varchar2(10) DEFAULT ' ' NOT NULL, /*用户代码*/
gdl02       number(5) DEFAULT '0' NOT NULL, /*优先顺序*/
gdl03       varchar2(30),            /*图表代码                               */
gdldate     date,                    /*最近更改日                             */
gdlgrup     varchar2(10),            /*资料所有群                             */
gdlmodu     varchar2(10),            /*资料更改者                             */
gdlorig     varchar2(10),            /*资料建立部门                           */
gdloriu     varchar2(10),            /*资料建立者                             */
gdluser     varchar2(10)             /*资料所有者                             */
);

create        index gdl_01 on gdl_file (gdl01);
alter table gdl_file add  constraint gdl_pk primary key  (gdl01,gdl02) enable validate;
grant select on gdl_file to tiptopgp;
grant update on gdl_file to tiptopgp;
grant delete on gdl_file to tiptopgp;
grant insert on gdl_file to tiptopgp;
grant index on gdl_file to public;
grant select on gdl_file to ods;
