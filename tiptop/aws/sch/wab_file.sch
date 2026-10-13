/*
================================================================================
檔案代號:wab_file
檔案名稱:通用接口之对象资料表定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wab_file
(
wab01       varchar2(80) DEFAULT ' ' NOT NULL, /*企业对象ID*/
wab02       varchar2(20) DEFAULT ' ' NOT NULL, /*企业对象使用的表名*/
wab03       varchar2(80),            /*档案说明                               */
wab04       varchar2(20),            /*上游档案                               */
wab05       varchar2(20),            /*下游档案                               */
wab06       varchar2(1) DEFAULT ' ' NOT NULL, /*与下游表的连接是否紧密*/
wab07       varchar2(100),           /*与下游表连接的字段关系                 */
wab08       varchar2(10),            /*类型                                   */
wab09       number(5) DEFAULT '0' NOT NULL /*No.*/
);

alter table wab_file add  constraint wab_pk primary key  (wab01,wab09) enable validate;
grant select on wab_file to tiptopgp;
grant update on wab_file to tiptopgp;
grant delete on wab_file to tiptopgp;
grant insert on wab_file to tiptopgp;
grant index on wab_file to public;
grant select on wab_file to ods;
