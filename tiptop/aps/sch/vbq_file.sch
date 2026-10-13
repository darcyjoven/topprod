/*
================================================================================
檔案代號:vbq_file
檔案名稱:分量损耗率资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbq_file
(
vbq01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料号*/
vbq02       varchar2(20) DEFAULT ' ' NOT NULL, /*类型 1-料号 2-分群码*/
vbq03       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料号/分群码*/
vbq04       number(15,3) DEFAULT '0' NOT NULL, /*生产起始数量*/
vbq05       number(15,3) DEFAULT '0' NOT NULL, /*生产截止数量*/
vbq06       number(9,4),             /*固定损耗系数                           */
vbq07       number(9,4),             /*变动损耗系数                           */
vbq08       varchar2(60),            /*APS保留字段文字                        */
vbq09       varchar2(60),            /*APS保留字段文字                        */
vbq10       varchar2(60),            /*APS保留字段文字                        */
vbq11       number(9),               /*APS保留字段数值                        */
vbq12       number(18,8),            /*APS保留字段浮点数                      */
vbq13       number(18,8),            /*APS保留字段浮点数                      */
vbq14       date,                    /*APS保留字段日期                        */
vbq15       date,                    /*APS保留字段日期                        */
vbqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table vbq_file add  constraint vbq_pk primary key  (vbqlegal,vbqplant,vbq01,vbq02,vbq03,vbq04,vbq05) enable validate;
grant select on vbq_file to tiptopgp;
grant update on vbq_file to tiptopgp;
grant delete on vbq_file to tiptopgp;
grant insert on vbq_file to tiptopgp;
grant index on vbq_file to public;
grant select on vbq_file to ods;
