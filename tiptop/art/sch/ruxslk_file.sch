/*
================================================================================
檔案代號:ruxslk_file
檔案名稱:SLK盘点单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruxslk_file
(
ruxslk00    varchar2(1) DEFAULT ' ' NOT NULL, /*單据別*/
ruxslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*单据号码*/
ruxslk02    number(5) DEFAULT '0' NOT NULL, /*项次*/
ruxslk03    varchar2(40),            /*产品编号                               */
ruxslk04    varchar2(4),             /*库存单位                               */
ruxslk06    number(15,3) DEFAULT '0' NOT NULL, /*实盘数量*/
ruxslk09    varchar2(255),           /*備注                                   */
ruxslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ruxslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ruxslk_file add  constraint ruxslk_pk primary key  (ruxslk00,ruxslk01,ruxslk02) enable validate;
grant select on ruxslk_file to tiptopgp;
grant update on ruxslk_file to tiptopgp;
grant delete on ruxslk_file to tiptopgp;
grant insert on ruxslk_file to tiptopgp;
grant index on ruxslk_file to public;
grant select on ruxslk_file to ods;
