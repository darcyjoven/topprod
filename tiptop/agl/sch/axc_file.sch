/*
================================================================================
檔案代號:axc_file
檔案名稱:关联企业异动维护作业(单头)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axc_file
(
axc01       varchar2(10) NOT NULL,   /*集团代号                               */
axc02       varchar2(10) NOT NULL,   /*母公司编号                             */
axc03       varchar2(5) NOT NULL,    /*母公司账套                             */
axc031      varchar2(1),             /*No Use                                 */
axc04       varchar2(1),             /*No Use                                 */
axc05       varchar2(1),             /*No Use                                 */
axc06       date NOT NULL,           /*异动日期                               */
axc07       number(5),               /*No Use                                 */
axc08       varchar2(1),             /*No Use                                 */
axc09       varchar2(1),             /*No Use                                 */
axc10       varchar2(1),             /*No Use                                 */
axcconf     varchar2(1),             /*资料审核码                             */
axcuser     varchar2(10),            /*资料所有者                             */
axcgrup     varchar2(10),            /*资料所有部门                           */
axcmodu     varchar2(10),            /*资料更改者                             */
axcdate     date,                    /*最近更改日                             */
axcoriu     varchar2(10),            /*资料建立者                             */
axcorig     varchar2(10)             /*资料建立部门                           */
);

alter table axc_file add  constraint axc_pk primary key  (axc06,axc01,axc02,axc03) enable validate;
grant select on axc_file to tiptopgp;
grant update on axc_file to tiptopgp;
grant delete on axc_file to tiptopgp;
grant insert on axc_file to tiptopgp;
grant index on axc_file to public;
grant select on axc_file to ods;
