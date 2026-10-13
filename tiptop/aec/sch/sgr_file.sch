/*
================================================================================
檔案代號:sgr_file
檔案名稱:产品工艺变更档
檔案目的:产品工艺变更单头档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgr_file
(
sgr01       varchar2(40) DEFAULT ' ' NOT NULL, /*产品料号*/
sgr02       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
sgr03       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgr04       varchar2(10),            /*变更原因                               */
sgr05       varchar2(80),            /*变更原因说明                           */
sgr06       date DEFAULT sysdate NOT NULL, /*变更日期*/
sgr07       date,                    /*发放日期                               */
sgr08       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sgr09       varchar2(1) DEFAULT ' ' NOT NULL, /*发放码*/
sgracti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
sgrdate     date,                    /*最近更改日                             */
sgrgrup     varchar2(10),            /*资料所属群组                           */
sgrmodu     varchar2(10),            /*资料更改者                             */
sgruser     varchar2(10),            /*资料所有者                             */
sgroriu     varchar2(10),            /*资料建立者                             */
sgrorig     varchar2(10),            /*资料建立部门                           */
sgr012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgr_file add  constraint sgr_pk primary key  (sgr01,sgr02,sgr03,sgr012) enable validate;
grant select on sgr_file to tiptopgp;
grant update on sgr_file to tiptopgp;
grant delete on sgr_file to tiptopgp;
grant insert on sgr_file to tiptopgp;
grant index on sgr_file to public;
grant select on sgr_file to ods;
