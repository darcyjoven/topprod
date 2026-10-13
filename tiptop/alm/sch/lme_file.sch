/*
================================================================================
檔案代號:lme_file
檔案名稱:楼层分摊资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lme_file
(
lme01       varchar2(10),            /*no use 原门店编号                      */
lme02       varchar2(10) DEFAULT ' ' NOT NULL, /*楼栋编号*/
lme03       varchar2(10) DEFAULT ' ' NOT NULL, /*楼层编号*/
lme04       number(20,2),            /*分摊率                                 */
lme05       varchar2(1),             /*确认码                                 */
lme06       varchar2(10),            /*审核人                                 */
lme07       date,                    /*审核日期                               */
lmeacti     varchar2(1),             /*资料有效码                             */
lmecrat     date,                    /*资料创建日                             */
lmedate     date,                    /*最近更改日                             */
lmegrup     varchar2(10),            /*资料所有群                             */
lmelegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmemodu     varchar2(10),            /*资料更改者                             */
lmeuser     varchar2(10),            /*资料所有者                             */
lmeoriu     varchar2(10),            /*资料建立者                             */
lmeorig     varchar2(10),            /*资料建立部门                           */
lmestore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lme_file add  constraint lme_pk primary key  (lmestore,lme02,lme03) enable validate;
grant select on lme_file to tiptopgp;
grant update on lme_file to tiptopgp;
grant delete on lme_file to tiptopgp;
grant insert on lme_file to tiptopgp;
grant index on lme_file to public;
grant select on lme_file to ods;
