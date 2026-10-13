/*
================================================================================
檔案代號:gbi_file
檔案名稱:我的最爱程序资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbi_file
(
gbi01       varchar2(10) NOT NULL,   /*用户编号                               */
gbi02       varchar2(20) NOT NULL,   /*程序编号                               */
gbi03       varchar2(1),             /*No Use                                 */
gbi04       varchar2(1),             /*No Use                                 */
gbi05       varchar2(1)              /*No Use                                 */
);

alter table gbi_file add  constraint gbi_pk primary key  (gbi01,gbi02) enable validate;
grant select on gbi_file to tiptopgp;
grant update on gbi_file to tiptopgp;
grant delete on gbi_file to tiptopgp;
grant insert on gbi_file to tiptopgp;
grant index on gbi_file to public;
grant select on gbi_file to ods;
