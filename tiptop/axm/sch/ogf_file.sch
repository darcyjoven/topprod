/*
================================================================================
檔案代號:ogf_file
檔案名稱:多角贸易出货单抛转对应单号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ogf_file
(
ogf00       varchar2(10),            /*来源营运中心编号                       */
                                     /*Source Plant No.                       */
ogf01       varchar2(20) NOT NULL,   /*来源出货单号                           */
                                     /*來源出貨單號                           */
ogf02       varchar2(10),            /*目的营运中心编号                       */
                                     /*Target Plant No.                       */
ogf03       varchar2(20)             /*目的出货单号                           */
                                     /*目的出貨單號                           */
);

alter table ogf_file add  constraint ogf_pk primary key  (ogf01) enable validate;
grant select on ogf_file to tiptopgp;
grant update on ogf_file to tiptopgp;
grant delete on ogf_file to tiptopgp;
grant insert on ogf_file to tiptopgp;
grant index on ogf_file to public;
grant select on ogf_file to ods;
