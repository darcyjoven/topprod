/*
================================================================================
檔案代號:icl_file
檔案名稱:ICD料件正背印资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icl_file
(
icl01       varchar2(40) NOT NULL,   /*料件编号                               */
icl02       varchar2(10) NOT NULL,   /*类型                                   */
icl03       varchar2(5) NOT NULL,    /*No.                                    */
icl04       varchar2(1),             /*Date Code否                            */
icl05       varchar2(255),           /*Remark                                 */
icl06       varchar2(1),             /*no use                                 */
iclacti     varchar2(1),             /*资料有效码                             */
icldate     date,                    /*最近更改日                             */
iclgrup     varchar2(10),            /*资料所有群                             */
iclmodu     varchar2(10),            /*资料更改者                             */
icluser     varchar2(10),            /*资料所有者                             */
iclorig     varchar2(10),            /*资料建立部门                           */
icloriu     varchar2(10)             /*资料建立者                             */
);

alter table icl_file add  constraint icl_pk primary key  (icl01,icl02,icl03) enable validate;
grant select on icl_file to tiptopgp;
grant update on icl_file to tiptopgp;
grant delete on icl_file to tiptopgp;
grant insert on icl_file to tiptopgp;
grant index on icl_file to public;
grant select on icl_file to ods;
