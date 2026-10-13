/*
================================================================================
檔案代號:stn_file
檔案名稱:生产量值统计档--By 产品分类
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table stn_file
(
stn01       number(5) NOT NULL,      /*年度                                   */
stn02       number(5) NOT NULL,      /*月份                                   */
stn03       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
stn04       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
stn05       number(20,6),            /*生产成本                               */
                                     /*生產成本                               */
stn06       number(15,3),            /*生产数量                               */
                                     /*生產數量(不含重工)                     */
stn07       number(20,6),            /*生产成本                               */
                                     /*生產成本(不含重工)                     */
stnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stn_file add  constraint stn_pk primary key  (stn01,stn02,stn03) enable validate;
grant select on stn_file to tiptopgp;
grant update on stn_file to tiptopgp;
grant delete on stn_file to tiptopgp;
grant insert on stn_file to tiptopgp;
grant index on stn_file to public;
grant select on stn_file to ods;
