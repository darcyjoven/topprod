/*
================================================================================
檔案代號:lrs_file
檔案名稱:开卡维护单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrs_file
(
lrs01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lrs02       date,                    /*单据日期                               */
lrs03       varchar2(1) DEFAULT 'N' NOT NULL, /*审核码*/
lrs04       varchar2(10),            /*审核人                                 */
lrs05       date,                    /*审核日期                               */
lrs06       varchar2(50),            /*备注                                   */
lrsacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lrscrat     date,                    /*资料创建日                             */
lrsdate     date,                    /*最近更改日                             */
lrsgrup     varchar2(10),            /*资料所有群                             */
lrslegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrsmodu     varchar2(10),            /*资料更改者                             */
lrsorig     varchar2(10),            /*资料建立部门                           */
lrsoriu     varchar2(10),            /*资料建立者                             */
lrsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrsuser     varchar2(10)             /*资料所有者                             */
);

alter table lrs_file add  constraint lrs_pk primary key  (lrs01) enable validate;
grant select on lrs_file to tiptopgp;
grant update on lrs_file to tiptopgp;
grant delete on lrs_file to tiptopgp;
grant insert on lrs_file to tiptopgp;
grant index on lrs_file to public;
grant select on lrs_file to ods;
