/*
================================================================================
檔案代號:wan_file
檔案名稱:整合多语言记录数据更新文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table wan_file
(
wan01       varchar2(20) DEFAULT ' ' NOT NULL, /*档案代码*/
wan02       varchar2(20) DEFAULT ' ' NOT NULL, /*字段代码*/
wan03       varchar2(80) DEFAULT ' ' NOT NULL, /*KEY 值序列*/
wan04       varchar2(80) DEFAULT ' ' NOT NULL, /*KEY 值序列2*/
wan05       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
wan06       varchar2(100)            /*各语言别下的名称                       */
);

alter table wan_file add  constraint wan_pk primary key  (wan01,wan02,wan03,wan04,wan05) enable validate;
grant select on wan_file to tiptopgp;
grant update on wan_file to tiptopgp;
grant delete on wan_file to tiptopgp;
grant insert on wan_file to tiptopgp;
grant index on wan_file to public;
grant select on wan_file to ods;
