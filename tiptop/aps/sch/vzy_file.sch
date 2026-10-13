/*
================================================================================
檔案代號:vzy_file
檔案名稱:aps 多廠區設定檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vzy_file
(
vzy00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vzy01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vzy02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vzy03       varchar2(80),            /*APS版本描述                            */
vzy04       varchar2(20),            /*APS数据库编号                          */
vzy05       varchar2(20),            /*APS数据库名称/SID                      */
vzy06       varchar2(20),            /*TIPTOP数据库编号                       */
vzy07       varchar2(20),            /*TIOTOP数据库名称/SID                   */
vzy08       varchar2(20),            /*APS服务器编号                          */
vzy09       number(5),               /*APS SERVER PORT                        */
vzy10       varchar2(1),             /*数据库状态                             */
vzy11       varchar2(10),            /*规划中储存版本                         */
vzy12       date,                    /*版本确认时间                           */
vzy13       varchar2(20),            /*APS 硬件模块                           */
vzy17       varchar2(60),            /*APS保留字段文字                        */
vzy18       varchar2(60),            /*APS保留字段文字                        */
vzy19       varchar2(60),            /*APS保留字段文字                        */
vzy20       number(9),               /*APS保留字段数值                        */
vzy21       number(18,8),            /*APS保留字段浮点数                      */
vzy22       number(18,8),            /*APS保留字段浮点数                      */
vzy23       date,                    /*APS保留字段日期                        */
vzy24       date                     /*APS保留字段日期                        */
);

alter table vzy_file add  constraint vzy_pk primary key  (vzy00,vzy01,vzy02) enable validate;
grant select on vzy_file to tiptopgp;
grant update on vzy_file to tiptopgp;
grant delete on vzy_file to tiptopgp;
grant insert on vzy_file to tiptopgp;
grant index on vzy_file to public;
grant select on vzy_file to ods;
