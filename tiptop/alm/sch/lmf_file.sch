/*
================================================================================
檔案代號:lmf_file
檔案名稱:摊位基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmf_file
(
lmf01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lmf02       varchar2(10),            /*no use 原门店编号                      */
lmf03       varchar2(10),            /*楼栋编号                               */
lmf04       varchar2(10),            /*楼层编号                               */
lmf05       varchar2(1),             /*状态                                   */
lmf06       varchar2(1),             /*确认码                                 */
lmf07       varchar2(10),            /*审核人                                 */
lmf08       date,                    /*审核日期                               */
lmfacti     varchar2(1),             /*资料有效码                             */
lmfcrat     date,                    /*资料创建日                             */
lmfdate     date,                    /*最近更改日                             */
lmfgrup     varchar2(10),            /*资料所有群                             */
lmflegal    varchar2(10) NOT NULL,   /*所属法人                               */
lmfmodu     varchar2(10),            /*资料更改者                             */
lmfuser     varchar2(10),            /*资料所有者                             */
lmforiu     varchar2(10),            /*资料建立者                             */
lmforig     varchar2(10),            /*资料建立部门                           */
lmfstore    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lmf09       number(20,6),            /*建筑面积                               */
lmf10       number(20,6),            /*測量面積                               */
lmf11       number(20,6),            /*经营面积                               */
lmf12       varchar2(10),            /*攤位用途                               */
lmf13       varchar2(200),           /*門牌號                                 */
lmf14       varchar2(255),           /*备注                                   */
lmf15       number(5)                /*版本号                                 */
);

alter table lmf_file add  constraint lmf_pk primary key  (lmf01) enable validate;
grant select on lmf_file to tiptopgp;
grant update on lmf_file to tiptopgp;
grant delete on lmf_file to tiptopgp;
grant insert on lmf_file to tiptopgp;
grant index on lmf_file to public;
grant select on lmf_file to ods;
