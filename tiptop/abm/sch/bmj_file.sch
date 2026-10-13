/*
================================================================================
檔案代號:bmj_file
檔案名稱:料件/制造商承认资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmj_file
(
bmj01       varchar2(40) NOT NULL,   /*料件编号                               */
bmj02       varchar2(24) DEFAULT ' ' NOT NULL, /*制造商*/
bmj03       varchar2(10) NOT NULL,   /*供应商                                 */
bmj04       varchar2(40),            /*厂商料号                               */
bmj05       varchar2(10),            /*送样编号                               */
bmj06       date,                    /*送样日期                               */
bmj07       varchar2(10),            /*送样人                                 */
bmj08       varchar2(1),             /*承认状态                               */
bmj09       varchar2(4),             /*No Use                                 */
bmj10       varchar2(10),            /*承认文号                               */
bmj11       date,                    /*承认日期                               */
bmj12       varchar2(255),           /*备注                                   */
bmj13       varchar2(1),             /*No Use                                 */
bmj14       varchar2(1),             /*No Use                                 */
bmj15       varchar2(1),             /*No Use                                 */
bmj99       varchar2(18) DEFAULT ' ',/*No Use                                 */
bmjacti     varchar2(1),             /*资料有效码                             */
bmjuser     varchar2(10),            /*资料所有者                             */
bmjgrup     varchar2(10),            /*资料所有部门                           */
bmjmodu     varchar2(10),            /*资料更改者                             */
bmjdate     date,                    /*最近更改日                             */
bmjorig     varchar2(10),            /*资料建立部门                           */
bmjoriu     varchar2(10)             /*资料建立者                             */
);

alter table bmj_file add  constraint bmj_pk primary key  (bmj01,bmj02,bmj03) enable validate;
grant select on bmj_file to tiptopgp;
grant update on bmj_file to tiptopgp;
grant delete on bmj_file to tiptopgp;
grant insert on bmj_file to tiptopgp;
grant index on bmj_file to public;
grant select on bmj_file to ods;
