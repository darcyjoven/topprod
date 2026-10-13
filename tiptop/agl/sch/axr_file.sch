/*
================================================================================
檔案代號:axr_file
檔案名稱:合并报表历史汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axr_file
(
axr01       varchar2(10) NOT NULL,   /*集团代号                               */
axr02       varchar2(10) NOT NULL,   /*公司编号                               */
axr03       varchar2(24) NOT NULL,   /*科目编号                               */
axr04       varchar2(4),             /*记帐币种                               */
axr05       number(20,6),            /*记帐币种金额                           */
axr06       date NOT NULL,           /*异动日期                               */
axr07       varchar2(24) NOT NULL,   /*来源科目                               */
axr08       number(5),               /*历史年度                               */
axr09       number(5),               /*历史期别                               */
axr10       number(5),               /*异动年度                               */
axr11       number(5),               /*异动期别                               */
axr12       number(20,10),           /*历史汇率                               */
axr13       number(20,6),
axr14       varchar2(4),             /*功能币种                               */
axr15       number(20,10),           /*再衡量匯率                             */
axr16       number(20,6),            /*功能幣別金額                           */
axr17       varchar2(10)
);

alter table axr_file add  constraint axr_pk primary key  (axr01,axr02,axr03,axr06,axr07) enable validate;
grant select on axr_file to tiptopgp;
grant update on axr_file to tiptopgp;
grant delete on axr_file to tiptopgp;
grant insert on axr_file to tiptopgp;
grant index on axr_file to public;
grant select on axr_file to ods;
