/*
================================================================================
檔案代號:vol_file
檔案名稱:aps加班資訊檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vol_file
(
vol00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vol01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vol02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vol03       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vol04       date DEFAULT sysdate NOT NULL, /*日期*/
vol05       number(9) DEFAULT '0' NOT NULL, /*开始时间(整数)*/
vol06       number(9),               /*结束时间(整数)                         */
vol07       number(1),               /*排程                                   */
vol08       number(1) DEFAULT '0' NOT NULL, /*是否为外包*/
vol09       number(1) DEFAULT '0' NOT NULL, /*资源类型*/
vol10       number(1) DEFAULT '0' NOT NULL, /*加班型态*/
vol11       number(1),               /*更新否                                 */
vol12       number(1),               /*核算项 0:不变，1:新增，2:删除          */
vol13       varchar2(60),            /*APS保留字段文字                        */
vol14       varchar2(60),            /*APS保留字段文字                        */
vol15       varchar2(60),            /*APS保留字段文字                        */
vol16       number(9),               /*APS保留字段数值                        */
vol17       number(18,8),            /*APS保留字段浮点数                      */
vol18       number(18,8),            /*APS保留字段浮点数                      */
vol19       date,                    /*APS保留字段日期                        */
vol20       date,                    /*APS保留字段日期                        */
vollegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
volplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vol_file add  constraint vol_pk primary key  (vol00,vol01,vol02,vol03,vol04,vol05,vol08,vol09,vol10) enable validate;
grant select on vol_file to tiptopgp;
grant update on vol_file to tiptopgp;
grant delete on vol_file to tiptopgp;
grant insert on vol_file to tiptopgp;
grant index on vol_file to public;
grant select on vol_file to ods;
