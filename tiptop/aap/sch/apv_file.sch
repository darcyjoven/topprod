/*
================================================================================
檔案代號:apv_file
檔案名稱:请款时直接冲账记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apv_file
(
apv01       varchar2(20) NOT NULL,   /*帐款单号                               */
                                     /*帳款單號                               */
apv02       number(5) NOT NULL,      /*项次                                   */
apv03       varchar2(20),            /*待抵帐款编号                           */
                                     /*待抵帳款編號                           */
apv04f      number(20,6) NOT NULL,   /*原币冲款金额                           */
                                     /*原幣沖款金額                           */
apv04       number(20,6) NOT NULL,   /*本币冲款金额                           */
                                     /*本幣沖款金額                           */
apv05       number(5),               /*子帐期项次                             */
apvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index apv_02 on apv_file (apv03);
alter table apv_file add  constraint apv_pk primary key  (apv01,apv02) enable validate;
grant select on apv_file to tiptopgp;
grant update on apv_file to tiptopgp;
grant delete on apv_file to tiptopgp;
grant insert on apv_file to tiptopgp;
grant index on apv_file to public;
grant select on apv_file to ods;
