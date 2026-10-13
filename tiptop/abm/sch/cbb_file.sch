/*
================================================================================
檔案代號:cbb_file
檔案名稱:FAS 码别资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cbb_file
(
cbbcon      varchar2(40) NOT NULL,   /*规格主件                               */
                                     /*規格主件                               */
cbb01       number(5) NOT NULL,      /*段数                                   */
                                     /*段數                                   */
cbb02       number(5) NOT NULL,      /*位数                                   */
                                     /*位數                                   */
cbb03       varchar2(40) NOT NULL,   /*特性料件                               */
                                     /*ALL 代表全部                           */
cbb04       varchar2(80) NOT NULL,   /*内容                                   */
                                     /*內容                                   */
cbb05       varchar2(40) NOT NULL,   /*选择料件                               */
                                     /*選擇料件                               */
cbbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
cbbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
cbbgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
cbbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
cbbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
cbborig     varchar2(10),            /*资料建立部门                           */
cbboriu     varchar2(10)             /*资料建立者                             */
);

alter table cbb_file add  constraint cbb_pk primary key  (cbbcon,cbb01,cbb02,cbb03,cbb04,cbb05) enable validate;
grant select on cbb_file to tiptopgp;
grant update on cbb_file to tiptopgp;
grant delete on cbb_file to tiptopgp;
grant insert on cbb_file to tiptopgp;
grant index on cbb_file to public;
grant select on cbb_file to ods;
