/*
================================================================================
檔案代號:ogbslk_file
檔案名稱:SLK出货单款号单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogbslk_file
(
ogbslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号*/
ogbslk03    number(5) DEFAULT '0' NOT NULL, /*项次*/
ogbslk04    varchar2(40),            /*产品编号                               */
ogbslk05    varchar2(4),             /*销售单位                               */
ogbslk05_fac number(20,8),           /*单位换算率                             */
ogbslk06    varchar2(120),           /*品名规格                               */
ogbslk07    varchar2(10),            /*额外品名编号                           */
ogbslk09    varchar2(10),            /*出货仓库编号                           */
ogbslk091   varchar2(10),            /*出货库位编号                           */
ogbslk092   varchar2(10),            /*出货批号                               */
ogbslk1013  number(20,6) DEFAULT '0' NOT NULL, /*已开发票税前金额*/
ogbslk11    varchar2(40),            /*客户产品编号                           */
ogbslk12    number(15,3) DEFAULT '0' NOT NULL, /*实际出货数量（依销售单位）*/
ogbslk13    number(20,6) DEFAULT '0' NOT NULL, /*原币单价*/
ogbslk131   number(20,6) DEFAULT '0' NOT NULL, /*結算價*/
ogbslk14    number(20,6) DEFAULT '0' NOT NULL, /*原币税前金额*/
ogbslk14t   number(20,6) DEFAULT '0' NOT NULL, /*原币含税金额*/
ogbslk15    varchar2(4),             /*库存明细单位（img09）                  */
ogbslk15_fac number(20,8),           /*单位换算率                             */
ogbslk16    number(15,3) DEFAULT '0' NOT NULL, /*数量（依库存明细单位）*/
ogbslk18    number(15,3) DEFAULT '0' NOT NULL, /*预计出货数量（依销售单位）*/
ogbslk31    varchar2(20),            /*订单单号                               */
ogbslk32    number(5),               /*订单项次                               */
ogbslk60    number(15,3) DEFAULT '0' NOT NULL, /*已开发票数量*/
ogbslk63    number(15,3) DEFAULT '0' NOT NULL, /*消退数量（需换货再出货）*/
ogbslk64    number(15,3) DEFAULT '0' NOT NULL, /*消退数量（不需换货出货）*/
ogbslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ogbslkplant varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ogbslk1006  number(9,4)              /*折扣率                                 */
);

alter table ogbslk_file add  constraint ogbslk_pk primary key  (ogbslk01,ogbslk03) enable validate;
grant select on ogbslk_file to tiptopgp;
grant update on ogbslk_file to tiptopgp;
grant delete on ogbslk_file to tiptopgp;
grant insert on ogbslk_file to tiptopgp;
grant index on ogbslk_file to public;
grant select on ogbslk_file to ods;
