/*
================================================================================
檔案代號:stk_file
檔案名稱:销售量值统计档--By 产品别
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table stk_file
(
stk01       number(5) NOT NULL,      /*年度                                   */
stk02       number(5) NOT NULL,      /*月份                                   */
stk03       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別                                 */
stk04       number(15,3),            /*销售数量                               */
                                     /*銷售數量                               */
stk05       number(20,6),            /*销售金额                               */
                                     /*銷售金額                               */
stk06       number(20,6),            /*销售成本                               */
                                     /*銷售成本                               */
stk07       number(15,3),            /*销退数量                               */
                                     /*銷退數量                               */
stk08       number(20,6),            /*销退金额                               */
                                     /*銷退金額                               */
stk09       number(20,6),            /*销退成本                               */
                                     /*銷退成本                               */
stkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stk_file add  constraint stk_pk primary key  (stk01,stk02,stk03) enable validate;
grant select on stk_file to tiptopgp;
grant update on stk_file to tiptopgp;
grant delete on stk_file to tiptopgp;
grant insert on stk_file to tiptopgp;
grant index on stk_file to public;
grant select on stk_file to ods;
