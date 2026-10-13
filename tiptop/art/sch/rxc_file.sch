/*
================================================================================
檔案代號:rxc_file
檔案名稱:销售折价明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxc_file
(
rxc00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别:01-订单,02-销售单,03-销 */
rxc01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxc02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxc03       varchar2(2) DEFAULT ' ' NOT NULL, /*折价方式*/
                                     /*折价方式:                              */
                                     /*01.一般促销,02.组合促销,03.满额促销,06.会员价,07.客户折价,08.产品数量折扣,09.客户提案促销,10.特卖价格促销,11.特卖数量促销,12.促销会员折价,13单项折价,14.小计折价,15.折价券,16.强迫改价,17.去尾数,18.加购价,19.赠品,20.储值折扣*/
rxc04       varchar2(20) DEFAULT ' ' NOT NULL, /*来源单号*/
rxc05       varchar2(20),            /*分类促销单号                           */
rxc06       number(20,6) DEFAULT '0' NOT NULL, /*折价金额*/
rxc07       number(5,2),             /*厂商促销分摊比例                       */
rxc08       varchar2(20),            /*返券促销单号                           */
rxc09       number(20,6) DEFAULT '0' NOT NULL, /*返券金额*/
rxc10       number(5,2),             /*厂商返券分摊比例                       */
rxclegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxc11       varchar2(1) DEFAULT 'N' NOT NULL, /*是否会员*/
rxc12       varchar2(10),            /*结算营运中心                           */
rxc13       varchar2(10),            /*分离厂商                               */
rxc14       varchar2(20),            /*分离来源单号                           */
rxc15       number(15,3) DEFAULT '0' NOT NULL /*数量-参加促销的数量*/
);

alter table rxc_file add  constraint rxc_pk primary key  (rxc00,rxc01,rxc02,rxc03,rxc04) enable validate;
grant select on rxc_file to tiptopgp;
grant update on rxc_file to tiptopgp;
grant delete on rxc_file to tiptopgp;
grant insert on rxc_file to tiptopgp;
grant index on rxc_file to public;
grant select on rxc_file to ods;
