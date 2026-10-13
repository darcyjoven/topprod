/*
================================================================================
檔案代號:imk_file
檔案名稱:料件库位期间/月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imk_file
(
imk01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
imk02       varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*倉庫編號                               */
imk03       varchar2(10) NOT NULL,   /*库位编号                               */
                                     /*儲位編號                               */
imk04       varchar2(24) NOT NULL,   /*批号                                   */
                                     /*批號                                   */
imk05       number(5) NOT NULL,      /*年度                                   */
                                     /*年度yyyy                               */
imk06       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
imk081      number(15,3),            /*本期入库统计量                         */
                                     /*本期入庫統計量                         */
imk082      number(15,3),            /*本期销货统计量                         */
                                     /*本期銷貨統計量                         */
imk083      number(15,3),            /*本期领用统计量                         */
                                     /*本期領用統計量                         */
imk084      number(15,3),            /*本期调拨统计量                         */
                                     /*本期轉撥統計量                         */
imk085      number(15,3),            /*本期调整统计量                         */
                                     /*本期調整統計量                         */
imk086      number(15,3),            /*No Use                                 */
imk087      number(5),               /*No Use                                 */
imk088      number(5),               /*No Use                                 */
imk089      number(5),               /*No Use                                 */
imk09       number(15,3),            /*期末数量                               */
                                     /*期末數量                               */
imkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imk_file add  constraint imk_pk primary key  (imk01,imk02,imk03,imk04,imk05,imk06) enable validate;
grant select on imk_file to tiptopgp;
grant update on imk_file to tiptopgp;
grant delete on imk_file to tiptopgp;
grant insert on imk_file to tiptopgp;
grant index on imk_file to public;
grant select on imk_file to ods;
