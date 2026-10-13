/*
================================================================================
檔案代號:rxg_file
檔案名稱:代管库存明细档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table rxg_file
(
rxg01       varchar2(40),            /*产品编号                               */
rxg02       date,                    /*单据日期                               */
rxg03       date,                    /*运行日期                               */
rxg04       varchar2(1) DEFAULT ' ' NOT NULL, /*异动状况*/
rxg05       varchar2(20) DEFAULT ' ' NOT NULL, /*异动单号*/
rxg06       number(5) DEFAULT '0' NOT NULL, /*异动项次*/
rxg07       number(15,3) NOT NULL,   /*数量                                   */
rxg08       varchar2(4),             /*单位                                   */
rxg09       varchar2(10),            /*仓库                                   */
rxg10       varchar2(10),            /*库位                                   */
rxg11       varchar2(24),            /*批号                                   */
rxg12       varchar2(20),            /*订单编号                               */
rxg13       number(5),               /*订单项次                               */
rxg14       varchar2(20),            /*配送单号                               */
rxg15       number(5),               /*配送单项次                             */
rxg16       varchar2(10),            /*配送中心                               */
rxg17       varchar2(10) DEFAULT ' ' NOT NULL, /*订货营运中心*/
rxg18       varchar2(10),            /*取货营运中心                           */
rxglegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxgplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rxg_file add  constraint rxg_pk primary key  (rxg05,rxg06,rxg17,rxgplant) enable validate;
grant select on rxg_file to tiptopgp;
grant update on rxg_file to tiptopgp;
grant delete on rxg_file to tiptopgp;
grant insert on rxg_file to tiptopgp;
grant index on rxg_file to public;
grant select on rxg_file to ods;
