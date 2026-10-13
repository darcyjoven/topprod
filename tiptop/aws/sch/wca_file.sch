/*
================================================================================
檔案代號:wca_file
檔案名稱:spc 集成设置主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wca_file
(
wca01       varchar2(20) NOT NULL,   /*程序编号                               */
wca02       varchar2(1) NOT NULL,    /*是否为 hard code 程序                  */
wca03       varchar2(1),             /*No Use                                 */
wca04       varchar2(1),             /*No Use                                 */
wca05       varchar2(1),             /*No Use                                 */
wcaacti     varchar2(1),             /*资料有效码                             */
wcauser     varchar2(10),            /*资料所有者                             */
wcagrup     varchar2(10),            /*资料所有群                             */
wcamodu     varchar2(10),            /*资料更改者                             */
wcadate     date,                    /*最近更改日                             */
wcaorig     varchar2(10),            /*资料建立部门                           */
wcaoriu     varchar2(10)             /*资料建立者                             */
);

alter table wca_file add  constraint wca_pk primary key  (wca01) enable validate;
grant select on wca_file to tiptopgp;
grant update on wca_file to tiptopgp;
grant delete on wca_file to tiptopgp;
grant insert on wca_file to tiptopgp;
grant index on wca_file to public;
grant select on wca_file to ods;
