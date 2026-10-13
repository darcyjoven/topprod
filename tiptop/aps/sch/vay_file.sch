/*
================================================================================
檔案代號:vay_file
檔案名稱:APS现场报工
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vay_file
(
vay01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vay02       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vay03       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vay04       varchar2(10),            /*资源编号                               */
vay05       varchar2(60),            /*资源群组编号                           */
vay06       number(15,3),            /*未完成量                               */
vay07       date,                    /*预计开工日                             */
vay08       date,                    /*预计完工日                             */
vay09       date,                    /*实际开工日                             */
vay10       number(1),               /*批次加工                               */
vay11       number(15,3),            /*整备时间                               */
vay12       number(15,3),            /*基准加工时间                           */
vay13       number(9),               /*移转批量大小                           */
vay14       number(9),               /*基准数量                               */
vay15       number(1),               /*外包作业                               */
vay16       number(9),               /*最大批次数量                           */
vay17       varchar2(10),            /*外包厂商                               */
vayplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vaylegal    varchar2(10) NOT NULL,   /*所属法人                               */
vay18       varchar2(60),            /*APS保留字段文字                        */
vay19       varchar2(60),            /*APS保留字段文字                        */
vay20       varchar2(60),            /*APS保留字段文字                        */
vay21       number(9),               /*APS保留字段数值                        */
vay22       number(18,8),            /*APS保留字段浮点数                      */
vay23       number(18,8),            /*APS保留字段浮点数                      */
vay24       date,                    /*APS保留字段日期                        */
vay25       date,                    /*APS保留字段日期                        */
vay26       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
vay27       varchar2(10),            /*工作站                                 */
vay28       varchar2(80)             /*工作站名称                             */
);

alter table vay_file add  constraint vay_pk primary key  (vaylegal,vayplant,vay01,vay02,vay03,vay26) enable validate;
grant select on vay_file to tiptopgp;
grant update on vay_file to tiptopgp;
grant delete on vay_file to tiptopgp;
grant insert on vay_file to tiptopgp;
grant index on vay_file to public;
grant select on vay_file to ods;
