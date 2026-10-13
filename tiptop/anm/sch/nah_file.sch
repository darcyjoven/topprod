/*
================================================================================
檔案代號:nah_file
檔案名稱:银行对账单单身档-银行账
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nah_file
(
nah01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行对账单号*/
nah02       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单流水号*/
nah03       varchar2(20) DEFAULT ' ' NOT NULL, /*银行账流水号*/
nah04       varchar2(1),             /*对账方式                               */
                                     /*1.自动对账 2.手工对账                  */
nahlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table nah_file add  constraint nah_pk primary key  (nah01,nah02,nah03) enable validate;
grant select on nah_file to tiptopgp;
grant update on nah_file to tiptopgp;
grant delete on nah_file to tiptopgp;
grant insert on nah_file to tiptopgp;
grant index on nah_file to public;
grant select on nah_file to ods;
