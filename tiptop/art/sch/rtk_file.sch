/*
================================================================================
檔案代號:rtk_file
檔案名稱:策略变更单策略单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtk_file
(
rtk01       varchar2(20) DEFAULT ' ' NOT NULL, /*策略变更单号*/
rtk02       varchar2(1) DEFAULT ' ' NOT NULL, /*变更类型*/
                                     /*Changed Type 1:Merchandising Strategy 2:Price Strategy*/
rtk03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtk04       varchar2(10),            /*产品策略编号                           */
rtk05       varchar2(10),            /*价格策略编号                           */
rtklegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtkplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rtk_file add  constraint rtk_pk primary key  (rtk01,rtk02,rtk03) enable validate;
grant select on rtk_file to tiptopgp;
grant update on rtk_file to tiptopgp;
grant delete on rtk_file to tiptopgp;
grant insert on rtk_file to tiptopgp;
grant index on rtk_file to public;
grant select on rtk_file to ods;
