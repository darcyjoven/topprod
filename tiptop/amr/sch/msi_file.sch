/*
================================================================================
檔案代號:msi_file
檔案名稱:不纳入MRP计算订单别资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msi_file
(
msi01       varchar2(5) NOT NULL,    /*订单单别                               */
msi02       varchar2(1),             /*No Use                                 */
msi03       varchar2(1),             /*No Use                                 */
msiacti     varchar2(1),             /*资料有效码                             */
msiuser     varchar2(10),            /*资料所有者                             */
msigrup     varchar2(10),            /*资料所有部门                           */
msimodu     varchar2(10),            /*资料更改者                             */
msidate     date,                    /*最近更改日                             */
msioriu     varchar2(10),            /*资料建立者                             */
msiorig     varchar2(10)             /*资料建立部门                           */
);

alter table msi_file add  constraint msi_pk primary key  (msi01) enable validate;
grant select on msi_file to tiptopgp;
grant update on msi_file to tiptopgp;
grant delete on msi_file to tiptopgp;
grant insert on msi_file to tiptopgp;
grant index on msi_file to public;
grant select on msi_file to ods;
