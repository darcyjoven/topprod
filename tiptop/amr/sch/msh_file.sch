/*
================================================================================
檔案代號:msh_file
檔案名稱:不纳入MRP计算工单别资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msh_file
(
msh01       varchar2(5) NOT NULL,    /*工单单别                               */
msh02       varchar2(1),             /*No Use                                 */
msh03       varchar2(1),             /*No Use                                 */
mshacti     varchar2(1),             /*资料有效码                             */
mshuser     varchar2(10),            /*资料所有者                             */
mshgrup     varchar2(10),            /*资料所有部门                           */
mshmodu     varchar2(10),            /*资料更改者                             */
mshdate     date,                    /*最近更改日                             */
mshoriu     varchar2(10),            /*资料建立者                             */
mshorig     varchar2(10)             /*资料建立部门                           */
);

alter table msh_file add  constraint msh_pk primary key  (msh01) enable validate;
grant select on msh_file to tiptopgp;
grant update on msh_file to tiptopgp;
grant delete on msh_file to tiptopgp;
grant insert on msh_file to tiptopgp;
grant index on msh_file to public;
grant select on msh_file to ods;
