/*
================================================================================
檔案代號:vaw_file
檔案名稱:APS制令/工单
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vaw_file
(
vaw01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vaw02       number(15,3),            /*需求数量                               */
vaw03       varchar2(20),            /*采购单号（erp）                        */
vaw04       date,                    /*预计完工日（erp）                      */
vaw05       date,                    /*预计开立日（erp）                      */
vaw06       varchar2(40),            /*料号                                   */
vaw07       number(5),               /*优先顺序                               */
vaw08       varchar2(80),            /*工艺路线                               */
vaw09       varchar2(4),             /*品项类型                               */
vaw10       number(1),               /*单位                                   */
vaw11       varchar2(60),            /*完全发料                               */
vaw12       number(15,3),            /*计划批号                               */
vaw13       number(15,3),            /*已生产量                               */
vaw14       varchar2(10),            /*报废数量                               */
vaw15       number(1),               /*拥有者                                 */
vaw16       number(20,8),            /*状态                                   */
vaw17       varchar2(60),            /*转换比率                               */
vaw18       number(1),               /*供给法则编号                           */
vaw19       varchar2(10),            /*锁定                                   */
vaw20       date,                    /*开立者                                 */
vaw21       number(1),               /*备注1                                  */
vaw22       number(1),               /*备注2                                  */
vaw23       number(1),               /*关键物料进料限制时间点                 */
vaw24       varchar2(10),            /*手动调整                               */
vaw25       number(1),               /*是否受供给法则限制, 0;否 1:是          */
vawplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vawlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vaw26       number(1),               /*MO多餘量需求建立模式 0:多餘            */
vaw27       varchar2(60),            /*APS保留字段文字                        */
vaw28       varchar2(60),            /*APS保留字段文字                        */
vaw29       varchar2(60),            /*APS保留字段文字                        */
vaw30       number(9),               /*APS保留字段数值                        */
vaw31       number(18,8),            /*APS保留字段浮点数                      */
vaw32       number(18,8),            /*APS保留字段浮点数                      */
vaw33       date,                    /*APS保留字段日期                        */
vaw34       date,                    /*APS保留字段日期                        */
vaw35       number(15,3)             /*已发套数                               */
);

alter table vaw_file add  constraint vaw_pk primary key  (vawlegal,vawplant,vaw01) enable validate;
grant select on vaw_file to tiptopgp;
grant update on vaw_file to tiptopgp;
grant delete on vaw_file to tiptopgp;
grant insert on vaw_file to tiptopgp;
grant index on vaw_file to public;
grant select on vaw_file to ods;
