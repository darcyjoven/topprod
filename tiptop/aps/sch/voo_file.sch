/*
================================================================================
檔案代號:voo_file
檔案名稱:aps製令外包檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voo_file
(
voo00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voo01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
voo02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voo03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
voo04       varchar2(10),            /*外包商编号                             */
voo05       number(1),               /*外包类型                               */
voo06       date,                    /*开始时间(日期)                         */
voo07       date,                    /*结束时间(日期)                         */
voo08       number(9),               /*结束时间(日期)                         */
voo09       number(1),               /*是否已排程                             */
voo10       number(1),               /*核算项 0:不变，1:新增，2:删除          */
voo11       varchar2(60),            /*APS保留字段文字                        */
voo12       varchar2(60),            /*APS保留字段文字                        */
voo13       varchar2(60),            /*APS保留字段文字                        */
voo14       number(9),               /*APS保留字段数值                        */
voo15       number(18,8),            /*APS保留字段浮点数                      */
voo16       number(18,8),            /*APS保留字段浮点数                      */
voo17       date,                    /*APS保留字段日期                        */
voo18       date,                    /*APS保留字段日期                        */
voolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vooplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table voo_file add  constraint voo_pk primary key  (voo00,voo01,voo02,voo03) enable validate;
grant select on voo_file to tiptopgp;
grant update on voo_file to tiptopgp;
grant delete on voo_file to tiptopgp;
grant insert on voo_file to tiptopgp;
grant index on voo_file to public;
grant select on voo_file to ods;
