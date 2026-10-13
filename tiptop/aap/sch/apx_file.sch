/*
================================================================================
檔案代號:apx_file
檔案名稱:还款记录明细档
檔案目的: 储存还款记录档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apx_file
(
apx01       varchar2(20) NOT NULL,   /*帐款编号                               */
apx02       number(5) NOT NULL,      /*项次                                   */
apx03       varchar2(20),            /*借款待抵单号                           */
apx04f      number(20,6) NOT NULL,   /*原币还款金额                           */
apx04       number(20,6) NOT NULL,   /*本币还款金额                           */
apxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index apx_02 on apx_file (apx03);
alter table apx_file add  constraint apx_pk primary key  (apx01,apx02) enable validate;
grant select on apx_file to tiptopgp;
grant update on apx_file to tiptopgp;
grant delete on apx_file to tiptopgp;
grant insert on apx_file to tiptopgp;
grant index on apx_file to public;
grant select on apx_file to ods;
