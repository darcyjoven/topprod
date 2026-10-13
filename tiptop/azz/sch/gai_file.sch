/*
================================================================================
檔案代號:gai_file
檔案名稱:流程信息批次通知纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gai_file
(
gai01       varchar2(35) NOT NULL,   /*信息号码                               */
                                     /*Message No.($Module_Document No._3-Bit Serial Number)*/
gai02       varchar2(1),             /*等级                                   */
                                     /*Level(A.Urgency B.Import C.Normal D.Notify E.Record)*/
gai03       varchar2(255),           /*信息内容                               */
                                     /*Message Content(Should Contain Prigram No. And Funtion Type)*/
gai04       varchar2(20),            /*建议运行程序编号                       */
gai05       varchar2(255),           /*Mail收件者清单                         */
                                     /*MailReceiver List(Fence Out By Semicolon)*/
gai06       varchar2(255)            /*Mail副本清单                           */
                                     /*Mail Copies List(Fence Out By Semicolon)*/
);

alter table gai_file add  constraint gai_pk primary key  (gai01) enable validate;
grant select on gai_file to tiptopgp;
grant update on gai_file to tiptopgp;
grant delete on gai_file to tiptopgp;
grant insert on gai_file to tiptopgp;
grant index on gai_file to public;
grant select on gai_file to ods;
