/*
================================================================================
檔案代號:lrm_file
檔案名稱:赠品回收记录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrm_file
(
lrm00       varchar2(10),            /*no use                                 */
lrm01       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品回收单号*/
lrm02       varchar2(20),            /*退货单编号                             */
lrm03       varchar2(20),            /*销售单编号                             */
lrm04       varchar2(20),            /*退货凭证编号                           */
lrm05       number(20,2) DEFAULT '0' NOT NULL, /*退货总金额*/
lrm06       date,                    /*赠品回收日期                           */
lrm07       number(20,2) DEFAULT '0' NOT NULL, /*总赔偿金额*/
lrm08       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lrm09       varchar2(10),            /*审核人                                 */
lrm10       date,                    /*审核日期                               */
lrm11       varchar2(50),            /*备注                                   */
lrmcrat     date,                    /*资料创建日                             */
lrmdate     date,                    /*最近更改日                             */
lrmgrup     varchar2(10),            /*资料所有群                             */
lrmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrmmodu     varchar2(10),            /*资料更改者                             */
lrmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrmuser     varchar2(10),            /*资料所有者                             */
lrmoriu     varchar2(10),            /*资料建立者                             */
lrmorig     varchar2(10)             /*资料建立部门                           */
);

alter table lrm_file add  constraint lrm_pk primary key  (lrm01) enable validate;
grant select on lrm_file to tiptopgp;
grant update on lrm_file to tiptopgp;
grant delete on lrm_file to tiptopgp;
grant insert on lrm_file to tiptopgp;
grant index on lrm_file to public;
grant select on lrm_file to ods;
