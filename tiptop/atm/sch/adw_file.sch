/*
================================================================================
檔案代號:adw_file
檔案名稱:分销系统参数档--仓退单
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table adw_file
(
adw01       varchar2(10) NOT NULL,   /*拨入营运中心                           */
adw02       varchar2(5),             /*单别                                   */
adw03       varchar2(10),            /*部门                                   */
adw04       varchar2(10),            /*人员                                   */
adw05       varchar2(10),            /*理由码                                 */
adw06       varchar2(1),             /*No                                     */
adw07       varchar2(1),             /*No                                     */
adw08       varchar2(1),             /*No                                     */
adw09       varchar2(1),             /*No                                     */
adwacti     varchar2(1),             /*资料有效码                             */
adwuser     varchar2(10),            /*资料所有者                             */
adwgrup     varchar2(10),            /*资料所有部门                           */
adwmodu     varchar2(10),            /*资料更改者                             */
adwdate     date,                    /*最近更改日                             */
adworig     varchar2(10),            /*资料建立部门                           */
adworiu     varchar2(10)             /*资料建立者                             */
);

alter table adw_file add  constraint adw_pk primary key  (adw01) enable validate;
grant select on adw_file to tiptopgp;
grant update on adw_file to tiptopgp;
grant delete on adw_file to tiptopgp;
grant insert on adw_file to tiptopgp;
grant index on adw_file to public;
grant select on adw_file to ods;
