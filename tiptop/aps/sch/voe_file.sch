/*
================================================================================
檔案代號:voe_file
檔案名稱:aps(製令每日產出)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voe_file
(
voe00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voe01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
voe02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voe03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
voe04       number(5) DEFAULT '0' NOT NULL, /*工单元件需求编号*/
voe05       number(9) DEFAULT '0' NOT NULL, /*工单需求编号*/
voe06       varchar2(40),            /*元件编号                               */
voe07       date,                    /*工单预计完工日                         */
voe08       date,                    /*开立日                                 */
voe09       varchar2(40),            /*主件品号                               */
voe10       varchar2(60),            /*规划批号                               */
voe11       date,                    /*预计领用日                             */
voe12       number(15,3),            /*预计领用量                             */
voe13       number(1),               /*自动完全领料                           */
voe14       varchar2(20),            /*erp中使用的工单单号                    */
voe15       varchar2(40),            /*被替代元件料号                         */
voe16       number(15,3),            /*预计损耗量                             */
voe17       number(1),               /*取替代属性                             */
voe18       varchar2(60),            /*APS保留字段文字                        */
voe19       varchar2(60),            /*APS保留字段文字                        */
voe20       varchar2(60),            /*APS保留字段文字                        */
voe21       number(9),               /*APS保留字段数值                        */
voe22       number(18,8),            /*APS保留字段浮点数                      */
voe23       number(18,8),            /*APS保留字段浮点数                      */
voe24       date,                    /*APS保留字段日期                        */
voe25       date,                    /*APS保留字段日期                        */
voelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
voeplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
voe012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
voe013      varchar2(60) DEFAULT '0' NOT NULL /*工艺序*/
);

alter table voe_file add  constraint voe_pk primary key  (voe00,voe01,voe02,voe03,voe04,voe05,voe012,voe013) enable validate;
grant select on voe_file to tiptopgp;
grant update on voe_file to tiptopgp;
grant delete on voe_file to tiptopgp;
grant insert on voe_file to tiptopgp;
grant index on voe_file to public;
grant select on voe_file to ods;
