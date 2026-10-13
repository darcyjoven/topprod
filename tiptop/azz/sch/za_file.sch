/*
================================================================================
檔案代號:za_file
檔案名稱:报表标题档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table za_file
(
za01        varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號                               */
za02        number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
za03        varchar2(1) NOT NULL,    /*语言别                                 */
                                     /*語言別(0/1/2)                          */
                                     /*  0:中文                               */
                                     /*  1:英文                               */
                                     /*  2:簡中                               */
za04        varchar2(255),           /*备注                                   */
                                     /*備註                                   */
za05        varchar2(80)             /*标题内容                               */
                                     /*標題內容                               */
);

alter table za_file add  constraint za_pk primary key  (za01,za02,za03) enable validate;
grant select on za_file to tiptopgp;
grant update on za_file to tiptopgp;
grant delete on za_file to tiptopgp;
grant insert on za_file to tiptopgp;
grant index on za_file to public;
grant select on za_file to ods;
