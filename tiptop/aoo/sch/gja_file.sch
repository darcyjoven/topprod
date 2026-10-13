/*
================================================================================
檔案代號:gja_file
檔案名稱:项目名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gja_file
(
gja01       varchar2(10) NOT NULL,   /*项目编号                               */
                                     /*專案編號                               */
                                     /*Project number                         */
gja02       varchar2(80),            /*项目名称                               */
                                     /*專案名稱                               */
                                     /*Project name                           */
gja03       date,                    /*项目起始日期                           */
                                     /*專案起始日期                           */
                                     /*Project start date                     */
gja04       date,                    /*项目结束日期                           */
                                     /*專案結束日期                           */
                                     /*Project close date                     */
gja05       number(15,2),            /*No Use                                 */
gja06       number(15,2),            /*No Use                                 */
gja07       number(15,2),            /*No Use                                 */
gja08       number(15,2),            /*No Use                                 */
gjaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gjauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gjagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gjamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gjadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gjaoriu     varchar2(10),            /*资料建立者                             */
gjaorig     varchar2(10)             /*资料建立部门                           */
);

alter table gja_file add  constraint gja_pk primary key  (gja01) enable validate;
grant select on gja_file to tiptopgp;
grant update on gja_file to tiptopgp;
grant delete on gja_file to tiptopgp;
grant insert on gja_file to tiptopgp;
grant index on gja_file to public;
grant select on gja_file to ods;
