/*
================================================================================
檔案代號:rvn_file
檔案名稱:配送分货明细单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvn_file
(
rvn01       varchar2(20) DEFAULT ' ' NOT NULL, /*配送分货单号*/
rvn02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvn03       varchar2(20),            /*需求单号                               */
rvn04       number(5),               /*需求项次                               */
rvn05       varchar2(1),             /*需求类型                               */
                                     /*Demand Type 1-Replenishment 2-Ordering */
rvn06       varchar2(10),            /*需求营运中心                           */
rvn07       varchar2(10),            /*收货营运中心                           */
rvn08       varchar2(6),             /*线路编号                               */
rvn09       varchar2(40),            /*产品编号                               */
rvn10       number(15,3),            /*本次分贷量                             */
rvn11       varchar2(10),            /*出货仓库                               */
rvn12       varchar2(10),            /*出货营运中心                           */
rvn13       varchar2(8),             /*默认多角流程                           */
rvnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvnplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rvn_file add  constraint rvn_pk primary key  (rvn01,rvn02) enable validate;
grant select on rvn_file to tiptopgp;
grant update on rvn_file to tiptopgp;
grant delete on rvn_file to tiptopgp;
grant insert on rvn_file to tiptopgp;
grant index on rvn_file to public;
grant select on rvn_file to ods;
