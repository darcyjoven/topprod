/*
================================================================================
檔案代號:fcx_file
檔案名稱:利息资本化资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcx_file
(
fcx01       varchar2(10) NOT NULL,   /*财产编号                               */
fcx011      varchar2(4) NOT NULL,    /*附号                                   */
fcx02       number(5) NOT NULL,      /*资料年度                               */
fcx03       number(5) NOT NULL,      /*资料月份                               */
fcx04       number(20,6),            /*月初累计金额                           */
fcx05       number(20,6),            /*当月支出                               */
fcx06       number(20,6),            /*利息资本化金额                         */
fcx07       number(20,6),            /*按成本之利息                           */
fcx08       number(20,6),            /*实际利息                               */
fcx09       varchar2(24),            /*预付设备科目                           */
fcx10       varchar2(24),            /*利息支出科目                           */
fcx11       varchar2(20),            /*资本化凭证编号                         */
fcx12       date,                    /*资本化凭证日期                         */
fcx13       date,                    /*转固定资产日期                         */
fcxacti     varchar2(1),             /*资料有效码                             */
fcxuser     varchar2(10),            /*资料所有者                             */
fcxgrup     varchar2(10),            /*资料所有群                             */
fcxmodu     varchar2(10),            /*资料更改者                             */
fcxdate     date,                    /*最近更改日                             */
fcx091      varchar2(24),            /*预付设备科目二                         */
fcx101      varchar2(24),            /*利息支出科目二                         */
fcxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fcxoriu     varchar2(10),            /*资料建立者                             */
fcxorig     varchar2(10),            /*资料建立部门                           */
fcx112      varchar2(20),            /*传票编号(财签二)                       */
fcx122      date                     /*传票日期(财签二)                       */
);

create        index fcx_02 on fcx_file (fcx11);
alter table fcx_file add  constraint fcx_pk primary key  (fcx01,fcx011,fcx02,fcx03) enable validate;
grant select on fcx_file to tiptopgp;
grant update on fcx_file to tiptopgp;
grant delete on fcx_file to tiptopgp;
grant insert on fcx_file to tiptopgp;
grant index on fcx_file to public;
grant select on fcx_file to ods;
