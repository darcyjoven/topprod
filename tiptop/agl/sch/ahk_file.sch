/*
================================================================================
檔案代號:ahk_file
檔案名稱:科目核算作業彈性設定檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahk_file
(
ahk00       varchar2(5) DEFAULT ' ' NOT NULL, /*賬別*/
ahk01       varchar2(24) DEFAULT ' ' NOT NULL, /*科目編號*/
ahk02       varchar2(20) DEFAULT ' ' NOT NULL, /*交易作業代號*/
ahk03       varchar2(80),            /*no use                                 */
ahk04       varchar2(60)             /*no use                                 */
);

alter table ahk_file add  constraint ahk_pk primary key  (ahk00,ahk01,ahk02) enable validate;
grant select on ahk_file to tiptopgp;
grant update on ahk_file to tiptopgp;
grant delete on ahk_file to tiptopgp;
grant insert on ahk_file to tiptopgp;
grant index on ahk_file to public;
grant select on ahk_file to ods;
