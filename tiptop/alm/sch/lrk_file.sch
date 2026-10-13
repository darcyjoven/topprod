/*
================================================================================
檔案代號:lrk_file
檔案名稱:单别设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lrk_file
(
lrkapr      varchar2(1),             /*签核否                                 */
lrkauno     varchar2(1),             /*自动编号否                             */
lrkdesc     varchar2(60),            /*单据名称                               */
lrkdmy1     varchar2(1),             /*No Use                                 */
lrkdmy2     varchar2(1),             /*立刻审核                               */
lrkdmy3     varchar2(5),             /*费用单单号                             */
lrkkind     varchar2(2),             /*单据性质                               */
lrkprit     varchar2(1),             /*立刻打印                               */
lrkrem      varchar2(80),            /*备注                                   */
lrkslip     varchar2(5) DEFAULT ' ' NOT NULL, /*单别*/
lrktsg      varchar2(1),             /*自动签核                               */
lrkacti     varchar2(1) DEFAULT 'Y' NOT NULL /*有效码*/
);

alter table lrk_file add  constraint lrk_pk primary key  (lrkslip) enable validate;
grant select on lrk_file to tiptopgp;
grant update on lrk_file to tiptopgp;
grant delete on lrk_file to tiptopgp;
grant insert on lrk_file to tiptopgp;
grant index on lrk_file to public;
grant select on lrk_file to ods;
