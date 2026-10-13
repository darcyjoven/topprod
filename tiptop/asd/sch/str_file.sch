/*
================================================================================
檔案代號:str_file
檔案名稱:部门名称资料(成会系统使用)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table str_file
(
str01       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
str02       varchar2(10),            /*部门名称                               */
                                     /*部門名稱                               */
str03       varchar2(80),            /*部门全称                               */
                                     /*部門全稱                               */
str04       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
str05       varchar2(1),             /*部门性质                               */
                                     /*部門性質 1:製造部門 2:服務部門 3:虛擬部*/
str06       varchar2(1),             /*层级                                   */
                                     /*層級                                   */
str07       varchar2(1)              /*最终分摊部门                           */
                                     /*最終分攤部門(Y/N)                      */
);

alter table str_file add  constraint str_pk primary key  (str01) enable validate;
grant select on str_file to tiptopgp;
grant update on str_file to tiptopgp;
grant delete on str_file to tiptopgp;
grant insert on str_file to tiptopgp;
grant index on str_file to public;
grant select on str_file to ods;
