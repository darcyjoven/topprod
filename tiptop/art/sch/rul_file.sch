/*
================================================================================
檔案代號:rul_file
檔案名稱:赠品入库/出库单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rul_file
(
rul00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型1-入库单 2-出库单*/
rul01       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品入库/出库单*/
rul02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rul03       varchar2(40),            /*产品编号                               */
rul04       varchar2(4),             /*库存单位                               */
rul05       varchar2(40),            /*产品条码                               */
rul06       varchar2(4),             /*入库/出库单位                          */
rul07       number(18,8),            /*单位换算率-入库/出库单位:库            */
rul08       number(15,3) DEFAULT '0' NOT NULL, /*原入库量*/
rul09       number(15,3) DEFAULT '0' NOT NULL, /*已出量*/
rul10       number(15,3) DEFAULT '0' NOT NULL, /*入库量/本次出库量*/
rul11       varchar2(10),            /*仓库                                   */
rul12       varchar2(10),            /*库位                                   */
rul13       varchar2(24),            /*批号                                   */
rullegal    varchar2(10) NOT NULL,   /*所属法人                               */
rulplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rul_file add  constraint rul_pk primary key  (rul00,rul01,rul02,rulplant) enable validate;
grant select on rul_file to tiptopgp;
grant update on rul_file to tiptopgp;
grant delete on rul_file to tiptopgp;
grant insert on rul_file to tiptopgp;
grant index on rul_file to public;
grant select on rul_file to ods;
