/*
================================================================================
檔案代號:pjz_file
檔案名稱:项目管理系统参数设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table pjz_file
(
pjz01       number(10),              /*WBS首段码长                            */
pjz02       number(10),              /*WBS其他段码长                          */
pjz03       number(10),              /*WBS最大段数                            */
pjz04       number(10),              /*网络编号长度                           */
pjz05       number(10)               /*活动编号长度                           */
);

grant select on pjz_file to tiptopgp;
grant update on pjz_file to tiptopgp;
grant delete on pjz_file to tiptopgp;
grant insert on pjz_file to tiptopgp;
grant index on pjz_file to public;
grant select on pjz_file to ods;
