/*
================================================================================
檔案代號:ltd_file
檔案名稱:促销金额资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltd_file
(
ltd01       varchar2(10),            /*no use 原门店编号                      */
ltd02       varchar2(20) DEFAULT ' ' NOT NULL, /*租赁合同号*/
ltd03       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
ltd04       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
ltd05       varchar2(20) DEFAULT ' ' NOT NULL, /*促销编号*/
ltd06       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
ltd07       varchar2(10),            /*楼栋编号                               */
ltd08       varchar2(10),            /*楼层编号                               */
ltd09       varchar2(10),            /*大类编号                               */
ltd10       varchar2(10),            /*中类编号                               */
ltd11       varchar2(10),            /*小类编号                               */
ltd12       number(20,2) DEFAULT '0' NOT NULL, /*折扣返券金额*/
ltd13       number(20,2) DEFAULT '0' NOT NULL, /*折扣返券应返金额*/
ltd14       number(20,2) DEFAULT '0' NOT NULL, /*直接折扣金额*/
ltd15       number(20,2) DEFAULT '0' NOT NULL, /*直接折扣应返金额*/
ltd16       number(20,2) DEFAULT '0' NOT NULL, /*返券返现金额*/
ltd17       number(20,2) DEFAULT '0' NOT NULL, /*返券返现应返金额*/
ltd18       number(20,2) DEFAULT '0' NOT NULL, /*活动赠品金额*/
ltd19       number(20,2) DEFAULT '0' NOT NULL, /*活动赠品应返金额*/
ltdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltdstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ltd_file add  constraint ltd_pk primary key  (ltd02,ltd03,ltd04,ltd05) enable validate;
grant select on ltd_file to tiptopgp;
grant update on ltd_file to tiptopgp;
grant delete on ltd_file to tiptopgp;
grant insert on ltd_file to tiptopgp;
grant index on ltd_file to public;
grant select on ltd_file to ods;
