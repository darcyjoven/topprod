/*
================================================================================
檔案代號:lmr_file
檔案名稱:产品分类颜色设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmr_file
(
lmr01       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
lmr02       varchar2(10),            /*颜色                                   */
lmr03       varchar2(30),            /*说明                                   */
lmracti     varchar2(1),             /*资料有效码                             */
lmrcrat     date,                    /*资料创建日                             */
lmrdate     date,                    /*资料更改日                             */
lmrgrup     varchar2(10),            /*资料所有群                             */
lmrmodu     varchar2(10),            /*资料更改者                             */
lmruser     varchar2(10),            /*资料所有者                             */
lmrorig     varchar2(10),            /*资料建立部门                           */
lmroriu     varchar2(10)             /*资料建立者                             */
);

alter table lmr_file add  constraint lmr_pk primary key  (lmr01) enable validate;
grant select on lmr_file to tiptopgp;
grant update on lmr_file to tiptopgp;
grant delete on lmr_file to tiptopgp;
grant insert on lmr_file to tiptopgp;
grant index on lmr_file to public;
grant select on lmr_file to ods;
