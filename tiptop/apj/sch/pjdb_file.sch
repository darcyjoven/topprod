/*
================================================================================
檔案代號:pjdb_file
檔案名稱:项目活动预计费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjdb_file
(
pjdb01      varchar2(10) NOT NULL,   /*网络代号                               */
pjdb02      varchar2(4) NOT NULL,    /*活动编号                               */
pjdb03      varchar2(10) NOT NULL,   /*费用编号                               */
pjdb04      varchar2(24),            /*科目一                                 */
pjdb05      varchar2(24),            /*科目二                                 */
pjdb06      number(20,6),            /*预估金额                               */
pjdbacti    varchar2(1),             /*资料有效码                             */
pjdbdate    date,                    /*最近更改日                             */
pjdbgrup    varchar2(10),            /*资料所有部门                           */
pjdbmodu    varchar2(10),            /*资料更改者                             */
pjdbuser    varchar2(10),            /*资料所有者                             */
pjdborig    varchar2(10),            /*资料建立部门                           */
pjdboriu    varchar2(10)             /*资料建立者                             */
);

alter table pjdb_file add  constraint pjdb_pk primary key  (pjdb01,pjdb02,pjdb03) enable validate;
grant select on pjdb_file to tiptopgp;
grant update on pjdb_file to tiptopgp;
grant delete on pjdb_file to tiptopgp;
grant insert on pjdb_file to tiptopgp;
grant index on pjdb_file to public;
grant select on pjdb_file to ods;
