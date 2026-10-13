/*
================================================================================
檔案代號:ccm_file
檔案名稱:标准BOM主件单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ccm_file
(
ccm01       varchar2(40) NOT NULL,   /*主件料号                               */
                                     /*主件料號                               */
ccm02       varchar2(10) NOT NULL,   /*标准成本版本                           */
                                     /*標準成本版本                           */
ccm03       number(5),               /*标准工时                               */
                                     /*標準工時                               */
ccm04       number(5),               /*No Use                                 */
ccm05       number(5),               /*No Use                                 */
ccm06       number(5),               /*No Use                                 */
ccmuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ccmgrup     varchar2(10),            /*资料GROUP                              */
                                     /*資料GROUP                              */
ccmmodd     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ccmdate     date,                    /*最近成本卷算日                         */
                                     /*最近成本捲算日                         */
ccmorig     varchar2(10),            /*资料建立部门                           */
ccmoriu     varchar2(10)             /*资料建立者                             */
);

alter table ccm_file add  constraint ccm_pk primary key  (ccm01,ccm02) enable validate;
grant select on ccm_file to tiptopgp;
grant update on ccm_file to tiptopgp;
grant delete on ccm_file to tiptopgp;
grant insert on ccm_file to tiptopgp;
grant index on ccm_file to public;
grant select on ccm_file to ods;
