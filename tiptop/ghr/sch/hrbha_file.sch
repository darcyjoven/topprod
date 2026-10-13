/*
================================================================================
檔案代號:hrbha_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbha_file
(
hrbha01     number(5) NOT NULL,      /*项次                                   */
hrbha02     varchar2(50) NOT NULL,   /*员工ID                                 */
hrbha03     varchar2(50),            /*项目编号                               */
hrbha04     varchar2(255),           /*项目信息                               */
hrbha05     date,                    /*交接日期                               */
hrbha06     varchar2(50),            /*工作交接人                             */
hrbha07     varchar2(255)            /*备注                                   */
);

alter table hrbha_file add  constraint tpc_hrbha_pk primary key  (hrbha01) enable validate;
grant select on hrbha_file to tiptopgp;
grant update on hrbha_file to tiptopgp;
grant delete on hrbha_file to tiptopgp;
grant insert on hrbha_file to tiptopgp;
grant index on hrbha_file to public;
grant select on hrbha_file to ods;
