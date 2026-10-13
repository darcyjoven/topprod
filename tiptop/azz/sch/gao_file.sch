/*
================================================================================
檔案代號:gao_file
檔案名稱:模组维护作业档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gao_file
(
gao01       varchar2(10) NOT NULL,   /*模组名称                               */
                                     /*模組代號                               */
gao02       varchar2(20),            /*模组变数值                             */
                                     /*模組變數值                             */
gao03       varchar2(10),            /*可运行程序路径名称                     */
                                     /*可執行程式路徑名稱                     */
gao04       varchar2(20),            /*可运行程序放置路径                     */
gao05       varchar2(1) DEFAULT 'N' NOT NULL /*财务模组否*/
);

alter table gao_file add  constraint gao_pk primary key  (gao01) enable validate;
grant select on gao_file to tiptopgp;
grant update on gao_file to tiptopgp;
grant delete on gao_file to tiptopgp;
grant insert on gao_file to tiptopgp;
grant index on gao_file to public;
grant select on gao_file to ods;
