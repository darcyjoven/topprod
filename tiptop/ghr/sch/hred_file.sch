/*
================================================================================
檔案代號:hred_file
檔案名稱:按钮维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hred_file
(
hred01      number(5) NOT NULL,      /*项次                                   */
hred02      varchar2(100),           /*中文名                                 */
hred03      varchar2(100),           /*按钮值                                 */
hred04      varchar2(50),            /*关键字                                 */
hredacti    varchar2(1)              /*资料有效码                             */
);

alter table hred_file add  constraint hred_pk primary key  (hred01) enable validate;
grant select on hred_file to tiptopgp;
grant update on hred_file to tiptopgp;
grant delete on hred_file to tiptopgp;
grant insert on hred_file to tiptopgp;
grant index on hred_file to public;
grant select on hred_file to ods;
