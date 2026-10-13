/*
================================================================================
檔案代號:fdd_file
檔案名稱:每月保费档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fdd_file
(
fdd01       varchar2(20) NOT NULL,   /*保单编号                               */
fdd02       varchar2(10) NOT NULL,   /*财产编号                               */
fdd022      varchar2(4) NOT NULL,    /*附号                                   */
fdd03       number(5) NOT NULL,      /*年度                                   */
fdd033      number(5) NOT NULL,      /*月份                                   */
fdd04       varchar2(10),            /*部门(成本中心)                         */
fdd05       number(20,6),            /*保费                                   */
fdd06       varchar2(20),            /*凭证编号                               */
fdd07       date,                    /*凭证日期                               */
fdd08       varchar2(24),            /*保险费用科目                           */
fdd09       varchar2(24),            /*预付保费科目                           */
fdd10       varchar2(1),             /*No Use                                 */
fdduser     varchar2(10),            /*资料所有者                             */
fddgrup     varchar2(10),            /*资料所有群                             */
fddmodu     varchar2(10),            /*资料更改者                             */
fdddate     date,                    /*资料更改者                             */
fdd081      varchar2(24),            /*保险费用科目二                         */
fdd091      varchar2(24),            /*预付保费科目二                         */
fddlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fddoriu     varchar2(10),            /*资料建立者                             */
fddorig     varchar2(10),            /*资料建立部门                           */
fdd062      varchar2(20),            /*传票编号(财签二)                       */
fdd072      date                     /*传票日期(财签二)                       */
);

create        index fdd_02 on fdd_file (fdd06);
alter table fdd_file add  constraint fdd_pk primary key  (fdd01,fdd02,fdd022,fdd03,fdd033) enable validate;
grant select on fdd_file to tiptopgp;
grant update on fdd_file to tiptopgp;
grant delete on fdd_file to tiptopgp;
grant insert on fdd_file to tiptopgp;
grant index on fdd_file to public;
grant select on fdd_file to ods;
