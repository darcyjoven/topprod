/*
================================================================================
檔案代號:gbc_file
檔案名稱:名称多语言对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:Y
============.========================.==========================================
*/
create table gbc_file
(
gbc01       varchar2(15) NOT NULL,   /*档案代码                               */
gbc02       varchar2(20) NOT NULL,   /*字段代码                               */
gbc03       varchar2(255) NOT NULL,  /*KEY 值序列                             */
gbc04       varchar2(1) NOT NULL,    /*语言别                                 */
gbc05       varchar2(100),           /*各语言别下的名称                       */
gbc06       varchar2(1),             /*No Use                                 */
gbc07       varchar2(1)              /*No Use                                 */
);

alter table gbc_file add  constraint gbc_pk primary key  (gbc01,gbc02,gbc03,gbc04) enable validate;
grant select on gbc_file to tiptopgp;
grant update on gbc_file to tiptopgp;
grant delete on gbc_file to tiptopgp;
grant insert on gbc_file to tiptopgp;
grant index on gbc_file to public;
grant select on gbc_file to ods;
