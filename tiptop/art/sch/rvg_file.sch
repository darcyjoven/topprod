/*
================================================================================
檔案代號:rvg_file
檔案名稱:对账销售单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvg_file
(
rvg00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
                                     /*Doc. Type                              */
rvg01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
rvg02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvg03       varchar2(10),            /*营运中心                               */
rvg04       varchar2(1),             /*类型                                   */
                                     /*Type 1-Shipping 2-Sales Return         */
rvg05       varchar2(20),            /*出货/销退单号                          */
rvg06       number(5),               /*出/退项次                              */
rvg07       varchar2(1),             /*对账否                                 */
rvg08       number(15,3),            /*对账数量                               */
rvglegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvgplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rvg_file add  constraint rvg_pk primary key  (rvg00,rvg01,rvg02) enable validate;
grant select on rvg_file to tiptopgp;
grant update on rvg_file to tiptopgp;
grant delete on rvg_file to tiptopgp;
grant insert on rvg_file to tiptopgp;
grant index on rvg_file to public;
grant select on rvg_file to ods;
