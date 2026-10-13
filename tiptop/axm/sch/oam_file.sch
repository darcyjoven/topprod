/*
================================================================================
檔案代號:oam_file
檔案名稱:多角贸易调拨单价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oam_file
(
oam01       varchar2(2) NOT NULL,    /*通路代码                               */
                                     /*通路代碼 -> oal01,oai01                */
oam02       date NOT NULL,           /*生效日期                               */
                                     /*生效日期 -> oal02                      */
oam03       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*Plant No. -> oai11,oai21,...,oai61     */
oam04       varchar2(4),             /*No Use                                 */
oam05       varchar2(40) NOT NULL,   /*料号条件范围                           */
                                     /*料號條件範圍(為QBE格式)                */
oam06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
oamuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oamgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oammodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oamdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oamorig     varchar2(10),            /*资料建立部门                           */
oamoriu     varchar2(10)             /*资料建立者                             */
);

alter table oam_file add  constraint oam_pk primary key  (oam01,oam02,oam03,oam05) enable validate;
grant select on oam_file to tiptopgp;
grant update on oam_file to tiptopgp;
grant delete on oam_file to tiptopgp;
grant insert on oam_file to tiptopgp;
grant index on oam_file to public;
grant select on oam_file to ods;
