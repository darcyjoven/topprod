/*
================================================================================
檔案代號:vln_file
檔案名稱:aps硬體模式維護
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vln_file
(
vln01       varchar2(20) DEFAULT ' ' NOT NULL, /*APS硬件模式代号*/
vln02       varchar2(20),            /*APS 资料库主机                         */
vln03       varchar2(20)             /*APS 服务器主机                         */
);

alter table vln_file add  constraint vln_pk primary key  (vln01) enable validate;
grant select on vln_file to tiptopgp;
grant update on vln_file to tiptopgp;
grant delete on vln_file to tiptopgp;
grant insert on vln_file to tiptopgp;
grant index on vln_file to public;
grant select on vln_file to ods;
