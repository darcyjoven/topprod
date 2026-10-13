/*
================================================================================
檔案代號:wss_file
檔案名稱:ERP 栏位预设值及对应关系单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wss_file
(
wss01       varchar2(40) DEFAULT ' ' NOT NULL, /*服务代码*/
wss02       varchar2(1) DEFAULT ' ' NOT NULL, /*存取模式*/
wss03       varchar2(20) DEFAULT ' ' NOT NULL, /*他系统代码*/
wss04       varchar2(20) DEFAULT ' ' NOT NULL, /*erp 字段名称*/
wss05       varchar2(30),            /*字段缺省值                             */
wss06       varchar2(30)             /*他系统字段名称                         */
);

create        index wss_02 on wss_file (wss01,wss02,wss03,wss06);
alter table wss_file add  constraint wss_pk primary key  (wss01,wss02,wss03,wss04) enable validate;
grant select on wss_file to tiptopgp;
grant update on wss_file to tiptopgp;
grant delete on wss_file to tiptopgp;
grant insert on wss_file to tiptopgp;
grant index on wss_file to public;
grant select on wss_file to ods;
