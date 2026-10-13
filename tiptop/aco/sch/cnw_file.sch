/*
================================================================================
檔案代號:cnw_file
檔案名稱:海关合同材料期初开账资料
檔案目的:储存海关合同材料的开帐资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cnw_file
(
cnw01       varchar2(40) NOT NULL,   /*商品编号                               */
cnw02       varchar2(20) NOT NULL,   /*手册编号                               */
cnw03       number(5) NOT NULL,      /*开帐年份                               */
cnw04       number(5) NOT NULL,      /*开帐月份                               */
cnw05       varchar2(4),             /*合同单位                               */
cnw06       number(15,3),            /*手册转入                               */
cnw07       number(15,3),            /*直接进口数量                           */
cnw08       number(15,3),            /*直接耗用                               */
cnw09       number(15,3),            /*转厂进口数量                           */
cnw10       number(15,3),            /*转厂耗用                               */
cnw11       number(15,3),            /*国内采购数量                           */
cnw12       number(15,3),            /*内销耗用                               */
cnw13       number(15,3),            /*报废数量                               */
cnw14       number(15,3),            /*加签数量                               */
cnw15       number(12,3),            /*No Use                                 */
cnw16       number(12,3),            /*No Use                                 */
cnw17       number(12,3),            /*No Use                                 */
cnw18       number(12,3),            /*No Use                                 */
cnw19       number(12,3),            /*No Use                                 */
cnw20       number(12,3),            /*No Use                                 */
cnwconf     varchar2(1),             /*审核否                                 */
cnwacti     varchar2(1),             /*资料有效码                             */
cnwuser     varchar2(10),            /*资料所有者                             */
cnwgrup     varchar2(10),            /*资料所有部门                           */
cnwmodu     varchar2(10),            /*资料更改者                             */
cnwdate     date,                    /*最近更改日                             */
cnwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cnworiu     varchar2(10),            /*资料建立者                             */
cnworig     varchar2(10)             /*资料建立部门                           */
);

alter table cnw_file add  constraint cnw_pk primary key  (cnw01,cnw02,cnw03,cnw04) enable validate;
grant select on cnw_file to tiptopgp;
grant update on cnw_file to tiptopgp;
grant delete on cnw_file to tiptopgp;
grant insert on cnw_file to tiptopgp;
grant index on cnw_file to public;
grant select on cnw_file to ods;
