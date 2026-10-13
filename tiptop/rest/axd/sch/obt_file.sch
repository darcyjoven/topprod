/*
================================================================================
檔案代號:obt_file
檔案名稱:車輛型號檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obt_file
(
obt01       varchar2(16),            /*車輛廠牌                               */
obt02       varchar2(20),            /*車輛型號                               */
obt03       varchar2(30)             /*說明                                   */
);

create unique index obt_01 on obt_file (obt01,obt02);
grant select on obt_file to public;
grant index on obt_file to public;
grant update on obt_file to public;
grant delete on obt_file to public;
grant insert on obt_file to public;
