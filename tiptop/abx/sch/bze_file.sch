/*
================================================================================
檔案代號:bze_file
檔案名稱:保税机器设备盘点底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bze_file
(
bze01       varchar2(10) NOT NULL,   /*盘点编号                               */
bze02       date,                    /*盘点日期                               */
bze03       varchar2(255),           /*备注                                   */
bze04       number(5),               /*盘点年度                               */
bze05       varchar2(10),            /*审核人                                 */
bze06       date,                    /*审核日期                               */
bze07       varchar2(1),             /*确认码                                 */
                                     /*(Y/N/X)                                */
bze08       varchar2(1),             /*No Use                                 */
bze09       varchar2(1),             /*No Use                                 */
bze10       varchar2(1),             /*No Use                                 */
bzeacti     varchar2(1),             /*资料有效码                             */
bzeuser     varchar2(10),            /*资料所有者                             */
bzegrup     varchar2(10),            /*资料所有部门                           */
bzemodu     varchar2(10),            /*资料更改者                             */
bzedate     date,                    /*最近更改日                             */
bzeorig     varchar2(10),            /*资料建立部门                           */
bzeoriu     varchar2(10)             /*资料建立者                             */
);

alter table bze_file add  constraint bze_pk primary key  (bze01) enable validate;
grant select on bze_file to tiptopgp;
grant update on bze_file to tiptopgp;
grant delete on bze_file to tiptopgp;
grant insert on bze_file to tiptopgp;
grant index on bze_file to public;
grant select on bze_file to ods;
