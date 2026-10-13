/*
================================================================================
檔案代號:nag_file
檔案名稱:银行对账单单身档-企业账
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nag_file
(
nag01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
nag02       varchar2(20) DEFAULT ' ' NOT NULL, /*对账流水号*/
nag03       varchar2(20) DEFAULT ' ' NOT NULL, /*企业账流水号*/
nag04       varchar2(1),             /*对账方式                               */
                                     /*1.自动对账 2.手工对账                  */
nag05       varchar2(20),            /*银存异动单号                           */
nag06       number(5),               /*银存异动项次                           */
naglegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table nag_file add  constraint nag_pk primary key  (nag01,nag02,nag03) enable validate;
grant select on nag_file to tiptopgp;
grant update on nag_file to tiptopgp;
grant delete on nag_file to tiptopgp;
grant insert on nag_file to tiptopgp;
grant index on nag_file to public;
grant select on nag_file to ods;
