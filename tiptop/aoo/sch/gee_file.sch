/*
================================================================================
檔案代號:gee_file
檔案名稱:单据性质设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gee_file
(
gee01       varchar2(10) DEFAULT ' ' NOT NULL, /*模组代码*/
gee02       varchar2(2) DEFAULT ' ' NOT NULL, /*单据性质编号*/
gee03       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
gee04       varchar2(20) DEFAULT ' ' NOT NULL, /*单据别设定程序编号*/
gee05       varchar2(80),            /*单据性质说明                           */
gee06       varchar2(15),            /*单据编号参考档案                       */
gee07       varchar2(20),            /*单据编号参考字段                       */
gee08       varchar2(20),            /*账别字段                               */
geeacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
geedate     date,                    /*最近更改日                             */
geegrup     varchar2(10),            /*资料所有部门                           */
geemodu     varchar2(10),            /*资料更改者                             */
geeorig     varchar2(10),            /*资料建立部门                           */
geeoriu     varchar2(10),            /*资料建立者                             */
geeuser     varchar2(10)             /*资料所有者                             */
);

alter table gee_file add  constraint gee_pk primary key  (gee01,gee02,gee03) enable validate;
grant select on gee_file to tiptopgp;
grant update on gee_file to tiptopgp;
grant delete on gee_file to tiptopgp;
grant insert on gee_file to tiptopgp;
grant index on gee_file to public;
grant select on gee_file to ods;
