/*
================================================================================
檔案代號:sro_file
檔案名稱:期末用料盘点差异调整资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sro_file
(
sro01       date NOT NULL,           /*盘点日期                               */
sro02       varchar2(40) NOT NULL,   /*料号                                   */
sro03       varchar2(10) NOT NULL,   /*仓库                                   */
sro04       varchar2(10) NOT NULL,   /*库位                                   */
sro05       varchar2(24) NOT NULL,   /*批号                                   */
sro06       varchar2(4),             /*单位                                   */
sro07       number(15,3),            /*期末数量                               */
sro08       number(15,3),            /*盘点数量                               */
sro09       number(5),               /*年度                                   */
sro10       number(5),               /*月份                                   */
sro11       varchar2(1),             /*确认码                                 */
sro12       number(15,3),            /*差异数量                               */
sro13       varchar2(20),            /*领料,退料单号                          */
sro14       number(5),               /*No Use                                 */
sro15       number(15,3),            /*No Use                                 */
sro16       number(15,3),            /*No Use                                 */
sro17       number(15,3),            /*No Use                                 */
sro18       number(15,3),            /*No Use                                 */
sro19       number(15,3),            /*No Use                                 */
sro20       number(15,3)             /*No Use                                 */
);

alter table sro_file add  constraint sro_pk primary key  (sro01,sro02,sro03,sro04,sro05) enable validate;
grant select on sro_file to tiptopgp;
grant update on sro_file to tiptopgp;
grant delete on sro_file to tiptopgp;
grant insert on sro_file to tiptopgp;
grant index on sro_file to public;
grant select on sro_file to ods;
