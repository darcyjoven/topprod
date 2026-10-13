/*
================================================================================
檔案代號:imv_file
檔案名稱:细部品名档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imv_file
(
imv01       varchar2(10) NOT NULL,   /*细部品名码                             */
                                     /*細部品名碼                             */
imv02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
imv03       number(5),               /*位数                                   */
                                     /*位數                                   */
                                     /*表示其單身可輸入之細部品名的長度       */
imvacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
imvuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
imvgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
imvmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
imvdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
imvoriu     varchar2(10),            /*资料建立者                             */
imvorig     varchar2(10)             /*资料建立部门                           */
);

alter table imv_file add  constraint imv_pk primary key  (imv01) enable validate;
grant select on imv_file to tiptopgp;
grant update on imv_file to tiptopgp;
grant delete on imv_file to tiptopgp;
grant insert on imv_file to tiptopgp;
grant index on imv_file to public;
grant select on imv_file to ods;
