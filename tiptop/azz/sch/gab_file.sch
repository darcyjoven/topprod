/*
================================================================================
檔案代號:gab_file
檔案名稱:动态查询设置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gab_file
(
gab01       varchar2(20) NOT NULL,   /*查询程序代码                           */
gab02       varchar2(500),           /*INPUT状态的WHERE条件                   */
gab03       varchar2(80),            /*需要JOIN的TABLE                        */
gab04       varchar2(1),             /*DISTINCT设置                           */
gab05       varchar2(500),           /*CONSTRUCT状态的WHERE条件               */
gab06       varchar2(255),           /*其他注记                               */
gab07       varchar2(1),             /*Hard-Code程序注记                      */
gab08       varchar2(1),             /*是否允许单身更改                       */
gab09       varchar2(10),            /*变更允许状态人员                       */
gab10       varchar2(1),             /*是否忽略单身营运中心设置值             */
gab11       varchar2(1) NOT NULL,    /*客制码                                 */
gab12       varchar2(1),             /*No Use                                 */
gab13       varchar2(1),             /*No Use                                 */
gab14       varchar2(1),             /*No Use                                 */
gab15       varchar2(1)              /*No Use                                 */
);

alter table gab_file add  constraint gab_pk primary key  (gab01,gab11) enable validate;
grant select on gab_file to tiptopgp;
grant update on gab_file to tiptopgp;
grant delete on gab_file to tiptopgp;
grant insert on gab_file to tiptopgp;
grant index on gab_file to public;
grant select on gab_file to ods;
