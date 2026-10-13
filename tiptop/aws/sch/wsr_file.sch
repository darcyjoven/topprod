/*
================================================================================
檔案代號:wsr_file
檔案名稱:整合服务 ERP 与他系统间栏位对应关系单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsr_file
(
wsr01       varchar2(40) DEFAULT ' ' NOT NULL, /*服务代码*/
wsr02       varchar2(1) DEFAULT ' ' NOT NULL, /*存取模式*/
wsr03       varchar2(80) DEFAULT ' ' NOT NULL, /*服务说明*/
wsr04       varchar2(40) DEFAULT ' ' NOT NULL, /*对应 erp 函式名称*/
wsracti     varchar2(1),             /*资料有效码                             */
wsrdate     date,                    /*最后异动日期                           */
wsrgrup     varchar2(10),            /*资料所有群                             */
wsrmodu     varchar2(10),            /*资料更改者                             */
wsruser     varchar2(10),            /*资料所有者                             */
wsroriu     varchar2(10),            /*资料建立者                             */
wsrorig     varchar2(10)             /*资料建立部门                           */
);

alter table wsr_file add  constraint wsr_pk primary key  (wsr01,wsr02) enable validate;
grant select on wsr_file to tiptopgp;
grant update on wsr_file to tiptopgp;
grant delete on wsr_file to tiptopgp;
grant insert on wsr_file to tiptopgp;
grant index on wsr_file to public;
grant select on wsr_file to ods;
