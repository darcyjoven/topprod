/*
================================================================================
檔案代號:ido_file
檔案名稱:ICD厂商WIP资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ido_file
(
ido01       varchar2(20),            /*档案编号                               */
ido02       varchar2(10) DEFAULT ' ' NOT NULL, /*工厂 facility*/
ido03       varchar2(10) DEFAULT ' ' NOT NULL, /*厂别 site*/
ido04       varchar2(20),            /*po_no                                  */
ido05       varchar2(80),            /*po_item                                */
ido06       varchar2(80) DEFAULT ' ' NOT NULL, /*part_no*/
ido07       varchar2(24) DEFAULT ' ' NOT NULL, /*lot_id*/
ido08       varchar2(1),             /*status                                 */
ido09       number(15,3),            /*input_qty                              */
ido10       number(15,3),            /*QTY                                    */
ido11       varchar2(10),            /*stage                                  */
ido12       varchar2(10),            /*operation_code                         */
ido13       varchar2(10),            /*operation                              */
ido14       varchar2(10),            /*oper_no                                */
ido15       varchar2(10),            /*rem_oper_n                             */
ido16       date,                    /*stb_date                               */
ido17       date,                    /*fcst_out                               */
ido18       varchar2(10),            /*os_no                                  */
ido19       varchar2(10),            /*process code                           */
ido20       varchar2(24),            /*os_lot_id                              */
ido21       varchar2(24),            /*lot_attribute                          */
ido22       varchar2(10),            /*eq_name                                */
ido23       number(15,3),            /*良品数量                               */
ido24       number(15,3),            /*不良品数量                             */
ido25       varchar2(80),            /*Wafer Id                               */
idoacti     varchar2(1),             /*资料有效码                             */
idodate     date,                    /*最近更改日                             */
idogrup     varchar2(10),            /*资料所有群                             */
idomodu     varchar2(10),            /*资料更改者                             */
idouser     varchar2(10),            /*资料所有者                             */
idoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idolegal    varchar2(10) NOT NULL,   /*所属法人                               */
idoorig     varchar2(10),            /*资料建立部门                           */
idooriu     varchar2(10)             /*资料建立者                             */
);

alter table ido_file add  constraint ido_pk primary key  (ido02,ido03,ido06,ido07) enable validate;
grant select on ido_file to tiptopgp;
grant update on ido_file to tiptopgp;
grant delete on ido_file to tiptopgp;
grant insert on ido_file to tiptopgp;
grant index on ido_file to public;
grant select on ido_file to ods;
