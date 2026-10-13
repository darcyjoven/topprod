/*
================================================================================
檔案代號:xmh_file
檔案名稱:客户分类产品分类折扣档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xmh_file
(
xmh01       varchar2(10) NOT NULL,   /*客户分类                               */
                                     /*客戶分類                               */
xmh02       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
xmh03       number(9,4),             /*折扣                                   */
xmh04       varchar2(1),             /*是否有效                               */
xmhuser     varchar2(10),            /*资料所有者                             */
xmhgrup     varchar2(10),            /*资料所有部门                           */
xmhmodu     varchar2(10),            /*资料更改者                             */
xmhdate     date,                    /*最近更改日                             */
xmhorig     varchar2(10),            /*资料建立部门                           */
xmhoriu     varchar2(10)             /*资料建立者                             */
);

alter table xmh_file add  constraint xmh_pk primary key  (xmh01,xmh02) enable validate;
grant select on xmh_file to tiptopgp;
grant update on xmh_file to tiptopgp;
grant delete on xmh_file to tiptopgp;
grant insert on xmh_file to tiptopgp;
grant index on xmh_file to public;
grant select on xmh_file to ods;
