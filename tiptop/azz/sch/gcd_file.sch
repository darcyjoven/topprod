/*
================================================================================
檔案代號:gcd_file
檔案名稱:资料上传下载单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcd_file
(
gcd01       varchar2(10) NOT NULL,   /*格式代码                               */
gcd02       number(5) NOT NULL,      /*序号                                   */
gcd03       varchar2(1),             /*资料格式                               */
gcd04       varchar2(15),            /*表格名称                               */
gcd05       varchar2(255),           /*资料内容                               */
gcd06       varchar2(1),             /*是否使用条件式                         */
gcd07       varchar2(20),            /*群组                                   */
gcd08       varchar2(20),            /*起始位置                               */
gcd09       varchar2(20),            /*截止位置                               */
gcd10       varchar2(1)              /*资料排列                               */
);

alter table gcd_file add  constraint gcd_pk primary key  (gcd01,gcd02) enable validate;
grant select on gcd_file to tiptopgp;
grant update on gcd_file to tiptopgp;
grant delete on gcd_file to tiptopgp;
grant insert on gcd_file to tiptopgp;
grant index on gcd_file to public;
grant select on gcd_file to ods;
