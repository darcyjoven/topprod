/*
================================================================================
檔案代號:imks_file
檔案名稱:料件批号期间/月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imks_file
(
imks01      varchar2(40) NOT NULL,   /*料件编号                               */
imks02      varchar2(10) NOT NULL,   /*仓库                                   */
imks03      varchar2(10) NOT NULL,   /*库位                                   */
imks04      varchar2(24) NOT NULL,   /*批号                                   */
imks05      number(5) NOT NULL,      /*年度                                   */
imks06      number(5) NOT NULL,      /*期别                                   */
imks081     number(15,3),            /*本期入库统计量                         */
imks082     number(15,3),            /*本期销售统计量                         */
imks083     number(15,3),            /*本期领用统计量                         */
imks084     number(15,3),            /*本期调拨统计量                         */
imks085     number(15,3),            /*本期调整统计量                         */
imks086     number(15,3),            /*no use                                 */
imks087     number(15,3),            /*no use                                 */
imks088     number(15,3),            /*no use                                 */
imks089     number(15,3),            /*no use                                 */
imks09      number(15,3),            /*期末数量                               */
imks10      varchar2(30) NOT NULL,   /*序号                                   */
imks11      varchar2(30) NOT NULL,   /*制造批号                               */
imks12      varchar2(20) NOT NULL,   /*归属单号                               */
imksplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
imkslegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imks_file add  constraint imks_pk primary key  (imks01,imks02,imks03,imks04,imks05,imks06,imks10,imks11,imks12) enable validate;
grant select on imks_file to tiptopgp;
grant update on imks_file to tiptopgp;
grant delete on imks_file to tiptopgp;
grant insert on imks_file to tiptopgp;
grant index on imks_file to public;
grant select on imks_file to ods;
