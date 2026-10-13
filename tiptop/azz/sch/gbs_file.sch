/*
================================================================================
檔案代號:gbs_file
檔案名稱:画面元件多语言备注记录子档
檔案目的:辅助gae_file
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gbs_file
(
gbs01       varchar2(20) NOT NULL,   /*程序编号                               */
gbs02       varchar2(20) NOT NULL,   /*字段代码                               */
gbs03       varchar2(1) NOT NULL,    /*语言别                                 */
gbs04       varchar2(1) NOT NULL,    /*客制码                                 */
gbs05       varchar2(10) DEFAULT 'std' NOT NULL, /*行业别*/
gbs06       varchar2(1500),          /*字段说明                               */
gbs07       varchar2(4000),          /*求助文件之字段说明                     */
gbs08       varchar2(1)              /*no use                                 */
);

alter table gbs_file add  constraint gbs_pk primary key  (gbs01,gbs02,gbs03,gbs04,gbs05) enable validate;
grant select on gbs_file to tiptopgp;
grant update on gbs_file to tiptopgp;
grant delete on gbs_file to tiptopgp;
grant insert on gbs_file to tiptopgp;
grant index on gbs_file to public;
grant select on gbs_file to ods;
