/*
================================================================================
檔案代號:rupslk_file
檔案名稱:SLK产品调拨单款式单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rupslk_file
(
rupslk01    varchar2(20) DEFAULT ' ' NOT NULL,
rupslk02    number(5) DEFAULT '0' NOT NULL, /*项次*/
rupslk03    varchar2(40),
rupslk04    varchar2(4),             /*库存单位                               */
rupslk05    varchar2(1) DEFAULT ' ' NOT NULL, /*经营方式*/
rupslk06    varchar2(40),
rupslk07    varchar2(4),
rupslk08    number(16,8),            /*单位换算率                             */
rupslk09    varchar2(10),            /*拨出仓库                               */
rupslk10    varchar2(10),            /*拨出库位                               */
rupslk11    varchar2(24),            /*拨出批号                               */
rupslk12    number(15,3) DEFAULT '0' NOT NULL, /*拨出数量*/
rupslk13    varchar2(10),            /*拨入仓库                               */
rupslk14    varchar2(10),            /*拨入库位                               */
rupslk15    varchar2(24),            /*拨入批号                               */
rupslk16    number(15,3) DEFAULT '0' NOT NULL, /*拨入数量*/
rupslk17    number(5) DEFAULT '0' NOT NULL, /*来源项次*/
rupslk18    varchar2(1) DEFAULT ' ' NOT NULL, /*结案否*/
rupslk19    number(15,3) DEFAULT '0' NOT NULL,
rupslk20    number(20,6) DEFAULT '0' NOT NULL,
rupslk21    number(20,6) DEFAULT '0' NOT NULL,
rupslk22    number(9,4),             /*折扣率                                 */
rupslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rupslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rupslk_file add  constraint rupslk_pk primary key  (rupslk01,rupslk02,rupslkplant) enable validate;
grant select on rupslk_file to tiptopgp;
grant update on rupslk_file to tiptopgp;
grant delete on rupslk_file to tiptopgp;
grant insert on rupslk_file to tiptopgp;
grant index on rupslk_file to public;
grant select on rupslk_file to ods;
