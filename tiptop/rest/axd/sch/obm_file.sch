/*
================================================================================
檔案代號:obm_file
檔案名稱:運輸方式檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obm_file
(
obm01       varchar2(4),             /*運輸方式代碼                           */
obm02       varchar2(20),            /*說明                                   */
obmacti     varchar2(1),             /*有效否                                 */
obmuser     varchar2(10),            /*建檔人員                               */
obmgrup     varchar2(6),             /*建檔部門                               */
obmmodu     varchar2(10),            /*最後修改人員                           */
obmdate     date                     /*最後修改日期                           */
);

create unique index obm_01 on obm_file (obm01);
grant select on obm_file to public;
grant index on obm_file to public;
grant update on obm_file to public;
grant delete on obm_file to public;
grant insert on obm_file to public;
