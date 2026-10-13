/*
================================================================================
檔案代號:wah_file
檔案名稱:通用接口之目标系统对象定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wah_file
(
wah01       varchar2(10) DEFAULT ' ' NOT NULL, /*系统标示*/
wah02       varchar2(80) DEFAULT ' ' NOT NULL, /*对象ID*/
wah03       varchar2(80),            /*对象名称                               */
wah04       varchar2(80),            /*企业对象描述                           */
wah05       varchar2(1) DEFAULT ' ' NOT NULL, /*企业对象是否可新增*/
wah06       varchar2(1) DEFAULT ' ' NOT NULL, /*企业对象是否可删除*/
wah07       varchar2(1) DEFAULT ' ' NOT NULL, /*企业对象是否可修改*/
wah08       varchar2(80),            /*关联的TIPTOP企业对象                   */
wah09       varchar2(1) DEFAULT ' ' NOT NULL /*是否存在多子表*/
);

alter table wah_file add  constraint wah_pk primary key  (wah01,wah02) enable validate;
grant select on wah_file to tiptopgp;
grant update on wah_file to tiptopgp;
grant delete on wah_file to tiptopgp;
grant insert on wah_file to tiptopgp;
grant index on wah_file to public;
grant select on wah_file to ods;
