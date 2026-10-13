/*
================================================================================
檔案代號:imkk_file
檔案名稱:料件单位期间/月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imkk_file
(
imkk01      varchar2(40) NOT NULL,   /*料件编号                               */
imkk02      varchar2(10) NOT NULL,   /*仓库编号                               */
imkk03      varchar2(10) NOT NULL,   /*库位编号                               */
imkk04      varchar2(24) NOT NULL,   /*批号                                   */
imkk05      number(5) NOT NULL,      /*年度yyyy                               */
imkk06      number(5) NOT NULL,      /*期别                                   */
imkk081     number(15,3),            /*本期入库统计量                         */
imkk082     number(15,3),            /*本期销货统计量                         */
imkk083     number(15,3),            /*本期领用统计量                         */
imkk084     number(15,3),            /*本期调拨统计量                         */
imkk085     number(15,3),            /*本期调整统计量                         */
imkk086     number(5),               /*No Use                                 */
imkk087     number(5),               /*No Use                                 */
imkk088     number(5),               /*No Use                                 */
imkk089     number(5),               /*No Use                                 */
imkk09      number(15,3),            /*期末数量                               */
imkk10      varchar2(4) NOT NULL,    /*记录 '单位'                            */
imkkplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
imkklegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imkk_file add  constraint imkk_pk primary key  (imkk01,imkk02,imkk03,imkk04,imkk05,imkk06,imkk10) enable validate;
grant select on imkk_file to tiptopgp;
grant update on imkk_file to tiptopgp;
grant delete on imkk_file to tiptopgp;
grant insert on imkk_file to tiptopgp;
grant index on imkk_file to public;
grant select on imkk_file to ods;
