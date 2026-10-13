/*
================================================================================
檔案代號:ada_file
檔案名稱:集團組織單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table ada_file
(
ada01       varchar2(10),            /*上層公司編號                           */
ada02       varchar2(10),            /*在途倉                                 */
adaacti     varchar2(1),             /*資料有效碼                             */
adauser     varchar2(10),            /*資料所有者                             */
adagrup     varchar2(6),             /*資料所有部門                           */
adamodu     varchar2(10),            /*資料修改者                             */
adadate     date                     /*最近修改日                             */
);

create unique index ada_01 on ada_file (ada01);
grant select on ada_file to public;
grant index on ada_file to public;
grant update on ada_file to public;
grant delete on ada_file to public;
grant insert on ada_file to public;
