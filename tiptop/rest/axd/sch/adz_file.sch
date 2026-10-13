/*
================================================================================
檔案代號:adz_file
檔案名稱:流通配銷系統單據性質檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adz_file
(
adzslip     varchar2(5),             /*單別                                   */
adzdesc     varchar2(40),            /*單據名稱                               */
adzauno     varchar2(1),             /*自動編號否                             */
adzconf     varchar2(1),             /*自動確認                               */
adzprnt     varchar2(1),             /*立即列印否                             */
adzdmy6     varchar2(1),             /*1.依流水號                             */
adztype     varchar2(2),             /*單據性質                               */
adz11       varchar2(1),             /*是否影響呆滯日期                       */
adzapr      varchar2(1),             /*是否簽核                               */
adzsign     varchar2(4)              /*簽核等級                               */
);

create unique index adz_01 on adz_file (adzslip);
grant select on adz_file to public;
grant index on adz_file to public;
grant update on adz_file to public;
grant delete on adz_file to public;
grant insert on adz_file to public;
