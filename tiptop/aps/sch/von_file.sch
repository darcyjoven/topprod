/*
================================================================================
檔案代號:von_file
檔案名稱:aps鎖定使用設備檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table von_file
(
von00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
von01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
von02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
von03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
von04       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
von05       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
von06       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
von07       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
von08       number(15,3),            /*未完成量                               */
von09       number(1),               /*排程                                   */
von10       number(1) DEFAULT '0' NOT NULL, /*更新否*/
von11       number(1),               /*核算项 0:不变，1:新增，2:删除          */
von12       varchar2(60),            /*APS保留字段文字                        */
von13       varchar2(60),            /*APS保留字段文字                        */
von14       varchar2(60),            /*APS保留字段文字                        */
von15       number(9),               /*APS保留字段数值                        */
von16       number(18,8),            /*APS保留字段浮点数                      */
von17       number(18,8),            /*APS保留字段浮点数                      */
von18       date,                    /*APS保留字段日期                        */
von19       date,                    /*APS保留字段日期                        */
vonlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vonplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
von012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table von_file add  constraint von_pk primary key  (von00,von01,von02,von03,von04,von05,von06,von07,von012) enable validate;
grant select on von_file to tiptopgp;
grant update on von_file to tiptopgp;
grant delete on von_file to tiptopgp;
grant insert on von_file to tiptopgp;
grant index on von_file to public;
grant select on von_file to ods;
