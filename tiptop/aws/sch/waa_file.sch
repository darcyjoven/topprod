/*
================================================================================
檔案代號:waa_file
檔案名稱:通用接口之企业对象定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table waa_file
(
waa01       varchar2(80) DEFAULT ' ' NOT NULL, /*企业对象ID*/
waa02       varchar2(80),            /*对象名称                               */
waa03       varchar2(80),            /*企业对象描述                           */
waa04       varchar2(1) DEFAULT ' ' NOT NULL, /*企业对象是否可新增*/
waa05       varchar2(1) DEFAULT ' ' NOT NULL, /*企业对象是否可删除*/
waa06       varchar2(1) DEFAULT ' ' NOT NULL, /*企业对象是否可修改*/
waa07       varchar2(1) DEFAULT ' ' NOT NULL /*是否为多子表对象*/
);

alter table waa_file add  constraint waa_pk primary key  (waa01) enable validate;
grant select on waa_file to tiptopgp;
grant update on waa_file to tiptopgp;
grant delete on waa_file to tiptopgp;
grant insert on waa_file to tiptopgp;
grant index on waa_file to public;
grant select on waa_file to ods;
