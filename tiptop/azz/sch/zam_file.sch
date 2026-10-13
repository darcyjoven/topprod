/*
================================================================================
檔案代號:zam_file
檔案名稱:定义查询分群(Group)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zam_file
(
zam01       varchar2(80) NOT NULL,   /*查询单id                               */
zam02       number(5) NOT NULL,      /*序号                                   */
zam03       varchar2(1),             /*group否                                */
zam04       varchar2(1),             /*排序否                                 */
zam05       number(5),               /*排序顺序                               */
zam06       varchar2(255),           /*备注                                   */
zam07       varchar2(1),             /*是否BY Group跳页                       */
zam08       varchar2(1),             /*排序方式                               */
zam09       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zam_file add  constraint zam_pk primary key  (zam01,zam02,zam09) enable validate;
grant select on zam_file to tiptopgp;
grant update on zam_file to tiptopgp;
grant delete on zam_file to tiptopgp;
grant insert on zam_file to tiptopgp;
grant index on zam_file to public;
grant select on zam_file to ods;
