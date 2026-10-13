/*
================================================================================
檔案代號:wsq_file
檔案名稱:EasyFlow 整合设定档(备注档设定)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsq_file
(
wsq01       varchar2(20) NOT NULL,   /*程序编号                               */
wsq02       varchar2(20) NOT NULL,   /*程序使用备注档                         */
wsq03       varchar2(20) NOT NULL,   /*备注档 key 值字段 #1                   */
wsq04       varchar2(20),            /*备注档 key 值字段 #2                   */
wsq05       varchar2(20),            /*备注档 key 值字段 #3                   */
wsq06       varchar2(20),            /*备注档 key 值字段 #4                   */
wsq07       varchar2(20)             /*备注档 key 值字段 #5                   */
);

alter table wsq_file add  constraint wsq_pk primary key  (wsq01) enable validate;
grant select on wsq_file to tiptopgp;
grant update on wsq_file to tiptopgp;
grant delete on wsq_file to tiptopgp;
grant insert on wsq_file to tiptopgp;
grant index on wsq_file to public;
grant select on wsq_file to ods;
