/*
================================================================================
檔案代號:wsg_file
檔案名稱:easyflow 集成设置档(单据性质档设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsg_file
(
wsg01       varchar2(20) NOT NULL,   /*程序编号                               */
wsg02       varchar2(15),            /*使用单据性质档                         */
wsg03       varchar2(20),            /*单据档单别字段                         */
wsg04       varchar2(20),            /*单据档单据名称字段                     */
wsg05       varchar2(20),            /*单据档系统字段                         */
wsg06       varchar2(5),             /*程序所属单据系统                       */
wsg07       varchar2(20),            /*单据档单据性质字段                     */
wsg08       varchar2(255),           /*程序所属单据性质编号                   */
wsg09       varchar2(20),            /*单据档签核处理字段                     */
wsg10       varchar2(10),            /*No Use                                 */
wsg11       varchar2(10),            /*No Use                                 */
wsg12       varchar2(10),            /*No Use                                 */
wsg13       varchar2(10),            /*No Use                                 */
wsg14       varchar2(10),            /*No Use                                 */
wsg15       varchar2(10)             /*No Use                                 */
);

alter table wsg_file add  constraint wsg_pk primary key  (wsg01) enable validate;
grant select on wsg_file to tiptopgp;
grant update on wsg_file to tiptopgp;
grant delete on wsg_file to tiptopgp;
grant insert on wsg_file to tiptopgp;
grant index on wsg_file to public;
grant select on wsg_file to ods;
