/*
================================================================================
檔案代號:vaz_file
檔案名稱:APS采购令
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vaz_file
(
vaz01       varchar2(60) DEFAULT ' ' NOT NULL, /*采购单编号*/
vaz02       date,                    /*erp预计抵达日期                        */
vaz03       varchar2(60),            /*库房位置                               */
vaz04       varchar2(40),            /*料号                                   */
vaz05       number(15,3),            /*预计采购数量                           */
vaz06       date,                    /*erp预计开立日期                        */
vaz07       varchar2(10),            /*供应商编号                             */
vaz08       varchar2(4),             /*采购单位                               */
vaz09       varchar2(60),            /*计划批号                               */
vaz10       varchar2(20),            /*erp中对应的采购单单号                  */
vaz11       number(15,3),            /*已入库数量                             */
vaz12       number(1),               /*是否保留                               */
vaz13       varchar2(10),            /*拥有者                                 */
vaz14       number(1),               /*状态                                   */
vaz15       number(20,8),            /*转换比率                               */
vaz16       varchar2(60),            /*供给法则编号                           */
vaz17       number(1),               /*锁定                                   */
vaz18       number(15,3),            /*待验量                                 */
vaz19       number(15,3),            /*待入库量                               */
vaz20       number(15,3),            /*验退量                                 */
vaz21       varchar2(10),            /*开立者                                 */
vaz22       number(15,3),            /*在验量                                 */
vaz23       number(5),               /*erp中对应的采购单项次                  */
vaz24       varchar2(1),             /*单据类型                               */
vaz25       number(1),               /*是否受供给法则限制, 0;否 1:是          */
vaz26       date,                    /*预计到库日                             */
vazplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vazlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vaz27       varchar2(60),            /*APS保留字段文字                        */
vaz28       varchar2(60),            /*APS保留字段文字                        */
vaz29       varchar2(60),            /*APS保留字段文字                        */
vaz30       number(9),               /*APS保留字段数值                        */
vaz31       number(18,8),            /*APS保留字段浮点数                      */
vaz32       number(18,8),            /*APS保留字段浮点数                      */
vaz33       date,                    /*APS保留字段日期                        */
vaz34       date                     /*APS保留字段日期                        */
);

alter table vaz_file add  constraint vaz_pk primary key  (vazlegal,vazplant,vaz01) enable validate;
grant select on vaz_file to tiptopgp;
grant update on vaz_file to tiptopgp;
grant delete on vaz_file to tiptopgp;
grant insert on vaz_file to tiptopgp;
grant index on vaz_file to public;
grant select on vaz_file to ods;
