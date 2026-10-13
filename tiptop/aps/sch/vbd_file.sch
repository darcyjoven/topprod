/*
================================================================================
檔案代號:vbd_file
檔案名稱:APS锁定制程时间
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbd_file
(
vbd01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vbd02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vbd03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vbd04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vbd05       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vbd06       number(1),               /*锁定码                                 */
vbd07       date,                    /*开始时间 to_date('2006-07-03 00:00:0   */
vbd08       date,                    /*结束时间  to_date('2006-07-03 00:00:   */
vbd09       number(1),               /*是否排程                               */
vbd10       number(1),               /*是否为平行机台任务                     */
vbdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vbdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vbd11       varchar2(60),            /*APS保留字段文字                        */
vbd12       varchar2(60),            /*APS保留字段文字                        */
vbd13       varchar2(60),            /*APS保留字段文字                        */
vbd14       number(9),               /*APS保留字段数值                        */
vbd15       number(18,8),            /*APS保留字段浮点数                      */
vbd16       number(18,8),            /*APS保留字段浮点数                      */
vbd17       date,                    /*APS保留字段日期                        */
vbd18       date,                    /*APS保留字段日期                        */
vbd19       varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vbd_file add  constraint vbd_pk primary key  (vbdlegal,vbdplant,vbd01,vbd02,vbd03,vbd04,vbd05,vbd19) enable validate;
grant select on vbd_file to tiptopgp;
grant update on vbd_file to tiptopgp;
grant delete on vbd_file to tiptopgp;
grant insert on vbd_file to tiptopgp;
grant index on vbd_file to public;
grant select on vbd_file to ods;
