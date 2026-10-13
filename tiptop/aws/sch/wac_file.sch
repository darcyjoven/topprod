/*
================================================================================
檔案代號:wac_file
檔案名稱:通用接口之对象属性定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wac_file
(
wac01       varchar2(80) DEFAULT ' ' NOT NULL, /*企业对象ID*/
wac02       varchar2(20) DEFAULT ' ' NOT NULL, /*企业对象使用的表名*/
wac03       varchar2(10) DEFAULT ' ' NOT NULL, /*字段代码*/
wac04       varchar2(80) DEFAULT ' ' NOT NULL, /*属性标示*/
wac05       varchar2(80),            /*属性名称                               */
wac06       varchar2(10) DEFAULT ' ' NOT NULL, /*字段类型*/
wac07       varchar2(10) DEFAULT ' ' NOT NULL, /*字段长度*/
wac08       varchar2(1) DEFAULT ' ' NOT NULL, /*是否为key值字段*/
wac09       varchar2(1) DEFAULT ' ' NOT NULL, /*是否为必要字段*/
wac10       varchar2(1) DEFAULT ' ' NOT NULL, /*字段是否可更改*/
wac11       varchar2(200),           /*字段描述信息                           */
wac12       varchar2(20),            /*起始值                                 */
wac13       varchar2(20),            /*截止值                                 */
wac14       varchar2(20),            /*取值列表                               */
wac15       varchar2(20)             /*缺省值                                 */
);

alter table wac_file add  constraint wac_pk primary key  (wac01,wac02,wac03) enable validate;
grant select on wac_file to tiptopgp;
grant update on wac_file to tiptopgp;
grant delete on wac_file to tiptopgp;
grant insert on wac_file to tiptopgp;
grant index on wac_file to public;
grant select on wac_file to ods;
