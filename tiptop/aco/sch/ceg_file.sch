/*
================================================================================
檔案代號:ceg_file
檔案名稱:海关商品编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ceg_file
(
ceg00       varchar2(1) DEFAULT ' ' NOT NULL, /*区分*/
ceg01       varchar2(40) DEFAULT ' ' NOT NULL, /*商品编号*/
ceg02       varchar2(80),            /*备注                                   */
ceg03       number(9,4),             /*最惠国税率                             */
ceg04       number(9,4),             /*普通税率                               */
ceg05       number(9,4),             /*增值税率                               */
ceg06       number(9,4),             /*消费税率                               */
ceg07       number(9,4),             /*退税率                                 */
ceg08       varchar2(4),             /*计量单位                               */
ceg09       varchar2(10),            /*海关商品大类                           */
ceg10       varchar2(10),            /*监管方式                               */
ceg11       varchar2(4),             /*法定计量单位                           */
ceg12       number(15,6),            /*法定计量单位转换比率                   */
ceg13       varchar2(4),             /*第二法定计量单位                       */
ceg14       number(15,6),            /*第二法定计量单位转换比率               */
cegacti     varchar2(1),             /*资料有效码                             */
cegdate     date,                    /*最近更改日                             */
ceggrup     varchar2(10),            /*资料所有部门                           */
cegmodu     varchar2(10),            /*资料更改者                             */
ceguser     varchar2(10),            /*资料所有者                             */
cegorig     varchar2(10),            /*资料建立部门                           */
cegoriu     varchar2(10)             /*资料建立者                             */
);

alter table ceg_file add  constraint ceg_pk primary key  (ceg00,ceg01) enable validate;
grant select on ceg_file to tiptopgp;
grant update on ceg_file to tiptopgp;
grant delete on ceg_file to tiptopgp;
grant insert on ceg_file to tiptopgp;
grant index on ceg_file to public;
grant select on ceg_file to ods;
