/*
================================================================================
檔案代號:lmd_file
檔案名稱:场地基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmd_file
(
lmd01       varchar2(20) DEFAULT ' ' NOT NULL, /*场地编号*/
lmd02       varchar2(10),            /*no use 原门店编号                      */
lmd03       varchar2(10),            /*楼栋编号                               */
lmd04       varchar2(10),            /*楼层编号                               */
lmd05       number(20,6),            /*经营面积                               */
lmd06       number(20,6),            /*建筑面积                               */
lmd07       varchar2(1),             /*场地状态                               */
lmd08       varchar2(1),             /*No Use                                 */
lmd09       varchar2(1),             /*No Use                                 */
lmd10       varchar2(1),             /*确认码                                 */
lmd11       varchar2(10),            /*审核人                                 */
lmd12       date,                    /*审核日期                               */
lmd13       varchar2(255),           /*备注                                   */
lmdacti     varchar2(1),             /*资料有效码                             */
lmdcrat     date,                    /*资料有效码                             */
lmddate     date,                    /*最近更改日                             */
lmdgrup     varchar2(10),            /*资料所有群                             */
lmdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmdmodu     varchar2(10),            /*资料更改者                             */
lmduser     varchar2(10),            /*资料所有人                             */
lmdoriu     varchar2(10),            /*资料建立者                             */
lmdorig     varchar2(10),            /*资料建立部门                           */
lmdstore    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lmd14       varchar2(10),            /*区域编号                               */
lmd15       number(20,6),            /*測量面積                               */
lmd16       number(5)                /*版本号                                 */
);

alter table lmd_file add  constraint lmd_pk primary key  (lmd01) enable validate;
grant select on lmd_file to tiptopgp;
grant update on lmd_file to tiptopgp;
grant delete on lmd_file to tiptopgp;
grant insert on lmd_file to tiptopgp;
grant index on lmd_file to public;
grant select on lmd_file to ods;
