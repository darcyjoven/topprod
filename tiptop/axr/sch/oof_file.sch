/*
================================================================================
檔案代號:oof_file
檔案名稱:付款单调账单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oof_file
(
oof01       varchar2(20) DEFAULT ' ' NOT NULL, /*冲帐单号*/
oof02       number(5) DEFAULT '0' NOT NULL, /*冲帐日期*/
oof03       varchar2(10),            /*帐款客户编号                           */
oof032      varchar2(40),            /*帐款客户简称                           */
oof04       varchar2(10),            /*收款客户                               */
oof042      varchar2(40),            /*客户简称                               */
oof05       varchar2(20),            /*帐款单别                               */
oof06       date,                    /*帐款日期                               */
oof07       varchar2(4),
oof08       number(20,10),           /*汇率                                   */
oof09       number(20,6) DEFAULT '0',/*本币金额                               */
oof09f      number(20,6) DEFAULT '0',/*原币金额                               */
oof10       varchar2(24),            /*科目                                   */
oof101      varchar2(24),            /*科目二                                 */
ooflegal    varchar2(10),            /*所属法人                               */
ooforig     varchar2(10),            /*资料建立部门                           */
ooforiu     varchar2(10)             /*资料建立者                             */
);

alter table oof_file add  constraint oof_pk primary key  (oof01,oof02) enable validate;
grant select on oof_file to tiptopgp;
grant update on oof_file to tiptopgp;
grant delete on oof_file to tiptopgp;
grant insert on oof_file to tiptopgp;
grant index on oof_file to public;
grant select on oof_file to ods;
