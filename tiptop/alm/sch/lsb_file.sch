/*
================================================================================
檔案代號:lsb_file
檔案名稱:广告位资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsb_file
(
lsb01       varchar2(20) DEFAULT ' ' NOT NULL, /*广告位编号*/
lsb02       varchar2(10),            /*no use 原门店编号                      */
lsb03       varchar2(10),            /*楼栋编号                               */
lsb04       varchar2(10),            /*楼层编号                               */
lsb05       varchar2(1),             /*广告位位置                             */
lsb06       varchar2(1),             /*方位                                   */
lsb07       varchar2(30),            /*地点描述                               */
lsb08       number(20,2),            /*面积                                   */
lsb09       varchar2(30),            /*材质                                   */
lsb10       number(20,2),            /*宽                                     */
lsb11       number(20,2),            /*宽                                     */
lsb12       varchar2(60),            /*备注一                                 */
lsb13       varchar2(60),            /*备注二                                 */
lsb14       varchar2(1),             /*是否签核                               */
lsb15       varchar2(1),             /*签核状态                               */
lsb16       varchar2(1),             /*审核码                                 */
lsb17       varchar2(10),            /*审核人                                 */
lsb18       date,                    /*审核日期                               */
lsbacti     varchar2(1),             /*资料有效码                             */
lsbcrat     date,                    /*资料创建日                             */
lsbdate     date,                    /*最近更改日                             */
lsbgrup     varchar2(10),            /*资料所有群                             */
lsblegal    varchar2(10) NOT NULL,   /*所属法人                               */
lsbmodu     varchar2(10),            /*资料更改者                             */
lsbuser     varchar2(10),            /*资料所有者                             */
lsboriu     varchar2(10),            /*资料建立者                             */
lsborig     varchar2(10),            /*资料建立部门                           */
lsbstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lsb_file add  constraint lsb_pk primary key  (lsb01) enable validate;
grant select on lsb_file to tiptopgp;
grant update on lsb_file to tiptopgp;
grant delete on lsb_file to tiptopgp;
grant insert on lsb_file to tiptopgp;
grant index on lsb_file to public;
grant select on lsb_file to ods;
