/*
================================================================================
檔案代號:axb_file
檔案名稱:关联企业层级维护作业(单身)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axb_file
(
axb01       varchar2(10) NOT NULL,   /*集团代号                               */
axb02       varchar2(10) NOT NULL,   /*母公司编号                             */
axb03       varchar2(5) NOT NULL,    /*母公司账套                             */
axb04       varchar2(10) NOT NULL,   /*子公司编号                             */
axb05       varchar2(5) NOT NULL,    /*子公司账套                             */
axb06       varchar2(1),             /*no use                                 */
axb07       number(9,4),             /*NO USE                                 */
axb08       date,                    /*NO USE                                 */
axb09       varchar2(1),             /*No Use                                 */
axb10       varchar2(1),             /*No Use                                 */
axb11       number(10),              /*NO USE                                 */
axb12       number(20,6),            /*NO USE                                 */
axb13       varchar2(24),            /*NO USE                                 */
axb14       number(5),               /*现行年度                               */
axb15       number(5)                /*现行期别                               */
);

alter table axb_file add  constraint axb_pk primary key  (axb01,axb02,axb03,axb04,axb05) enable validate;
grant select on axb_file to tiptopgp;
grant update on axb_file to tiptopgp;
grant delete on axb_file to tiptopgp;
grant insert on axb_file to tiptopgp;
grant index on axb_file to public;
grant select on axb_file to ods;
