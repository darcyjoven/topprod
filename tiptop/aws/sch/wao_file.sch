/*
================================================================================
檔案代號:wao_file
檔案名稱:TIPTOP 与 EasyFlow整合服务清单
檔案目的:提供建立 TIPTOP 与 EasyFlow 整合的服务清单
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wao_file
(
wao01       varchar2(1) DEFAULT ' ' NOT NULL, /*服务端*/
wao02       varchar2(40) DEFAULT ' ' NOT NULL, /*服务代码*/
wao03       varchar2(80),            /*服务说明                               */
waodate     date,                    /*最近更改日                             */
waogrup     varchar2(10),            /*资料所有群                             */
waomodu     varchar2(10),            /*资料更改者                             */
waoorig     varchar2(10),            /*资料建立部门                           */
waooriu     varchar2(10),            /*资料建立者                             */
waouser     varchar2(10)             /*资料所有者                             */
);

alter table wao_file add  constraint wao_pk primary key  (wao01,wao02) enable validate;
grant select on wao_file to tiptopgp;
grant update on wao_file to tiptopgp;
grant delete on wao_file to tiptopgp;
grant insert on wao_file to tiptopgp;
grant index on wao_file to public;
grant select on wao_file to ods;
