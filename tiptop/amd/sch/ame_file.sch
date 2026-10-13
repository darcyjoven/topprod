/*
================================================================================
檔案代號:ame_file
檔案名稱:媒体申报其他资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ame_file
(
ame01       varchar2(10) NOT NULL,   /*申报部门                               */
                                     /*申報部門                               */
ame02       number(5) NOT NULL,      /*年度                                   */
ame03       number(5) NOT NULL,      /*月份                                   */
ame04       number(20,6),            /*进口货物-固定资产                      */
                                     /*進口貨物-固定資產                      */
ame05       number(20,6),            /*进口货物-其他货物                      */
                                     /*進口貨物-其他貨物                      */
ame06       number(20,6),            /*购买国外劳务                           */
                                     /*購買國外勞務                           */
ame07       number(20,6),            /*上期累积留抵税额                       */
                                     /*上期累積留抵稅額                       */
ame08       number(20,6),            /*免税货物                               */
                                     /*免稅貨物    add in 99/11/02            */
ameacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ameuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
amegrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
amemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
amedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ame09       number(20,6),            /*特种税额计算之应纳税额                 */
ame10       number(20,6),            /*中途歇业补微应缴税额                   */
ame11       number(20,6),            /*中途歇业应退税额                       */
ame12       varchar2(1),             /*直接扣抵类型                           */
ameoriu     varchar2(10),            /*资料建立者                             */
ameorig     varchar2(10)             /*资料建立部门                           */
);

alter table ame_file add  constraint ame_pk primary key  (ame01,ame02,ame03) enable validate;
grant select on ame_file to tiptopgp;
grant update on ame_file to tiptopgp;
grant delete on ame_file to tiptopgp;
grant insert on ame_file to tiptopgp;
grant index on ame_file to public;
grant select on ame_file to ods;
