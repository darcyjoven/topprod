/*
================================================================================
檔案代號:hise_file
檔案名稱:历史资料备份纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hise_file
(
hise01      number(10),              /*序号                                   */
hise02      varchar2(255),           /*进度报告                               */
hise03      number(9,4),             /*当前进度                               */
hise04      varchar2(1)              /*标志位                                 */
);

grant select on hise_file to tiptopgp;
grant update on hise_file to tiptopgp;
grant delete on hise_file to tiptopgp;
grant insert on hise_file to tiptopgp;
grant index on hise_file to public;
grant select on hise_file to ods;
