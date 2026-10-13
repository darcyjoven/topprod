/*
================================================================================
檔案代號:gae_file
檔案名稱:画面元件多语言记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gae_file
(
gae01       varchar2(20) NOT NULL,   /*画面档代码                             */
gae02       varchar2(20) NOT NULL,   /*字段代码                               */
gae03       varchar2(1) NOT NULL,    /*语言别                                 */
gae04       varchar2(255),           /*字段名称                               */
gae05       varchar2(1),             /*No Use                                 */
gae06       varchar2(1),             /*No Use                                 */
gae07       varchar2(1),             /*求助文件之已处理码                     */
gae08       varchar2(1),             /*重要字段                               */
gae09       varchar2(20),            /*范例档案                               */
gae10       date,                    /*异动日期                               */
gae11       varchar2(1) NOT NULL,    /*客制码                                 */
gae12       varchar2(10) DEFAULT 'std' NOT NULL /*行业别*/
);

alter table gae_file add  constraint gae_pk primary key  (gae01,gae02,gae03,gae11,gae12) enable validate;
grant select on gae_file to tiptopgp;
grant update on gae_file to tiptopgp;
grant delete on gae_file to tiptopgp;
grant insert on gae_file to tiptopgp;
grant index on gae_file to public;
grant select on gae_file to ods;
