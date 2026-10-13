/*
================================================================================
檔案代號:gem_file
檔案名稱:部门名称资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gem_file
(
gem01       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
gem02       varchar2(80),            /*部门名称                               */
                                     /*部門名稱                               */
gem03       varchar2(80),            /*部门全称                               */
                                     /*部門全稱                               */
gem04       varchar2(6),             /*No Use                                 */
gem05       varchar2(1),             /*是否为会计部门                         */
                                     /*是否為會計部門 (Y/N)                   */
gem06       varchar2(1),             /*No Use                                 */
gem07       varchar2(1),             /*费用类型                               */
                                     /*費用類別                               */
                                     /*M:管理費用 P:製造費用 R:研發費用       */
                                     /*S:銷售費用                             */
gem08       varchar2(1),             /*No Use                                 */
gemacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gemuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gemgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gemmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gemdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gem09       varchar2(1),             /*管理类型 1.成本中心 2.利润中           */
gem10       varchar2(10),            /*对应成本中心                           */
gem11       varchar2(10),            /*no use                                 */
                                     /*Logistics                              */
gemorig     varchar2(10),            /*资料建立部门                           */
gemoriu     varchar2(10)             /*资料建立者                             */
);

alter table gem_file add  constraint gem_pk primary key  (gem01) enable validate;
grant select on gem_file to tiptopgp;
grant update on gem_file to tiptopgp;
grant delete on gem_file to tiptopgp;
grant insert on gem_file to tiptopgp;
grant index on gem_file to public;
grant select on gem_file to ods;
