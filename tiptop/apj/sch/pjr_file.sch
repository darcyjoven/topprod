/*
================================================================================
檔案代號:pjr_file
檔案名稱:wbs/活动分类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjr_file
(
pjr00       varchar2(1) NOT NULL,    /*类型                                   */
pjr01       varchar2(4) NOT NULL,    /*类型编号                               */
pjr02       varchar2(80),            /*类型名称                               */
pjracti     varchar2(1),             /*有效                                   */
pjrdate     date,                    /*最近更改日                             */
pjrgrup     varchar2(10),            /*资料所有部门                           */
pjrmodu     varchar2(10),            /*资料更改者                             */
pjruser     varchar2(10),            /*资料所有者                             */
pjrorig     varchar2(10),            /*资料建立部门                           */
pjroriu     varchar2(10)             /*资料建立者                             */
);

alter table pjr_file add  constraint pjr_pk primary key  (pjr00,pjr01) enable validate;
grant select on pjr_file to tiptopgp;
grant update on pjr_file to tiptopgp;
grant delete on pjr_file to tiptopgp;
grant insert on pjr_file to tiptopgp;
grant index on pjr_file to public;
grant select on pjr_file to ods;
