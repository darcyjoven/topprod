/*
================================================================================
檔案代號:boj_file
檔案名稱:正式bom底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table boj_file
(
boj01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料件编号*/
boj02       varchar2(20),            /*最后工程变异单单号                     */
boj03       date,                    /*最近工程变异日期                       */
boj04       varchar2(20),            /*组合模式参考编号                       */
boj05       date,                    /*发放日期                               */
boj06       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
boj07       varchar2(1),             /*配方否                                 */
boj08       varchar2(10) NOT NULL,   /*资料来源                               */
boj09       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
boj10       varchar2(1) DEFAULT ' ' NOT NULL, /*状态码*/
boj11       date,                    /*单据日期                               */
bojacti     varchar2(1),             /*资料有效码                             */
bojdate     date,                    /*最近更改日                             */
bojgrup     varchar2(10),            /*资料所有群                             */
bojmodu     varchar2(10),            /*资料更改者                             */
bojuser     varchar2(10),            /*资料所有者                             */
bojoriu     varchar2(10),            /*资料建立者                             */
bojorig     varchar2(10)             /*资料建立部门                           */
);

alter table boj_file add  constraint boj_pk primary key  (boj01,boj09) enable validate;
grant select on boj_file to tiptopgp;
grant update on boj_file to tiptopgp;
grant delete on boj_file to tiptopgp;
grant insert on boj_file to tiptopgp;
grant index on boj_file to public;
grant select on boj_file to ods;
