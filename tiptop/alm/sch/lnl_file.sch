/*
================================================================================
檔案代號:lnl_file
檔案名稱:费用明细参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lnl_file
(
lnl01       varchar2(10) DEFAULT ' ' NOT NULL, /*费用明细编号*/
lnl02       varchar2(10),            /*no use 原门店编号                      */
lnl03       varchar2(10),            /*按楼栋设置费用标准                     */
lnl04       varchar2(10),            /*按楼层设置费用标准                     */
lnl05       varchar2(10),            /*按区域设置费用标准                     */
lnl06       varchar2(4),             /*no use                                 */
lnl07       varchar2(2),             /*no use                                 */
lnl08       varchar2(20),            /*no use                                 */
lnl09       varchar2(1),             /*按小类设置费用标准                     */
lnl10       varchar2(1),             /*费用按                                 */
                                     /*0:people                               */
                                     /*1:sale                                 */
                                     /*2:area                                 */
                                     /*3:area                                 */
lnlacti     varchar2(1),             /*资料有效码                             */
lnlcrat     date,                    /*资料创建日                             */
lnldate     date,                    /*最近更改日                             */
lnlgrup     varchar2(10),            /*资料所有群                             */
lnllegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnlmodu     varchar2(10),            /*资料更改者                             */
lnluser     varchar2(10),            /*资料所有者                             */
lnloriu     varchar2(10),            /*资料建立者                             */
lnlorig     varchar2(10),            /*资料建立部门                           */
lnlstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnl_file add  constraint lnl_pk primary key  (lnl01,lnlstore) enable validate;
grant select on lnl_file to tiptopgp;
grant update on lnl_file to tiptopgp;
grant delete on lnl_file to tiptopgp;
grant insert on lnl_file to tiptopgp;
grant index on lnl_file to public;
grant select on lnl_file to ods;
