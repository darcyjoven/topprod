/*
================================================================================
檔案代號:bwb_file
檔案名稱:保税工单盘点单头资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bwb_file
(
bwb01       varchar2(20) NOT NULL,   /*标签编号                               */
bwb02       varchar2(20),            /*工单号码                               */
bwb03       varchar2(40),            /*工单成品料号                           */
bwb04       number(15,3),            /*工单待入库量=预计产量-已入             */
bwb011      number(5) NOT NULL,      /*盘点年度                               */
bwb07       varchar2(1),             /*委外工单否                             */
bwbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwb_file add  constraint bwb_pk primary key  (bwb01,bwb011) enable validate;
grant select on bwb_file to tiptopgp;
grant update on bwb_file to tiptopgp;
grant delete on bwb_file to tiptopgp;
grant insert on bwb_file to tiptopgp;
grant index on bwb_file to public;
grant select on bwb_file to ods;
