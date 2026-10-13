/*
================================================================================
檔案代號:voq_file
檔案名稱:APS單據追溯檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voq_file
(
voq00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voq01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
voq02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voq03       varchar2(60) DEFAULT ' ' NOT NULL, /*供给单据*/
voq04       varchar2(1) DEFAULT ' ' NOT NULL, /*供给类型*/
voq05       varchar2(60) DEFAULT ' ' NOT NULL, /*需求单据*/
voq06       date,                    /*供给日期                               */
voq07       date,                    /*需求日期                               */
voq08       number(15,3),            /*供给数量                               */
voq09       varchar2(40) DEFAULT ' ' NOT NULL, /*供给料号*/
voq10       number(1) DEFAULT '0' NOT NULL, /*是否新开单据*/
voq11       varchar2(60),            /*APS保留字段文字                        */
voq12       varchar2(60),            /*APS保留字段文字                        */
voq13       varchar2(60),            /*APS保留字段文字                        */
voq14       number(9),               /*APS保留字段数值                        */
voq15       number(18,8),            /*APS保留字段浮点数                      */
voq16       number(18,8),            /*APS保留字段浮点数                      */
voq17       date,                    /*APS保留字段日期                        */
voq18       date,                    /*APS保留字段日期                        */
voqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
voqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table voq_file add  constraint voq_pk primary key  (voq00,voq01,voq02,voq03,voq04,voq05,voq09) enable validate;
grant select on voq_file to tiptopgp;
grant update on voq_file to tiptopgp;
grant delete on voq_file to tiptopgp;
grant insert on voq_file to tiptopgp;
grant index on voq_file to public;
grant select on voq_file to ods;
