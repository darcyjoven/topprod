/*
================================================================================
檔案代號:rup_file
檔案名稱:产品调拨单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rup_file
(
rup01       varchar2(20) DEFAULT ' ' NOT NULL, /*机构调拨单号*/
rup02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rup03       varchar2(40),            /*产品编号                               */
rup04       varchar2(4),             /*库存单位                               */
rup05       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rup06       varchar2(40),            /*产品条码                               */
rup07       varchar2(4),             /*调拨单位                               */
rup08       number(16,8),            /*单位换算率                             */
rup09       varchar2(10),            /*拨出仓库                               */
rup10       varchar2(10),            /*拨出库位                               */
rup11       varchar2(24),            /*拨出批号                               */
rup12       number(15,3),            /*拨出数量                               */
rup13       varchar2(10),            /*拨入仓库                               */
rup14       varchar2(10),            /*拨入库位                               */
rup15       varchar2(24),            /*拨入批号                               */
rup16       number(15,3),            /*拨入数量                               */
ruplegal    varchar2(10) NOT NULL,   /*所属法人                               */
rupplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rup17       number(5) DEFAULT '0' NOT NULL, /*来源项次*/
rup18       varchar2(1),             /*结案否                                 */
rup19       number(15,3),            /*预调拨量                               */
rup20s      varchar2(40),            /*料件编号                               */
rup21s      number(5),               /*项次                                   */
rup22       varchar2(10)             /*收货营运中心                           */
);

alter table rup_file add  constraint rup_pk primary key  (rup01,rup02,rupplant) enable validate;
grant select on rup_file to tiptopgp;
grant update on rup_file to tiptopgp;
grant delete on rup_file to tiptopgp;
grant insert on rup_file to tiptopgp;
grant index on rup_file to public;
grant select on rup_file to ods;
