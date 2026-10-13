/*
================================================================================
檔案代號:rmr_file
檔案名稱:RMA序号资料客诉问题明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmr_file
(
rmr01       varchar2(20) NOT NULL,   /*RMA单号                                */
                                     /*RMA單號                                */
rmr02       number(5) NOT NULL,      /*RET No.                                */
                                     /*RET#                                   */
rmr03       number(5) NOT NULL,      /*行号                                   */
                                     /*行號                                   */
rmr04       varchar2(255),           /*问题内容                               */
                                     /*問題內容                               */
rmrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmrlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmr_file add  constraint rmr_pk primary key  (rmr01,rmr02,rmr03) enable validate;
grant select on rmr_file to tiptopgp;
grant update on rmr_file to tiptopgp;
grant delete on rmr_file to tiptopgp;
grant insert on rmr_file to tiptopgp;
grant index on rmr_file to public;
grant select on rmr_file to ods;
