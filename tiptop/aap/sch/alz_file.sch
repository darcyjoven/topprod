/*
================================================================================
檔案代號:alz_file
檔案名稱:应收/应付帐龄分析统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table alz_file
(
alz00       varchar2(1) DEFAULT '1' NOT NULL, /*类型*/
alz01       varchar2(10) DEFAULT ' ' NOT NULL, /*客户厂商编号*/
alz02       number(5) DEFAULT '0' NOT NULL, /*年度*/
alz03       number(5) DEFAULT '0' NOT NULL, /*月份*/
alz04       varchar2(20) DEFAULT ' ' NOT NULL, /*帐款编号*/
alz05       number(5) DEFAULT '1' NOT NULL, /*子帐期项次*/
alz06       date,                    /*立帐日期                               */
alz07       date,                    /*收付款日期                             */
alz08       number(20,6) DEFAULT '0' NOT NULL, /*本幣應收(應付)金額*/
alz08f      number(20,6) DEFAULT '0' NOT NULL, /*原幣應收(應付)金額*/
alz09       number(20,6) DEFAULT '0' NOT NULL, /*本幣未收(未付)金額*/
alz09f      number(20,6) DEFAULT '0' NOT NULL, /*原幣未收(未付)金額*/
alz10       varchar2(4),             /*币种                                   */
alz11       varchar2(2),             /*帐款性质                               */
alz12       varchar2(10),            /*子账期收款条件                         */
alz13       number(20,6) DEFAULT '0' NOT NULL, /*本币当期发生金额*/
alz13f      number(20,6) DEFAULT '0' NOT NULL, /*原币当期发生金额*/
alz14       varchar2(24),            /*科目编号                               */
alz15       number(20,6)             /*汇兑损益                               */
);

alter table alz_file add  constraint alz_pk primary key  (alz00,alz01,alz02,alz03,alz04,alz05) enable validate;
grant select on alz_file to tiptopgp;
grant update on alz_file to tiptopgp;
grant delete on alz_file to tiptopgp;
grant insert on alz_file to tiptopgp;
grant index on alz_file to public;
grant select on alz_file to ods;
