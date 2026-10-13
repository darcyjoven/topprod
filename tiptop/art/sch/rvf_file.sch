/*
================================================================================
檔案代號:rvf_file
檔案名稱:对账入库单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvf_file
(
rvf00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
                                     /*Doc. Type                              */
rvf01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
rvf02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvf03       varchar2(10),            /*营运中心                               */
rvf04       varchar2(1),             /*类型                                   */
                                     /*Type 1-Stock-in 2-Return               */
rvf05       varchar2(20),            /*入库/仓退单号                          */
rvf06       number(5),               /*入/退项次                              */
rvf07       varchar2(1),             /*对账否                                 */
rvf08       number(15,3),            /*对账数量                               */
rvflegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvfplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rvf_file add  constraint rvf_pk primary key  (rvf00,rvf01,rvf02) enable validate;
grant select on rvf_file to tiptopgp;
grant update on rvf_file to tiptopgp;
grant delete on rvf_file to tiptopgp;
grant insert on rvf_file to tiptopgp;
grant index on rvf_file to public;
grant select on rvf_file to ods;
