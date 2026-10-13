/*
================================================================================
檔案代號:fip_file
檔案名稱:保修项目作业资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fip_file
(
fip01       varchar2(10) NOT NULL,   /*项目编号                               */
fip02       number(5) NOT NULL,      /*项目序                                 */
fip03       varchar2(10),            /*作业编号                               */
fip04       varchar2(1),             /*No Use                                 */
fip05       varchar2(1),             /*No Use                                 */
fip06       varchar2(1)              /*No Use                                 */
);

alter table fip_file add  constraint fip_pk primary key  (fip01,fip02) enable validate;
grant select on fip_file to tiptopgp;
grant update on fip_file to tiptopgp;
grant delete on fip_file to tiptopgp;
grant insert on fip_file to tiptopgp;
grant index on fip_file to public;
grant select on fip_file to ods;
