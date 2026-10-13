/*
================================================================================
檔案代號:vmc_file
檔案名稱:APS周行事历维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmc_file
(
vmc01       varchar2(60) DEFAULT ' ' NOT NULL, /*周行事历编号*/
vmc02       varchar2(60),            /*星期一的工作模式编号                   */
vmc03       varchar2(60),            /*星期二的工作模式编号                   */
vmc04       varchar2(60),            /*星期三的工作模式编号                   */
vmc05       varchar2(60),            /*星期四的工作模式编号                   */
vmc06       varchar2(60),            /*星期五的工作模式编号                   */
vmc07       varchar2(60),            /*星期六的工作模式编号                   */
vmc08       varchar2(60)             /*星期日的工作模式编号                   */
);

alter table vmc_file add  constraint vmc_pk primary key  (vmc01) enable validate;
grant select on vmc_file to tiptopgp;
grant update on vmc_file to tiptopgp;
grant delete on vmc_file to tiptopgp;
grant insert on vmc_file to tiptopgp;
grant index on vmc_file to public;
grant select on vmc_file to ods;
