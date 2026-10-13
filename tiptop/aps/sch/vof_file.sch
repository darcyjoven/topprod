/*
================================================================================
檔案代號:vof_file
檔案名稱:aps(製令製程每日產出)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vof_file
(
vof00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vof01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vof02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vof03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vof04       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vof05       varchar2(60) DEFAULT ' ' NOT NULL, /*工艺序号*/
vof06       varchar2(6) NOT NULL,    /*作业编号                               */
vof07       number(15,3),            /*制造数量                               */
vof08       date,                    /*开始时间                               */
vof09       date,                    /*完成时间                               */
vof10       varchar2(60),            /*资源群组编号                           */
vof11       varchar2(10) NOT NULL,   /*资源编号                               */
vof12       date,                    /*最早可开工时间时间                     */
vof13       date,                    /*最晚需完工时间时间                     */
vof14       number(1),               /*平行机台任务                           */
vof15       number(1),               /*是否连批                               */
vof16       number(18,8),            /*工艺被压缩时间                         */
vof17       varchar2(60),            /*工作站编号                             */
vof18       number(18,8),            /*产能重叠比率                           */
vof19       number(1),               /*是否超出排程边界                       */
vof20       number(15,3),            /*整备时间                               */
vof21       number(15,3),            /*加工时间                               */
vof22       varchar2(60),            /*APS保留字段文字                        */
vof23       varchar2(60),            /*APS保留字段文字                        */
vof24       varchar2(60),            /*APS保留字段文字                        */
vof25       number(9),               /*APS保留字段数值                        */
vof26       number(18,8),            /*APS保留字段浮点数                      */
vof27       number(18,8),            /*APS保留字段浮点数                      */
vof28       date,                    /*APS保留字段日期                        */
vof29       date,                    /*APS保留字段日期                        */
voflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vofplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vof012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号　*/
);

alter table vof_file add  constraint vof_pk primary key  (vof00,vof01,vof02,vof03,vof04,vof05,vof06,vof11,vof012) enable validate;
grant select on vof_file to tiptopgp;
grant update on vof_file to tiptopgp;
grant delete on vof_file to tiptopgp;
grant insert on vof_file to tiptopgp;
grant index on vof_file to public;
grant select on vof_file to ods;
