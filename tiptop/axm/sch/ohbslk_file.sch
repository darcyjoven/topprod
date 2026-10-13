/*
================================================================================
檔案代號:ohbslk_file
檔案名稱:SLK销退单款号单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohbslk_file
(
ohbslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*销退单号*/
ohbslk03    number(5) DEFAULT '0' NOT NULL, /*项次*/
ohbslk04    varchar2(40),            /*产品编号                               */
ohbslk05    varchar2(4),             /*销售单位                               */
ohbslk05_fac number(20,8) DEFAULT '0' NOT NULL, /*单位转换率*/
ohbslk06    varchar2(120),           /*品名规格                               */
ohbslk07    varchar2(10),            /*额外品名编号                           */
ohbslk08    varchar2(10),            /*销退入库营运中心编号                   */
ohbslk09    varchar2(10),            /*销退入库仓库编号                       */
ohbslk091   varchar2(10),            /*销退入库储位批号                       */
ohbslk092   varchar2(24),            /*销退入库批号                           */
ohbslk1003  number(9,4),             /*折扣率                                 */
ohbslk1012  number(20,6) DEFAULT '0' NOT NULL, /*已折让返利税前金额*/
ohbslk11    varchar2(40),            /*客户产品编号                           */
ohbslk12    number(15,3) DEFAULT '0' NOT NULL, /*数量*/
ohbslk13    number(20,6) DEFAULT '0' NOT NULL, /*原币单价*/
ohbslk14    number(20,6) DEFAULT '0' NOT NULL, /*原币税前金额*/
ohbslk14t   number(20,6) DEFAULT '0' NOT NULL, /*原币含税金额*/
ohbslk15    varchar2(4),             /*库存明细单位                           */
ohbslk15_fac number(20,8) DEFAULT '0' NOT NULL, /*单位转换率*/
ohbslk16    number(15,3) DEFAULT '0' NOT NULL, /*数量*/
ohbslk31    varchar2(20),            /*出货单号                               */
ohbslk32    number(5),               /*出货项次                               */
ohbslk33    varchar2(20),            /*订单单号                               */
ohbslk34    number(5),               /*订单项次                               */
ohbslk50    varchar2(10),            /*退货理由码                             */
ohbslk60    number(15,3) DEFAULT '0' NOT NULL, /*已开折让数量*/
ohbslk930   varchar2(10),            /*成本中心                               */
ohbslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ohbslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ohbslk_file add  constraint ohbslk_pk primary key  (ohbslk01,ohbslk03) enable validate;
grant select on ohbslk_file to tiptopgp;
grant update on ohbslk_file to tiptopgp;
grant delete on ohbslk_file to tiptopgp;
grant insert on ohbslk_file to tiptopgp;
grant index on ohbslk_file to public;
grant select on ohbslk_file to ods;
