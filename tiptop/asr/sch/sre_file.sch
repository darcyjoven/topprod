/*
================================================================================
檔案代號:sre_file
檔案名稱:生产报工资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sre_file
(
sre01       number(5) NOT NULL,      /*年度                                   */
sre02       number(5) NOT NULL,      /*月份                                   */
sre03       varchar2(10) NOT NULL,   /*机台生产线                             */
sre04       varchar2(40) NOT NULL,   /*生产料号                               */
sre05       varchar2(10) NOT NULL,   /*班别                                   */
sre06       date NOT NULL,           /*计划日                                 */
sre07       number(15,3),            /*计划生产量                             */
sre08       number(15,3),            /*生产顺序                               */
sre09       number(15,3),            /*报工量                                 */
sre10       number(15,3),            /*FQC量                                  */
sre11       number(15,3),            /*完工入库量                             */
sre12       varchar2(1),             /*已调拨否                               */
sre051      varchar2(20),            /*特性代码                               */
sreplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sre_file add  constraint sre_pk primary key  (sre01,sre02,sre03,sre04,sre05,sre06) enable validate;
grant select on sre_file to tiptopgp;
grant update on sre_file to tiptopgp;
grant delete on sre_file to tiptopgp;
grant insert on sre_file to tiptopgp;
grant index on sre_file to public;
grant select on sre_file to ods;
