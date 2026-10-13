/*
================================================================================
檔案代號:oby_file
檔案名稱:車輛暫停使用記錄檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table oby_file
(
oby01       varchar2(10),            /*車輛編號                               */
oby02       date,                    /*起始日期                               */
oby03       varchar2(4),             /*起始時間                               */
oby04       date,                    /*截止日期                               */
oby05       varchar2(4),             /*截止時間                               */
oby06       varchar2(40),            /*備註                                   */
obyuser     varchar2(10),            /*資料所有者                             */
obygrup     varchar2(6),             /*資料所有部門                           */
obymodu     varchar2(10),            /*資料修改者                             */
obydate     date                     /*最近修改日                             */
);

create unique index oby_01 on oby_file (oby01,oby02,oby03);
grant select on oby_file to public;
grant index on oby_file to public;
grant update on oby_file to public;
grant delete on oby_file to public;
grant insert on oby_file to public;
