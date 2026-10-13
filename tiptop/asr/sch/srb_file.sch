/*
================================================================================
檔案代號:srb_file
檔案名稱:机台(生产线)维修基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table srb_file
(
srb01       date NOT NULL,           /*维修日期                               */
srb02       varchar2(10) NOT NULL,   /*机台生产线                             */
srb03       varchar2(5) NOT NULL,    /*维修开始时间                           */
srb04       varchar2(5) NOT NULL,    /*维修结束时间                           */
srb05       number(15,3),            /*维修时数                               */
srb06       varchar2(10),            /*维修人员                               */
srbacti     varchar2(1)              /*有效否                                 */
);

alter table srb_file add  constraint srb_pk primary key  (srb01,srb02,srb03,srb04) enable validate;
grant select on srb_file to tiptopgp;
grant update on srb_file to tiptopgp;
grant delete on srb_file to tiptopgp;
grant insert on srb_file to tiptopgp;
grant index on srb_file to public;
grant select on srb_file to ods;
