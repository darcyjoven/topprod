/*
================================================================================
檔案代號:oby_file
檔案名稱:车辆暂停使用记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oby_file
(
oby01       varchar2(10) NOT NULL,   /*车辆编号                               */
oby02       date NOT NULL,           /*起始日期                               */
oby03       varchar2(5) NOT NULL,    /*起始时间                               */
oby04       date,                    /*截止日期                               */
oby05       varchar2(5),             /*截止时间                               */
oby06       varchar2(255),           /*备注                                   */
obyuser     varchar2(10),            /*资料所有者                             */
obygrup     varchar2(10),            /*资料所有部门                           */
obymodu     varchar2(10),            /*资料更改者                             */
obydate     date,                    /*最近更改日                             */
obyorig     varchar2(10),            /*资料建立部门                           */
obyoriu     varchar2(10)             /*资料建立者                             */
);

alter table oby_file add  constraint oby_pk primary key  (oby01,oby02,oby03) enable validate;
grant select on oby_file to tiptopgp;
grant update on oby_file to tiptopgp;
grant delete on oby_file to tiptopgp;
grant insert on oby_file to tiptopgp;
grant index on oby_file to public;
grant select on oby_file to ods;
