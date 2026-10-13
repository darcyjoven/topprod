/*
================================================================================
檔案代號:stl_file
檔案名稱:销售量值统计档--By 产品别
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table stl_file
(
stl01       number(5) NOT NULL,      /*年度                                   */
stl02       number(5) NOT NULL,      /*月份                                   */
stl03       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別                                 */
stl04       number(15,3),            /*销售数量                               */
                                     /*銷售數量                               */
stl05       number(20,6),            /*销售金额                               */
                                     /*銷售金額                               */
stl06       number(20,6),            /*销售成本                               */
                                     /*銷售成本                               */
stl07       number(15,3),            /*销退数量                               */
                                     /*銷退數量                               */
stl08       number(20,6),            /*销退金额                               */
                                     /*銷退金額                               */
stl09       number(20,6),            /*销退成本                               */
                                     /*銷退成本                               */
stlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stl_file add  constraint stl_pk primary key  (stl01,stl02,stl03) enable validate;
grant select on stl_file to tiptopgp;
grant update on stl_file to tiptopgp;
grant delete on stl_file to tiptopgp;
grant insert on stl_file to tiptopgp;
grant index on stl_file to public;
grant select on stl_file to ods;
