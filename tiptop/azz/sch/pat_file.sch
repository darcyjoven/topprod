/*
================================================================================
檔案代號:pat_file
檔案名稱:patch alter 記錄檔
檔案目的:紀錄 patch 未成功 alter 資料
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table pat_file
(
pat01       varchar2(20) DEFAULT ' ' NOT NULL, /*数据库代码*/
pat02       number(5) DEFAULT '0' NOT NULL, /*项次*/
pat03       varchar2(40) DEFAULT ' ' NOT NULL, /*patch单号*/
pat04       varchar2(4000) DEFAULT ' ' NOT NULL, /*修正指令及说明*/
pat05       varchar2(15),
pat06       varchar2(80)             /*更新说明                               */
);

alter table pat_file add  constraint pat_pk primary key  (pat01,pat02,pat03) enable validate;
grant select on pat_file to tiptopgp;
grant update on pat_file to tiptopgp;
grant delete on pat_file to tiptopgp;
grant insert on pat_file to tiptopgp;
grant index on pat_file to public;
grant select on pat_file to ods;
