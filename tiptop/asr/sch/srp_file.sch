/*
================================================================================
檔案代號:srp_file
檔案名稱:期末用料盘点差异调整分摊资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table srp_file
(
srp01       date NOT NULL,           /*盘点日期                               */
srp02       varchar2(40) NOT NULL,   /*料号                                   */
srp03       varchar2(10) NOT NULL,   /*仓库                                   */
srp04       varchar2(10) NOT NULL,   /*库位                                   */
srp05       varchar2(24) NOT NULL,   /*批号                                   */
srp06       varchar2(4),             /*单位                                   */
srp07       number(15,3),            /*期末数量                               */
srp08       number(15,3),            /*盘点数量                               */
srp09       number(5),               /*年度                                   */
srp10       number(5),               /*月份                                   */
srp11       varchar2(1),             /*No Use                                 */
srp12       number(15,3),            /*No Use                                 */
srp13       varchar2(20) NOT NULL,   /*领料,退料单号                          */
srp14       number(5) NOT NULL,      /*领料,退料项次                          */
srp15       varchar2(40) DEFAULT ' ',/*生产料号                               */
srp16       number(15,3),            /*分摊数量                               */
srp17       number(15,3),            /*No Use                                 */
srp18       number(15,3),            /*No Use                                 */
srp19       number(15,3),            /*No Use                                 */
srp20       number(15,3)             /*No Use                                 */
);

alter table srp_file add  constraint srp_pk primary key  (srp01,srp02,srp03,srp04,srp05,srp13,srp14) enable validate;
grant select on srp_file to tiptopgp;
grant update on srp_file to tiptopgp;
grant delete on srp_file to tiptopgp;
grant insert on srp_file to tiptopgp;
grant index on srp_file to public;
grant select on srp_file to ods;
