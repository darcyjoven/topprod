/*
================================================================================
檔案代號:fig_file
檔案名稱:设备仪表资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fig_file
(
fig01       varchar2(20) NOT NULL,   /*设备编号                               */
fig02       varchar2(10) NOT NULL,   /*仪表编号                               */
fig03       varchar2(4),             /*度量单位                               */
fig04       number(15,3),            /*上限                                   */
fig05       number(15,3),            /*下限                                   */
fig06       varchar2(1),             /*No Use                                 */
fig07       varchar2(1),             /*No Use                                 */
fig08       varchar2(1),             /*No Use                                 */
fig09       varchar2(1),             /*No Use                                 */
fig10       varchar2(1),             /*No Use                                 */
figacti     varchar2(1),             /*资料有效码                             */
figuser     varchar2(10),            /*资料所有者                             */
figgrup     varchar2(10),            /*资料所有部门                           */
figmodu     varchar2(10),            /*最后更改人员                           */
figdate     date,                    /*最后更改日期                           */
figoriu     varchar2(10),            /*资料建立者                             */
figorig     varchar2(10)             /*资料建立部门                           */
);

alter table fig_file add  constraint fig_pk primary key  (fig01,fig02) enable validate;
grant select on fig_file to tiptopgp;
grant update on fig_file to tiptopgp;
grant delete on fig_file to tiptopgp;
grant insert on fig_file to tiptopgp;
grant index on fig_file to public;
grant select on fig_file to ods;
