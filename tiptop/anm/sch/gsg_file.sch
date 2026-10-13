/*
================================================================================
檔案代號:gsg_file
檔案名稱:投资票券费用明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gsg_file
(
gsg01       varchar2(20) NOT NULL,   /*投资单号                               */
                                     /*投資單號                               */
gsg02       number(5) NOT NULL,      /*行序                                   */
gsg03       varchar2(6),             /*费用编号                               */
                                     /*費用代號                               */
gsg04       varchar2(1),             /*No Use                                 */
gsg05       number(20,6),            /*费用金额                               */
                                     /*費用金額                               */
gsg06       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
gsg07       varchar2(1),             /*No Use                                 */
gsg08       varchar2(1),             /*No Use                                 */
gsg09       varchar2(1),             /*No Use                                 */
gsg10       varchar2(1),             /*No Use                                 */
gsglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table gsg_file add  constraint gsg_pk primary key  (gsg01,gsg02) enable validate;
grant select on gsg_file to tiptopgp;
grant update on gsg_file to tiptopgp;
grant delete on gsg_file to tiptopgp;
grant insert on gsg_file to tiptopgp;
grant index on gsg_file to public;
grant select on gsg_file to ods;
