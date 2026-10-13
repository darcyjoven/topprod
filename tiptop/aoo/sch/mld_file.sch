/*
================================================================================
檔案代號:mld_file
檔案名稱:发件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mld_file
(
mld01       varchar2(20) NOT NULL,   /*邮件档名                               */
                                     /*郵件檔名                               */
mld02       number(5) NOT NULL,      /*顺序                                   */
                                     /*順序                                   */
mld03       varchar2(10) NOT NULL,   /*收件人                                 */
mld04       varchar2(14),            /*拆件时间                               */
                                     /*拆件時間 xx/xx/xx xx:xx                */
mld05       varchar2(1),             /*信件状况                               */
                                     /*Status: C.Closed/D.Delete/L.Log/R.Reply/T.Reject*/
mld06       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld07       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld08       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld09       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld10       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld11       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld12       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mld13       varchar2(80),            /*回覆说明                               */
                                     /*回覆說明                               */
mldplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mldlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table mld_file add  constraint mld_pk primary key  (mld01,mld02,mld03) enable validate;
grant select on mld_file to tiptopgp;
grant update on mld_file to tiptopgp;
grant delete on mld_file to tiptopgp;
grant insert on mld_file to tiptopgp;
grant index on mld_file to public;
grant select on mld_file to ods;
