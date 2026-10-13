/*
================================================================================
檔案代號:axd_file
檔案名稱:关联企业异动维护作业(单身)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axd_file
(
axd00       date NOT NULL,           /*异动日期                               */
axd01       varchar2(10) NOT NULL,   /*集团代号                               */
axd02       varchar2(10) NOT NULL,   /*母公司编号                             */
axd03       varchar2(5) NOT NULL,    /*帐套                                   */
axd04       number(5) NOT NULL,      /*项次                                   */
axd04b      varchar2(10),            /*异动前子公司编号                       */
axd05b      varchar2(5),             /*异动前子公司账套                       */
axd051b     varchar2(1),             /*No Use                                 */
axd06b      varchar2(1),             /*no use                                 */
axd07b      number(9,4),             /*异动前持股比率                         */
axd08b      date,                    /*异动前异动日期                         */
axd09b      varchar2(1),             /*No Use                                 */
axd04a      varchar2(10),            /*异动后子公司编号                       */
axd05a      varchar2(5),             /*异动后子公司账套                       */
axd051a     varchar2(1),             /*No Use                                 */
axd06a      varchar2(1),             /*no use                                 */
axd07a      number(9,4),             /*异动后持股比率                         */
axd08a      date,                    /*异动后异动日期                         */
axd09a      varchar2(1),             /*No Use                                 */
axd10       varchar2(1),             /*No Use                                 */
axd11b      number(10),              /*异动前投资股数                         */
axd12b      number(20,6),            /*异动前股本                             */
axd11a      number(10),              /*异动后投资股数                         */
axd12a      number(20,6),            /*异动后股本                             */
axd13b      varchar2(1),             /*股本否                                 */
axd14b      varchar2(24)             /*会计科目                               */
);

alter table axd_file add  constraint axd_pk primary key  (axd00,axd01,axd02,axd03,axd04) enable validate;
grant select on axd_file to tiptopgp;
grant update on axd_file to tiptopgp;
grant delete on axd_file to tiptopgp;
grant insert on axd_file to tiptopgp;
grant index on axd_file to public;
grant select on axd_file to ods;
