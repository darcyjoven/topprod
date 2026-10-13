/*
================================================================================
檔案代號:oebslk_file
檔案名稱:订单母料件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oebslk_file
(
oebslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号*/
oebslk03    number(5) DEFAULT '0' NOT NULL, /*项次*/
oebslk04    varchar2(40),            /*產品款號                               */
oebslk05    varchar2(4),             /*销售单位                               */
oebslk05_fac number(20,8) DEFAULT '1' NOT NULL, /*换算率*/
oebslk06    varchar2(120),           /*品名规格                               */
oebslk07    varchar2(10),            /*额外品名编号                           */
oebslk09    varchar2(10),            /*出货仓库                               */
oebslk091   varchar2(10),            /*出货库位                               */
oebslk092   varchar2(24),            /*出货批号                               */
oebslk1006  number(9,4) DEFAULT '0', /*折扣率                                 */
oebslk11    varchar2(40),            /*客户产品编号                           */
oebslk12    number(15,3) DEFAULT '0' NOT NULL, /*数量*/
oebslk13    number(20,6) DEFAULT '0' NOT NULL, /*单价*/
oebslk131   number(20,6) DEFAULT '0' NOT NULL, /*結算價*/
oebslk14    number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
oebslk14t   number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
oebslk23    number(15,3) DEFAULT '0' NOT NULL, /*待出货数量*/
oebslk24    number(15,3) DEFAULT '0' NOT NULL, /*已出货数量*/
oebslk25    number(15,3) DEFAULT '0' NOT NULL, /*已销退数量*/
oebslk26    number(15,3) DEFAULT '0' NOT NULL, /*被结案数量*/
oebslk28    number(15,3) DEFAULT '0' NOT NULL, /*已转请购量*/
oebslklegal varchar2(10),            /*所属法人                               */
oebslkplant varchar2(10),            /*所属工厂                               */
oebslk15    date                     /*约定交货日                             */
);

alter table oebslk_file add  constraint oebslk_pk primary key  (oebslk01,oebslk03) enable validate;
grant select on oebslk_file to tiptopgp;
grant update on oebslk_file to tiptopgp;
grant delete on oebslk_file to tiptopgp;
grant insert on oebslk_file to tiptopgp;
grant index on oebslk_file to public;
grant select on oebslk_file to ods;
