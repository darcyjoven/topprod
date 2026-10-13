/*
================================================================================
檔案代號:pjs_file
檔案名稱:项目费用明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjs_file
(
pjs01       number(5) NOT NULL,      /*年度                                   */
pjs02       number(5) NOT NULL,      /*期别                                   */
pjs03       varchar2(10) NOT NULL,   /*项目编号                               */
pjs04       varchar2(30) NOT NULL,   /*wbs编号                                */
pjs05       varchar2(10) NOT NULL,   /*费用编号                               */
pjs10       number(20,6),            /*本期发生金额                           */
pjs11       number(20,6),            /*本期预提金额                           */
pjs12       number(20,6),            /*本期结转金额                           */
pjsdate     date,                    /*最近计算日期                           */
pjstime     varchar2(5),             /*最近计算时间                           */
pjsuser     varchar2(10),            /*最近计算人员                           */
pjsorig     varchar2(10),            /*资料建立部门                           */
pjsoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjs_file add  constraint pjs_pk primary key  (pjs01,pjs02,pjs03,pjs04,pjs05) enable validate;
grant select on pjs_file to tiptopgp;
grant update on pjs_file to tiptopgp;
grant delete on pjs_file to tiptopgp;
grant insert on pjs_file to tiptopgp;
grant index on pjs_file to public;
grant select on pjs_file to ods;
