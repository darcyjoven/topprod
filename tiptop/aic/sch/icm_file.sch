/*
================================================================================
檔案代號:icm_file
檔案名稱:ICD料件下阶制程料号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icm_file
(
icm01       varchar2(40) NOT NULL,   /*料件编号                               */
icm02       varchar2(40) NOT NULL,   /*下阶料                                 */
icm03       varchar2(255),           /*Remark                                 */
icm04       varchar2(40),            /*来源单号                               */
icm12       varchar2(1),             /*no use                                 */
icm13       varchar2(1),             /*no use                                 */
icm14       varchar2(1),             /*no use                                 */
icm15       varchar2(1),             /*no use                                 */
icm16       varchar2(1),             /*no use                                 */
icmacti     varchar2(1),             /*资料有效码                             */
icmdate     date,                    /*最近更改日                             */
icmgrup     varchar2(10),            /*资料所有群                             */
icmmodu     varchar2(10),            /*资料更改者                             */
icmuser     varchar2(10),            /*资料所有者                             */
icmorig     varchar2(10),            /*资料建立部门                           */
icmoriu     varchar2(10)             /*资料建立者                             */
);

alter table icm_file add  constraint icm_pk primary key  (icm01,icm02) enable validate;
grant select on icm_file to tiptopgp;
grant update on icm_file to tiptopgp;
grant delete on icm_file to tiptopgp;
grant insert on icm_file to tiptopgp;
grant index on icm_file to public;
grant select on icm_file to ods;
