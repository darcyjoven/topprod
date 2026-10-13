/*
================================================================================
檔案代號:gaj_file
檔案名稱:画面元件权限设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gaj_file
(
gaj01       varchar2(20) NOT NULL,   /*程序编号                               */
gaj02       varchar2(20) NOT NULL,   /*字段名称                               */
gaj03       varchar2(250),           /*要显现的群组                           */
gaj04       varchar2(250),           /*要隐藏的群组                           */
gaj05       varchar2(250),           /*要显现的个人                           */
gaj06       varchar2(250),           /*要隐藏的个人                           */
gaj07       varchar2(250),           /*可录入的群组                           */
gaj08       varchar2(250),           /*不可录入的群组                         */
gaj09       varchar2(250),           /*可录入的个人                           */
gaj10       varchar2(250),           /*不可录入的个人                         */
gaj11       varchar2(10) DEFAULT 'std' NOT NULL, /*行业别*/
gaj12       varchar2(1)              /*资料隐藏否                             */
);

alter table gaj_file add  constraint gaj_pk primary key  (gaj01,gaj02,gaj11) enable validate;
grant select on gaj_file to tiptopgp;
grant update on gaj_file to tiptopgp;
grant delete on gaj_file to tiptopgp;
grant insert on gaj_file to tiptopgp;
grant index on gaj_file to public;
grant select on gaj_file to ods;
