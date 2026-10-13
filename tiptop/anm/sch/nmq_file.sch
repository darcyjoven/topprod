/*
================================================================================
檔案代號:nmq_file
檔案名稱:融资缺省会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmq_file
(
nmq00       varchar2(1) NOT NULL,    /*KEY, VALUE(0), 隐藏字段                */
nmq01       varchar2(24),            /*利息费用科目(借方)                     */
nmq02       varchar2(24),            /*其他费用科目(借方)                     */
nmq10       varchar2(24),            /*应付利息科目(贷方)                     */
nmq11       varchar2(24),            /*预付费用科目(贷方)                     */
nmq21       varchar2(24),            /*集团资金调拨(拨出)科目                 */
nmq22       varchar2(24),            /*集团资金调拨(拨入)科目                 */
nmq23       varchar2(24),            /*集团资金调拨利息(拨出)科目             */
nmq24       varchar2(24),            /*集团资金调拨利息(拨入)科目             */
nmq011      varchar2(24),            /*利息费用科目二(借方)                   */
nmq021      varchar2(24),            /*其他费用科目二(借方)                   */
nmq101      varchar2(24),            /*应付利息科目二(贷方)                   */
nmq111      varchar2(24),            /*预付费用科目二(贷方)                   */
nmq211      varchar2(24),            /*集团资金调拨(拨出)科目二               */
nmq221      varchar2(24),            /*集团资金调拨(拨入)科目二               */
nmq231      varchar2(24),            /*集团资金调拨利息(拨出)科目             */
nmq241      varchar2(24)             /*集团资金调拨利息(拨入)科目             */
);

alter table nmq_file add  constraint nmq_pk primary key  (nmq00) enable validate;
grant select on nmq_file to tiptopgp;
grant update on nmq_file to tiptopgp;
grant delete on nmq_file to tiptopgp;
grant insert on nmq_file to tiptopgp;
grant index on nmq_file to public;
grant select on nmq_file to ods;
