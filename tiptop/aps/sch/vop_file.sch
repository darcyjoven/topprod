/*
================================================================================
檔案代號:vop_file
檔案名稱:aps製程外包檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vop_file
(
vop00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vop01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vop02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vop03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vop04       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vop05       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vop06       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vop07       varchar2(10),            /*外包商编号                             */
vop08       number(1),               /*外包类型                               */
vop09       date,                    /*开始时间(日期)                         */
vop10       date,                    /*结束时间(日期)                         */
vop11       number(9),               /*作业时间                               */
vop12       number(1),               /*排程                                   */
vop13       number(5),               /*外包商序号                             */
vop14       number(15,3),            /*外包数量                               */
vop16       number(1) DEFAULT '0' NOT NULL, /*更新否*/
vop15       number(1),               /*核算项 0:不变，1:新增，2:删除          */
vop17       varchar2(60),            /*APS保留字段文字                        */
vop18       varchar2(60),            /*APS保留字段文字                        */
vop19       varchar2(60),            /*APS保留字段文字                        */
vop20       number(9),               /*APS保留字段数值                        */
vop21       number(18,8),            /*APS保留字段浮点数                      */
vop22       number(18,8),            /*APS保留字段浮点数                      */
vop23       date,                    /*APS保留字段日期                        */
vop24       date,                    /*APS保留字段日期                        */
voplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vopplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vop012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vop_file add  constraint vop_pk primary key  (vop00,vop01,vop02,vop03,vop04,vop05,vop06,vop012) enable validate;
grant select on vop_file to tiptopgp;
grant update on vop_file to tiptopgp;
grant delete on vop_file to tiptopgp;
grant insert on vop_file to tiptopgp;
grant index on vop_file to public;
grant select on vop_file to ods;
