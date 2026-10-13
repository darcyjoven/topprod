/*
================================================================================
檔案代號:lpt_file
檔案名稱:发卡单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpt_file
(
lpt00       varchar2(10),            /*no use                                 */
lpt01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lpt02       varchar2(30) DEFAULT ' ' NOT NULL, /*开始卡号*/
lpt03       varchar2(20),            /*卡种编号                               */
lpt04       varchar2(1) DEFAULT ' ' NOT NULL, /*该卡属*/
lpt05       number(20,2) DEFAULT '0' NOT NULL, /*消费金额底线*/
lpt06       number(20,2) DEFAULT '0' NOT NULL, /*购卡金额*/
lpt07       number(20,2) DEFAULT '0' NOT NULL, /*总消费金额底线*/
lptlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lptplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpt021      varchar2(30),            /*结束卡号                               */
lpt08       number(20,2) DEFAULT '0' NOT NULL, /*总购卡金额*/
lpt09       number(20,2) DEFAULT '0' NOT NULL, /*单张卡内金额*/
lpt10       number(20,2) DEFAULT '0' NOT NULL, /*总卡内金额*/
lpt11       number(6,2),             /*折扣比率                               */
lpt12       number(20,2) DEFAULT '0' NOT NULL, /*总折扣金额*/
lpt13       number(20,2) DEFAULT '0' NOT NULL, /*付款金额*/
lpt14       date,                    /*有效期至                               */
lpt15       varchar2(20),            /*会员编号                               */
lpt16       date,                    /*余额有效期至                           */
lpt17       number(20,6) DEFAULT '0' NOT NULL /*加值金额*/
);

alter table lpt_file add  constraint lpt_pk primary key  (lpt01,lpt02) enable validate;
grant select on lpt_file to tiptopgp;
grant update on lpt_file to tiptopgp;
grant delete on lpt_file to tiptopgp;
grant insert on lpt_file to tiptopgp;
grant index on lpt_file to public;
grant select on lpt_file to ods;
