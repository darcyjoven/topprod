/*
================================================================================
檔案代號:obo_file
檔案名稱:運輸途徑單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obo_file
(
obo01       varchar2(16),            /*運輸途徑編號                           */
obo02       number(5),               /*運輸步驟                               */
obo03       varchar2(1),             /*運輸性質                               */
obo04       varchar2(1),             /*運輸方式                               */
obo05       varchar2(10),            /*始起運輸地點                           */
obo06       varchar2(10),            /*目的運輸地點                           */
obo07       number(5,1)              /*耗用天數                               */
);

create unique index obo_01 on obo_file (obo01,obo02);
grant select on obo_file to public;
grant index on obo_file to public;
grant update on obo_file to public;
grant delete on obo_file to public;
grant insert on obo_file to public;
