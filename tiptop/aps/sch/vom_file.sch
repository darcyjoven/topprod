/*
================================================================================
檔案代號:vom_file
檔案名稱:aps鎖定製程時間檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vom_file
(
vom00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vom01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vom02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vom03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vom04       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vom05       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vom06       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vom07       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vom08       number(1),               /*锁定码                                 */
vom09       date,                    /*开始时间(日期)                         */
vom10       date,                    /*结束时间(日期)                         */
vom11       number(1),               /*排程                                   */
vom12       number(1),               /*平行机台任务                           */
vom13       number(1) DEFAULT '0' NOT NULL, /*更新否*/
vom14       number(1),               /*核算项 0:不变，1:新增，2:删除          */
vom15       varchar2(60),            /*APS保留字段文字                        */
vom16       varchar2(60),            /*APS保留字段文字                        */
vom17       varchar2(60),            /*APS保留字段文字                        */
vom18       number(9),               /*APS保留字段数值                        */
vom19       number(18,8),            /*APS保留字段浮点数                      */
vom20       number(18,8),            /*APS保留字段浮点数                      */
vom21       date,                    /*APS保留字段日期                        */
vom22       date,                    /*APS保留字段日期                        */
vomlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vomplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vom012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vom_file add  constraint vom_pk primary key  (vom00,vom01,vom02,vom03,vom04,vom05,vom06,vom07,vom012) enable validate;
grant select on vom_file to tiptopgp;
grant update on vom_file to tiptopgp;
grant delete on vom_file to tiptopgp;
grant insert on vom_file to tiptopgp;
grant index on vom_file to public;
grant select on vom_file to ods;
