/*
================================================================================
檔案代號:pjj_file
檔案名稱:网络基本资料设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjj_file
(
pjj01       varchar2(10) NOT NULL,   /*网络代号                               */
pjj02       varchar2(80),            /*网络名称                               */
pjj03       varchar2(1),             /*网络类型                               */
pjj04       varchar2(10),            /*项目编号                               */
pjj05       date,                    /*预计开工日                             */
pjj06       date,                    /*预计完工日                             */
pjj07       date,                    /*系统推算开工日                         */
pjj08       date,                    /*系统推算玩工日                         */
pjj09       date,                    /*实际开工日                             */
pjj10       date,                    /*实际完工日                             */
pjj11       date,                    /*最近推算更新日期                       */
pjjacti     varchar2(1),             /*资料有效码                             */
pjjconf     varchar2(1),             /*确认码                                 */
pjjdate     date,                    /*最近更改日                             */
pjjgrup     varchar2(10),            /*资料所有部门                           */
pjjmodu     varchar2(10),            /*资料更改者                             */
pjjuser     varchar2(10),            /*资料所有者                             */
pjjoriu     varchar2(10),            /*资料建立者                             */
pjjorig     varchar2(10)             /*资料建立部门                           */
);

alter table pjj_file add  constraint pjj_pk primary key  (pjj01) enable validate;
grant select on pjj_file to tiptopgp;
grant update on pjj_file to tiptopgp;
grant delete on pjj_file to tiptopgp;
grant insert on pjj_file to tiptopgp;
grant index on pjj_file to public;
grant select on pjj_file to ods;
