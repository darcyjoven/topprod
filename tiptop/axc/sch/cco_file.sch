/*
================================================================================
檔案代號:cco_file
檔案名稱:标准成本版本名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cco_file
(
cco01       varchar2(10) NOT NULL,   /*版本                                   */
cco02       varchar2(80),            /*版本名称                               */
                                     /*版本名稱                               */
cco03       number(20,6),            /*每小时直接人工成本分摊金额             */
                                     /*每小時直接人工成本分攤金額             */
cco04       number(20,6),            /*每小时间接制造费用分摊金额             */
                                     /*每小時間接製造費用分攤金額             */
cco05       varchar2(1),             /*冻结否                                 */
                                     /*凍結否 (Y/N)                           */
                                     /*  Y:版本凍結, 不可再做任何修改調整     */
cco06       date,                    /*最近冻结日期                           */
                                     /*最近凍結日期                           */
cco07       varchar2(10),            /*最近冻结人员                           */
                                     /*最近凍結人員                           */
cco08       number(10),              /*版本冻结时料件笔数                     */
                                     /*版本凍結時料件筆數                     */
cco09       number(10),              /*版本冻结时BOM 笔数                     */
                                     /*版本凍結時BOM 筆數                     */
cco10       number(20,6)             /*版本冻结时料件成本合计                 */
                                     /*版本凍結時料件成本合計                 */
);

alter table cco_file add  constraint cco_pk primary key  (cco01) enable validate;
grant select on cco_file to tiptopgp;
grant update on cco_file to tiptopgp;
grant delete on cco_file to tiptopgp;
grant insert on cco_file to tiptopgp;
grant index on cco_file to public;
grant select on cco_file to ods;
