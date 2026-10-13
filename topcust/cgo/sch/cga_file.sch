/*
================================================================================
檔案代號:cga_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table cga_file
(
cga01       varchar2(1000),          /*Go路径                                 */
cga02       varchar2(1000),          /*GCC路径                                */
cga03       varchar2(1000),          /*工作目录                               */
cga04       varchar2(1000),          /*输出目录                               */
cga05       varchar2(100),
cga06       varchar2(100),
cga07       varchar2(100),
cga08       varchar2(100),
cga09       varchar2(100),
cga10       varchar2(100),
cga11       varchar2(100),
cga12       varchar2(100),
cga13       varchar2(100),
cga14       varchar2(100),
cga15       varchar2(100),
cga16       varchar2(100),
cga17       varchar2(100),
cga18       varchar2(100),
cga19       varchar2(100),
cga20       varchar2(100),
cga21       varchar2(100),
cga22       varchar2(100),
cga23       varchar2(100),
cga24       varchar2(100),
cga25       varchar2(100),
cga26       varchar2(100),
cga27       varchar2(100),
cga28       varchar2(100),
cga29       varchar2(100),
cga30       varchar2(100)
);

grant select on cga_file to tiptopgp;
grant update on cga_file to tiptopgp;
grant delete on cga_file to tiptopgp;
grant insert on cga_file to tiptopgp;
grant index on cga_file to public;
grant select on cga_file to ods;
