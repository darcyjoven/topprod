/*
================================================================================
檔案代號:fgc_file
檔案名稱:量测仪器校验记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fgc_file
(
fgc01       varchar2(15) NOT NULL,   /*仪器编号                               */
fgc011      number(5) NOT NULL,      /*项次                                   */
fgc02       date,                    /*校验日期                               */
fgc03       varchar2(10) NOT NULL,   /*校验编号                               */
fgc04       varchar2(10),            /*校验人员                               */
fgc05       varchar2(10),            /*校验不良原因                           */
fgc06       varchar2(1),             /*校验结果                               */
fgc07       date                     /*下次校验日                             */
);

alter table fgc_file add  constraint fgc_pk primary key  (fgc01,fgc011,fgc03) enable validate;
grant select on fgc_file to tiptopgp;
grant update on fgc_file to tiptopgp;
grant delete on fgc_file to tiptopgp;
grant insert on fgc_file to tiptopgp;
grant index on fgc_file to public;
grant select on fgc_file to ods;
