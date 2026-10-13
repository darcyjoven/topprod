/*
================================================================================
檔案代號:voi_file
檔案名稱:aps(存貨結果)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voi_file
(
voi00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voi01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
voi02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voi03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
voi04       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
voi05       varchar2(60) DEFAULT ' ' NOT NULL, /*工艺序号*/
voi06       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
voi07       number(1),               /*是否数量变更                           */
voi08       number(1),               /*是否日期变更                           */
voi09       number(1),               /*是否设备变更                           */
voi10       varchar2(1),             /*变更码                                 */
voi11       varchar2(60),            /*APS保留字段文字                        */
voi12       varchar2(60),            /*APS保留字段文字                        */
voi13       varchar2(60),            /*APS保留字段文字                        */
voi14       number(9),               /*APS保留字段数值                        */
voi15       number(18,8),            /*APS保留字段浮点数                      */
voi16       number(18,8),            /*APS保留字段浮点数                      */
voi17       date,                    /*APS保留字段日期                        */
voi18       date,                    /*APS保留字段日期                        */
voilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
voiplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
voi012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table voi_file add  constraint voi_pk primary key  (voi00,voi01,voi02,voi03,voi04,voi05,voi06,voi012) enable validate;
grant select on voi_file to tiptopgp;
grant update on voi_file to tiptopgp;
grant delete on voi_file to tiptopgp;
grant insert on voi_file to tiptopgp;
grant index on voi_file to public;
grant select on voi_file to ods;
