/*
================================================================================
檔案代號:lie_file
檔案名稱:摊位场地单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lie_file
(
lie01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lie02       varchar2(20) DEFAULT ' ' NOT NULL, /*场地编号*/
lie03       varchar2(10),            /*楼层编号                               */
lie04       varchar2(10),            /*区域编号                               */
lie05       number(20,6),            /*建筑面积                               */
lie06       number(20,6),            /*測量面積                               */
lie07       number(20,6),            /*经营面积                               */
lieacti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
lielegal    varchar2(10),            /*所属法人                               */
liestore    varchar2(10)             /*门店编号                               */
);

alter table lie_file add  constraint lie_pk primary key  (lie01,lie02) enable validate;
grant select on lie_file to tiptopgp;
grant update on lie_file to tiptopgp;
grant delete on lie_file to tiptopgp;
grant insert on lie_file to tiptopgp;
grant index on lie_file to public;
grant select on lie_file to ods;
