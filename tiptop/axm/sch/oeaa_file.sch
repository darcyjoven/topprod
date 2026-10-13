/*
================================================================================
檔案代號:oeaa_file
檔案名稱:销售系统订单多帐期明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeaa_file
(
oeaa01      varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号*/
oeaa02      varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
oeaa03      number(5) DEFAULT '0' NOT NULL, /*期别*/
oeaa04      varchar2(6),             /*子收款条件                             */
oeaa05      date,                    /*应收款日                               */
oeaa06      date,                    /*容許票據到基日                         */
oeaa07      number(20,10),           /*汇率                                   */
oeaa08      number(20,6),            /*应收金额                               */
oeaaplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
oeaalegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oeaa_file add  constraint oeaa_pk primary key  (oeaa01,oeaa02,oeaa03) enable validate;
grant select on oeaa_file to tiptopgp;
grant update on oeaa_file to tiptopgp;
grant delete on oeaa_file to tiptopgp;
grant insert on oeaa_file to tiptopgp;
grant index on oeaa_file to public;
grant select on oeaa_file to ods;
