/*
================================================================================
檔案代號:cnx_file
檔案名稱:海关合同成品期初开账资料
檔案目的:储存海关合同成品的开帐资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cnx_file
(
cnx01       varchar2(40) NOT NULL,   /*商品编号                               */
cnx02       varchar2(20) NOT NULL,   /*手册编号                               */
cnx03       number(5),               /*开帐年份                               */
cnx04       number(5) NOT NULL,      /*开帐月份                               */
cnx05       varchar2(4),             /*合同单位                               */
cnx06       number(15,3),            /*直接出口数量                           */
cnx07       number(15,3),            /*转厂出口数量                           */
cnx08       number(15,3),            /*内销数量                               */
cnx09       number(15,3),            /*加签数量                               */
cnx10       number(12,3),            /*No Use                                 */
cnx11       number(12,3),            /*No Use                                 */
cnx12       number(12,3),            /*No Use                                 */
cnx13       number(12,3),            /*No Use                                 */
cnx14       number(12,3),            /*No Use                                 */
cnx15       number(12,3),            /*No Use                                 */
cnxconf     varchar2(1),             /*审核否                                 */
cnxacti     varchar2(1),             /*资料有效码                             */
cnxuser     varchar2(10),            /*资料所有者                             */
cnxgrup     varchar2(10),            /*资料所有部门                           */
cnxmodu     varchar2(10),            /*资料更改者                             */
cnxdate     date,                    /*最近更改日                             */
cnxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cnxoriu     varchar2(10),            /*资料建立者                             */
cnxorig     varchar2(10)             /*资料建立部门                           */
);

alter table cnx_file add  constraint cnx_pk primary key  (cnx01,cnx02,cnx04) enable validate;
grant select on cnx_file to tiptopgp;
grant update on cnx_file to tiptopgp;
grant delete on cnx_file to tiptopgp;
grant insert on cnx_file to tiptopgp;
grant index on cnx_file to public;
grant select on cnx_file to ods;
