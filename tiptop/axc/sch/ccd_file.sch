/*
================================================================================
檔案代號:ccd_file
檔案名稱:成本阶数名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ccd_file
(
ccd01       number(5) NOT NULL,      /*成本阶数                               */
                                     /*成本階數                               */
                                     /*char(02) -> smallint            No.7269*/
ccd02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
ccd03       varchar2(1),             /*须计算返工否                           */
                                     /*須計算重工否(Y/N)                      */
ccd04       varchar2(1),             /*No Use                                 */
ccd05       varchar2(1),             /*No Use                                 */
ccdacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ccduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ccdgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ccdmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ccddate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ccdorig     varchar2(10),            /*资料建立部门                           */
ccdoriu     varchar2(10)             /*资料建立者                             */
);

alter table ccd_file add  constraint ccd_pk primary key  (ccd01) enable validate;
grant select on ccd_file to tiptopgp;
grant update on ccd_file to tiptopgp;
grant delete on ccd_file to tiptopgp;
grant insert on ccd_file to tiptopgp;
grant index on ccd_file to public;
grant select on ccd_file to ods;
