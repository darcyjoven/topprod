/*
================================================================================
檔案代號:wse_file
檔案名稱:easyflow 集成设置档(单头档设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wse_file
(
wse01       varchar2(20) NOT NULL,   /*程序编号                               */
wse02       varchar2(15) NOT NULL,   /*程序使用单头档                         */
wse03       varchar2(20) NOT NULL,   /*单头档 key 值字段 #1                   */
wse04       varchar2(20),            /*单头档 key 值字段 #2                   */
wse05       varchar2(20),            /*单头档 key 值字段 #3                   */
wse06       varchar2(20),            /*单头档 key 值字段 #4                   */
wse07       varchar2(20),            /*单头档 key 值字段 #5                   */
wse08       varchar2(20),            /*单头档签核码字段                       */
wse09       varchar2(20),            /*单头档审核码字段                       */
wse10       varchar2(20),            /*单头档状态码字段                       */
wse11       varchar2(20),            /*单头档资料有效码字段                   */
wse12       varchar2(20),            /*填表人字段                             */
wse13       varchar2(20),            /*表单关系人字段                         */
wse14       varchar2(1),             /*自动运行审核                           */
wse15       varchar2(10),            /*No Use                                 */
wse16       varchar2(10),            /*No Use                                 */
wse17       varchar2(10),            /*No Use                                 */
wse18       varchar2(10),            /*No Use                                 */
wse19       varchar2(10),            /*No Use                                 */
wse20       varchar2(10)             /*No Use                                 */
);

alter table wse_file add  constraint wse_pk primary key  (wse01) enable validate;
grant select on wse_file to tiptopgp;
grant update on wse_file to tiptopgp;
grant delete on wse_file to tiptopgp;
grant insert on wse_file to tiptopgp;
grant index on wse_file to public;
grant select on wse_file to ods;
