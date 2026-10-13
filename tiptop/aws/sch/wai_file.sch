/*
================================================================================
檔案代號:wai_file
檔案名稱:通用接口之目标系统栏位定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wai_file
(
wai01       varchar2(10) DEFAULT ' ' NOT NULL, /*系统标示*/
wai02       varchar2(80) DEFAULT ' ' NOT NULL, /*TIPTOP企业对象ID*/
wai03       varchar2(80) DEFAULT ' ' NOT NULL, /*目标系统企业对象ID*/
wai04       varchar2(10) DEFAULT ' ' NOT NULL, /*TIPTOP字段名*/
wai05       varchar2(200) DEFAULT ' ' NOT NULL, /*目标系统属性ID*/
wai06       varchar2(200) DEFAULT ' ' NOT NULL, /*属性名称*/
wai07       varchar2(10) DEFAULT ' ' NOT NULL, /*属性数据类型*/
wai08       varchar2(10) DEFAULT ' ' NOT NULL, /*属性数据长度*/
wai09       varchar2(1) DEFAULT ' ' NOT NULL, /*属性是否必输*/
wai10       varchar2(1) DEFAULT ' ' NOT NULL, /*属性是否可更改*/
wai11       varchar2(200),           /*属性描述信息                           */
wai12       varchar2(200),           /*属性起始值                             */
wai13       varchar2(200),           /*属性截止日期                           */
wai14       varchar2(20)             /*属性缺省值                             */
);

alter table wai_file add  constraint wai_pk primary key  (wai01,wai03,wai05) enable validate;
grant select on wai_file to tiptopgp;
grant update on wai_file to tiptopgp;
grant delete on wai_file to tiptopgp;
grant insert on wai_file to tiptopgp;
grant index on wai_file to public;
grant select on wai_file to ods;
