/*
================================================================================
檔案代號:stx_file
檔案名稱:标准成本月档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table stx_file
(
stx01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
stx02       number(5) DEFAULT '0' NOT NULL, /*年度*/
stx03       number(5) DEFAULT '0' NOT NULL, /*月份*/
stx04       varchar2(10) DEFAULT ' ',/*no use                                 */
stx05       number(20,6),            /*本阶材料                               */
stx06       number(20,6),            /*本阶人工                               */
stx07       number(20,6),            /*本阶制费                               */
stx08       number(20,6),            /*本阶加工                               */
stx09       number(20,6),            /*下阶材料                               */
stx10       number(20,6),            /*下阶人工                               */
stx11       number(20,6),            /*下阶制费                               */
stx12       number(20,6),            /*下阶加工                               */
stx13       number(20,6)             /*合计                                   */
);

alter table stx_file add  constraint stx_pk primary key  (stx01,stx02,stx03) enable validate;
grant select on stx_file to tiptopgp;
grant update on stx_file to tiptopgp;
grant delete on stx_file to tiptopgp;
grant insert on stx_file to tiptopgp;
grant index on stx_file to public;
grant select on stx_file to ods;
