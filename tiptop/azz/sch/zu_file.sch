/*
================================================================================
檔案代號:zu_file
檔案名稱:程序运行时间计录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zu_file
(
zu01        varchar2(20),            /*程序编号                               */
                                     /*程式代號                               */
zu02        date,                    /*运行日期                               */
                                     /*執行日期                               */
zu03        varchar2(8),             /*运行时间                               */
                                     /*執行時間                               */
zu04        varchar2(10),            /*用户编号                               */
                                     /*使用者代號                             */
zu05        number(15,3)             /*使用分钟                               */
                                     /*使用分鐘                               */
                                     /*Used minutes                           */
);

create        index zu_01 on zu_file (zu01,zu02);
grant select on zu_file to tiptopgp;
grant update on zu_file to tiptopgp;
grant delete on zu_file to tiptopgp;
grant insert on zu_file to tiptopgp;
grant index on zu_file to public;
grant select on zu_file to ods;
