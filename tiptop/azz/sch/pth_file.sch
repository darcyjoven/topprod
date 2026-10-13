/*
================================================================================
檔案代號:pth_file
檔案名稱:客户patch记录档
檔案目的:若客户有上patch时,记录上patch资讯
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table pth_file
(
pth01       varchar2(10) NOT NULL,   /*zl工作单号(zl08)                       */
pth02       varchar2(7),             /*zl版本(zl09)                           */
pth03       date NOT NULL,           /*上patch日期                            */
pth04       varchar2(10),            /*上patch人员                            */
pth05       varchar2(8) NOT NULL,    /*上patch时间                            */
pth06       varchar2(80),            /*patch单号                              */
pth07       varchar2(80)             /*上patch tar档档名                      */
);

alter table pth_file add  constraint pth_pk primary key  (pth01,pth03,pth05) enable validate;
grant select on pth_file to tiptopgp;
grant update on pth_file to tiptopgp;
grant delete on pth_file to tiptopgp;
grant insert on pth_file to tiptopgp;
grant index on pth_file to public;
grant select on pth_file to ods;
