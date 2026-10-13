/*
================================================================================
檔案代號:gat_file
檔案名稱:档案名称多语言对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gat_file
(
gat01       varchar2(15) NOT NULL,   /*档案代码                               */
                                     /* Table No.  (Table name)               */
gat02       varchar2(1) NOT NULL,    /*语言别                                 */
gat03       varchar2(120),           /*档案名称                               */
                                     /* 檔案名稱                              */
gat04       varchar2(255),           /*档案目的                               */
                                     /* Table Purpose                         */
gat05       varchar2(255),           /*备注                                   */
                                     /*Memo(Can Record Table Source And Notice)*/
gat06       varchar2(10),            /*所属模组名称                           */
gat07       varchar2(1)              /*档案类型                               */
);

alter table gat_file add  constraint gat_pk primary key  (gat01,gat02) enable validate;
grant select on gat_file to tiptopgp;
grant update on gat_file to tiptopgp;
grant delete on gat_file to tiptopgp;
grant insert on gat_file to tiptopgp;
grant index on gat_file to public;
grant select on gat_file to ods;
