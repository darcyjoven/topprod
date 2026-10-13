/*
================================================================================
檔案代號:gah_file
檔案名稱:流程信息纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gah_file
(
gah01       varchar2(35) NOT NULL,   /*信息号码                               */
                                     /*Module_Document No._3-Bit Serial Number*/
gah02       varchar2(80),            /*信息接收人员                           */
                                     /*lib Copy gag_file.gag11                */
gah03       date,                    /*单据生成日期                           */
gah04       varchar2(1),             /*等级                                   */
                                     /*A.Urgency B.Import C.Normal D.Notify E.Record*/
gah05       varchar2(20),            /*单据编号                               */
gah06       varchar2(255),           /*信息内容                               */
gah07       varchar2(20),            /*建议运行程序编号                       */
gah08       date,                    /*处理期限                               */
                                     /*NULL Means No Complete Term            */
gah09       date,                    /*处理完成日期                           */
                                     /*NULL Means Not Complete                */
gah10       varchar2(255),           /*逾期处理时的Mail通知清单               */
                                     /*Fence Out By Semicolon                 */
gah11       varchar2(1),             /*建议运行功能                           */
                                     /*Suggest Executing Function (0. Not Assign, 1. Query, 2. Insert)*/
gah12       varchar2(1)              /*No Use                                 */
);

alter table gah_file add  constraint gah_pk primary key  (gah01) enable validate;
grant select on gah_file to tiptopgp;
grant update on gah_file to tiptopgp;
grant delete on gah_file to tiptopgp;
grant insert on gah_file to tiptopgp;
grant index on gah_file to public;
grant select on gah_file to ods;
