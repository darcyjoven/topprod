/*
================================================================================
檔案代號:obn_file
檔案名稱:運輸途徑單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obn_file
(
obn01       varchar2(6),             /*運輸途徑編號                           */
obn02       varchar2(26),            /*說明                                   */
obn03       varchar2(4),             /*運輸方式代碼                           */
obn04       varchar2(10),            /*起始地點                               */
obn05       varchar2(10),            /*目的地點                               */
obnacti     varchar2(1),             /*有效否                                 */
obnuser     varchar2(10),            /*建檔人員                               */
obngrup     varchar2(6),             /*建檔部門                               */
obnmodu     varchar2(10),            /*最后修改人員                           */
obndate     date                     /*最后修改日期                           */
);

create unique index obn_01 on obn_file (obn01);
grant select on obn_file to public;
grant index on obn_file to public;
grant update on obn_file to public;
grant delete on obn_file to public;
grant insert on obn_file to public;
