/*
================================================================================
檔案代號:vna_file
檔案名稱:aps 存貨預配記錄維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vna_file
(
vna01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vna02       varchar2(60) DEFAULT ' ' NOT NULL, /*配给对象*/
vna03       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vna04       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vna05       number(15,3),            /*分配量                                 */
vna06       number(15,3),            /*需求数量                               */
vna09       number(1),               /*锁定                                   */
vnalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vnaplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vna_file add  constraint vna_pk primary key  (vna01,vna02,vna03,vna04) enable validate;
grant select on vna_file to tiptopgp;
grant update on vna_file to tiptopgp;
grant delete on vna_file to tiptopgp;
grant insert on vna_file to tiptopgp;
grant index on vna_file to public;
grant select on vna_file to ods;
