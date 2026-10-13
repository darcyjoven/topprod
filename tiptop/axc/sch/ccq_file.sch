/*
================================================================================
檔案代號:ccq_file
檔案名稱:Idle Item Table
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccq_file
(
ccq01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
ccq02       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
ccq03       number(15,3),            /*库存数量                               */
                                     /*庫存數量                               */
ccq04       number(20,6),            /*库存成本                               */
                                     /*庫存成本                               */
ccq05       date,                    /*最近异动日期                           */
                                     /*最近異動日期                           */
ccq06       varchar2(1),             /*计提L.C.M 时 忽略否                    */
                                     /*提列L.C.M 時 忽略否                    */
                                     /*Y:表SKIP                               */
                                     /*N:表需提列 L.C.M                       */
ccq07       date,                    /*生成日期                               */
                                     /*產生日期                               */
ccq08       varchar2(10),            /*生成者                                 */
                                     /*產生者                                 */
ccq09       number(10),              /*呆滞天数                               */
                                     /*呆滯天數                               */
ccqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ccq_file add  constraint ccq_pk primary key  (ccq01) enable validate;
grant select on ccq_file to tiptopgp;
grant update on ccq_file to tiptopgp;
grant delete on ccq_file to tiptopgp;
grant insert on ccq_file to tiptopgp;
grant index on ccq_file to public;
grant select on ccq_file to ods;
