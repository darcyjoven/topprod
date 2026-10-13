/*
================================================================================
檔案代號:stm_file
檔案名稱:生产量值统计档--By 产品别
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table stm_file
(
stm01       number(5) NOT NULL,      /*年度                                   */
stm02       number(5) NOT NULL,      /*月份                                   */
stm03       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別                                 */
stm04       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
stm05       number(20,6),            /*生产成本                               */
                                     /*生產成本                               */
stm06       number(15,3),            /*生产数量                               */
                                     /*生產數量(不含重工)                     */
stm07       number(20,6),            /*生产成本                               */
                                     /*生產成本(不含重工)                     */
stmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stm_file add  constraint stm_pk primary key  (stm01,stm02,stm03) enable validate;
grant select on stm_file to tiptopgp;
grant update on stm_file to tiptopgp;
grant delete on stm_file to tiptopgp;
grant insert on stm_file to tiptopgp;
grant index on stm_file to public;
grant select on stm_file to ods;
