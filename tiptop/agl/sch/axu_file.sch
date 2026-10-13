/*
================================================================================
檔案代號:axu_file
檔案名稱:对冲科目misc明细科目公式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axu_file
(
axu00       varchar2(5) NOT NULL,    /*母公司账套                             */
axu01       varchar2(24) NOT NULL,   /*母(子)公司科目编号                     */
axu03       varchar2(24) NOT NULL,   /*对冲：子公司科目misc明细科目           */
axu04       varchar2(24) NOT NULL,   /*对冲：子公司科目加减项科目             */
axu05       varchar2(1),             /*加减项  +.加项  -.减项                 */
axu09       varchar2(10) NOT NULL,   /*来源：母(子)公司编号                   */
axu10       varchar2(10) NOT NULL,   /*对冲：子公司编号                       */
axu12       varchar2(5) NOT NULL,    /*子公司账套                             */
axu13       varchar2(10) DEFAULT ' ' NOT NULL /*集团代号*/
);

alter table axu_file add  constraint axu_pk primary key  (axu00,axu01,axu03,axu04,axu09,axu10,axu12,axu13) enable validate;
grant select on axu_file to tiptopgp;
grant update on axu_file to tiptopgp;
grant delete on axu_file to tiptopgp;
grant insert on axu_file to tiptopgp;
grant index on axu_file to public;
grant select on axu_file to ods;
