/*
================================================================================
檔案代號:tqi_file
檔案名稱:客户层级关系单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqi_file
(
tqi01       varchar2(10) NOT NULL,   /*上级客户代码                           */
tqi02       date,                    /*生效日期                               */
tqi03       date,                    /*失效日期                               */
tqiacti     varchar2(1),             /*有效码                                 */
tqiuser     varchar2(10),            /*资料所有者                             */
tqigrup     varchar2(10),            /*资料所有部门                           */
tqimodu     varchar2(10),            /*资料更改者                             */
tqidate     date,                    /*最近更改日                             */
tqiorig     varchar2(10),            /*资料建立部门                           */
tqioriu     varchar2(10)             /*资料建立者                             */
);

alter table tqi_file add  constraint tqi_pk primary key  (tqi01) enable validate;
grant select on tqi_file to tiptopgp;
grant update on tqi_file to tiptopgp;
grant delete on tqi_file to tiptopgp;
grant insert on tqi_file to tiptopgp;
grant index on tqi_file to public;
grant select on tqi_file to ods;
