/*
================================================================================
檔案代號:gfe_file
檔案名稱:单位档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gfe_file
(
gfe01       varchar2(4) NOT NULL,    /*单位                                   */
                                     /*單位                                   */
gfe02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
gfe03       number(5),               /*小数位数                               */
                                     /*小數位數                               */
gfeacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gfeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gfegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gfemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gfedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gfepos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
gfeorig     varchar2(10),            /*资料建立部门                           */
gfeoriu     varchar2(10)             /*资料建立者                             */
);

alter table gfe_file add  constraint gfe_pk primary key  (gfe01) enable validate;
grant select on gfe_file to tiptopgp;
grant update on gfe_file to tiptopgp;
grant delete on gfe_file to tiptopgp;
grant insert on gfe_file to tiptopgp;
grant index on gfe_file to public;
grant select on gfe_file to ods;
