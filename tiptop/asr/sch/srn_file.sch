/*
================================================================================
檔案代號:srn_file
檔案名稱:期末用料盘点资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table srn_file
(
srn01       date NOT NULL,           /*盘点日期                               */
srn02       varchar2(40) NOT NULL,   /*料号                                   */
srn03       varchar2(10) NOT NULL,   /*仓库                                   */
srn04       varchar2(10) NOT NULL,   /*库位                                   */
srn05       varchar2(24) NOT NULL,   /*批号                                   */
srn06       varchar2(4),             /*单位                                   */
srn07       number(15,3),            /*期末数量                               */
srn08       number(15,3),            /*盘点数量                               */
srn09       number(5),               /*年度                                   */
srn10       number(5),               /*月份                                   */
srn11       number(15,3),            /*No Use                                 */
srn12       number(15,3),            /*No Use                                 */
srn13       number(15,3),            /*No Use                                 */
srn14       number(15,3),            /*No Use                                 */
srn15       number(15,3),            /*No Use                                 */
srn16       number(15,3),            /*No Use                                 */
srn17       number(15,3),            /*No Use                                 */
srn18       number(15,3),            /*No Use                                 */
srn19       number(15,3),            /*No Use                                 */
srn20       number(15,3)             /*No Use                                 */
);

alter table srn_file add  constraint srn_pk primary key  (srn01,srn02,srn03,srn04,srn05) enable validate;
grant select on srn_file to tiptopgp;
grant update on srn_file to tiptopgp;
grant delete on srn_file to tiptopgp;
grant insert on srn_file to tiptopgp;
grant index on srn_file to public;
grant select on srn_file to ods;
