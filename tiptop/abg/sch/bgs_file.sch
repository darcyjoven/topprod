/*
================================================================================
檔案代號:bgs_file
檔案名稱:费用项目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgs_file
(
bgs01       varchar2(6) NOT NULL,    /*费用项目编号                           */
                                     /*費用項目代號                           */
bgs02       varchar2(80),            /*费用项目说明                           */
                                     /*費用項目說明                           */
bgs03       varchar2(1),             /*计调否                                 */
                                     /*計調否                                 */
bgsacti     varchar2(1),             /*资料有效码                             */
bgsuser     varchar2(10),            /*资料所有者                             */
bgsgrup     varchar2(10),            /*资料所有部门                           */
bgsmodu     varchar2(10),            /*资料更改者                             */
bgsdate     date,                    /*最近更改日                             */
bgsorig     varchar2(10),            /*资料建立部门                           */
bgsoriu     varchar2(10)             /*资料建立者                             */
);

alter table bgs_file add  constraint bgs_pk primary key  (bgs01) enable validate;
grant select on bgs_file to tiptopgp;
grant update on bgs_file to tiptopgp;
grant delete on bgs_file to tiptopgp;
grant insert on bgs_file to tiptopgp;
grant index on bgs_file to public;
grant select on bgs_file to ods;
