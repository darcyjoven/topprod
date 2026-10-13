/*
================================================================================
檔案代號:rvvslk_file
檔案名稱:SLK入库/退扣单款号异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvvslk_file
(
rvvslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*入库单号*/
rvvslk02    number(5) DEFAULT '0' NOT NULL, /*项次*/
rvvslk03    varchar2(1),             /*异动类别                               */
rvvslk031   varchar2(120),           /*品名                                   */
rvvslk04    varchar2(20),            /*收货单号                               */
rvvslk05    number(5),               /*项次                                   */
rvvslk10    varchar2(1) DEFAULT ' ' NOT NULL, /*取价类型*/
rvvslk11    varchar2(20),            /*价格来源                               */
rvvslk17    number(15,3) DEFAULT '0' NOT NULL, /*数量*/
rvvslk31    varchar2(40),            /*料件编号                               */
rvvslk32    varchar2(10),            /*仓库                                   */
rvvslk33    varchar2(10),            /*存放位置                               */
rvvslk34    varchar2(24),            /*批号                                   */
rvvslk35    varchar2(4),             /*单位                                   */
rvvslk35_fac number(20,8),           /*转换率                                 */
rvvslk36    varchar2(20),            /*采购单号                               */
rvvslk37    number(5),               /*采购项次                               */
rvvslk38    number(20,6) DEFAULT '0' NOT NULL, /*单价*/
rvvslk38t   number(20,6) DEFAULT '0' NOT NULL, /*含稅單价*/
rvvslk39    number(20,6) DEFAULT '0' NOT NULL, /*金额*/
rvvslk39t   number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
rvvslk930   varchar2(10),            /*成本中心                               */
rvvslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rvvslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rvvslk_file add  constraint rvvslk_pk primary key  (rvvslk01,rvvslk02) enable validate;
grant select on rvvslk_file to tiptopgp;
grant update on rvvslk_file to tiptopgp;
grant delete on rvvslk_file to tiptopgp;
grant insert on rvvslk_file to tiptopgp;
grant index on rvvslk_file to public;
grant select on rvvslk_file to ods;
