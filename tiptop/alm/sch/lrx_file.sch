/*
================================================================================
檔案代號:lrx_file
檔案名稱:卡取消掛失維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrx_file
(
lrx01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lrx02       varchar2(30),            /*卡号                                   */
lrx03       varchar2(20),            /*会员编号                               */
lrx04       varchar2(10),            /*理由码                                 */
lrx05       date,                    /*单据日期                               */
lrx06       varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
lrx07       varchar2(10),            /*审核人                                 */
lrx08       date,                    /*审核日期                               */
lrx09       varchar2(50),            /*备注                                   */
lrxacti     varchar2(1),             /*资料有效码                             */
lrxcrat     date,                    /*资料创建日                             */
lrxdate     date,                    /*最近更改日                             */
lrxgrup     varchar2(10),            /*资料所有群                             */
lrxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrxmodu     varchar2(10),            /*资料更改者                             */
lrxorig     varchar2(10),            /*资料建立部门                           */
lrxoriu     varchar2(10),            /*资料建立者                             */
lrxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrxuser     varchar2(10)             /*资料所有者                             */
);

alter table lrx_file add  constraint lrx_pk primary key  (lrx01) enable validate;
grant select on lrx_file to tiptopgp;
grant update on lrx_file to tiptopgp;
grant delete on lrx_file to tiptopgp;
grant insert on lrx_file to tiptopgp;
grant index on lrx_file to public;
grant select on lrx_file to ods;
