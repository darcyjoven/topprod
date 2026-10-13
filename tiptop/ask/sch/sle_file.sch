/*
================================================================================
檔案代號:sle_file
檔案名稱:基础码尺寸表档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sle_file
(
sle01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
sle02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
sle03       varchar2(10) DEFAULT ' ' NOT NULL, /*尺寸*/
sle04       date,                    /*制定日期                               */
sle05       varchar2(20),            /*版单号                                 */
sle06       varchar2(4),             /*洗水色                                 */
sle07       varchar2(1),             /*基础码否                               */
sle08       number(15,3),            /*缩率(直)                               */
sle09       number(15,3),            /*缩率(横)                               */
sle10       varchar2(10),            /*末尾属性                               */
sleconf     varchar2(1),             /*资料有效码                             */
sledate     date,                    /*资料更改日期                           */
slegrup     varchar2(10),            /*资料所有群                             */
slemodu     varchar2(10),            /*资料更改者                             */
sleuser     varchar2(10),            /*资料所有者                             */
sleoriu     varchar2(10),            /*资料建立者                             */
sleorig     varchar2(10)             /*资料建立部门                           */
);

alter table sle_file add  constraint sle_pk primary key  (sle01,sle02,sle03) enable validate;
grant select on sle_file to tiptopgp;
grant update on sle_file to tiptopgp;
grant delete on sle_file to tiptopgp;
grant insert on sle_file to tiptopgp;
grant index on sle_file to public;
grant select on sle_file to ods;
