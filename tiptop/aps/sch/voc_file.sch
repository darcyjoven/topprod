/*
================================================================================
檔案代號:voc_file
檔案名稱:采购变更
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voc_file
(
voc00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voc01       varchar2(10) DEFAULT ' ' NOT NULL, /*限定版本*/
voc02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voc03       varchar2(60) DEFAULT ' ' NOT NULL, /*采购令编号*/
voc04       number(1),               /*是否数量变更                           */
voc05       number(1),               /*是否日期变更                           */
voc06       varchar2(60),            /*APS保留字段文字                        */
voc07       varchar2(60),            /*APS保留字段文字                        */
voc08       varchar2(60),            /*APS保留字段文字                        */
voc09       number(9),               /*APS保留字段数值                        */
voc10       number(18,8),            /*APS保留字段浮点数                      */
voc11       number(18,8),            /*APS保留字段浮点数                      */
voc12       date,                    /*APS保留字段日期                        */
voc13       date,                    /*APS保留字段日期                        */
voclegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vocplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table voc_file add  constraint voc_pk primary key  (voc00,voc01,voc02,voc03) enable validate;
grant select on voc_file to tiptopgp;
grant update on voc_file to tiptopgp;
grant delete on voc_file to tiptopgp;
grant insert on voc_file to tiptopgp;
grant index on voc_file to public;
grant select on voc_file to ods;
