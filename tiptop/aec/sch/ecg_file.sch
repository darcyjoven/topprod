/*
================================================================================
檔案代號:ecg_file
檔案名稱:班次档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecg_file
(
ecg01       varchar2(10) NOT NULL,   /*班次编号                               */
ecg02       varchar2(80),            /*说明                                   */
ecg03       varchar2(3),             /*工作时间表                             */
ecg04       varchar2(1),             /*每星期工作天数                         */
ecgacti     varchar2(1),             /*资料有效码                             */
ecguser     varchar2(10),            /*资料所有者                             */
ecggrup     varchar2(10),            /*资料所有群                             */
ecgmodu     varchar2(10),            /*资料更改者                             */
ecgdate     date,                    /*最近更改日                             */
ecgoriu     varchar2(10),            /*资料建立者                             */
ecgorig     varchar2(10),            /*资料建立部门                           */
ecg05       varchar2(8),             /*上班时间                               */
ecg06       varchar2(8)              /*下班时间                               */
);

alter table ecg_file add  constraint ecg_pk primary key  (ecg01) enable validate;
grant select on ecg_file to tiptopgp;
grant update on ecg_file to tiptopgp;
grant delete on ecg_file to tiptopgp;
grant insert on ecg_file to tiptopgp;
grant index on ecg_file to public;
grant select on ecg_file to ods;
