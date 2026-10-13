/*
================================================================================
檔案代號:gar_file
檔案名稱:信息通知设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gar_file
(
gar01       varchar2(20) NOT NULL,   /*信息编号                               */
                                     /*Message No.(Receipted By + Serial Number)*/
gar02       varchar2(10),            /*信息接收者                             */
gar03       varchar2(1000),          /*信息                                   */
gar04       varchar2(10),            /*信息发送者                             */
gar05       date,                    /*信息生成日期时间                       */
gar06       varchar2(1)              /*是否已发送                             */
);

alter table gar_file add  constraint gar_pk primary key  (gar01) enable validate;
grant select on gar_file to tiptopgp;
grant update on gar_file to tiptopgp;
grant delete on gar_file to tiptopgp;
grant insert on gar_file to tiptopgp;
grant index on gar_file to public;
grant select on gar_file to ods;
