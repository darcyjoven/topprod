/*
================================================================================
檔案代號:cnq_file
檔案名稱:进出囗报关异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnq_file
(
cnq01       varchar2(20),            /*手册编号                               */
cnq02       varchar2(40),            /*商品编号                               */
cnq03       varchar2(20),            /*异动单号                               */
cnq04       date,                    /*异动日期                               */
cnq05       varchar2(1),             /*类型                                   */
cnq06       varchar2(1),             /*交易类型(1.出口                        */
cnq07       varchar2(1),             /*类型                                   */
cnq08       number(5),               /*备案序号                               */
cnq09       varchar2(10),            /*海关编号                               */
cnq10       varchar2(30),            /*报关单号                               */
cnq11       date,                    /*报单日期                               */
cnq12       varchar2(20),            /*折合单号                               */
cnq13       number(15,3),            /*异动数量                               */
cnq14       varchar2(4),             /*单位                                   */
cnq15       number(20,6),            /*单价                                   */
cnq16       number(20,6),            /*金额                                   */
cnq17       varchar2(1),             /*No Use                                 */
cnq18       varchar2(1),             /*No Use                                 */
cnq19       number(5),               /*No Use                                 */
cnq20       number(5),               /*No Use                                 */
cnqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cnq_02 on cnq_file (cnq05,cnq06,cnq07);
create        index cnq_01 on cnq_file (cnq01,cnq02);
grant select on cnq_file to tiptopgp;
grant update on cnq_file to tiptopgp;
grant delete on cnq_file to tiptopgp;
grant insert on cnq_file to tiptopgp;
grant index on cnq_file to public;
grant select on cnq_file to ods;
