/*
================================================================================
檔案代號:sgg_file
檔案名稱:留置原因档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgg_file
(
sgg01       varchar2(10) NOT NULL,   /*留置原因编号                           */
sgg02       varchar2(80),            /*留置原因                               */
sggacti     varchar2(1),             /*资料有效码                             */
sgguser     varchar2(10),            /*资料所有者                             */
sgggrup     varchar2(10),            /*资料所有群                             */
sggmodu     varchar2(10),            /*资料更改者                             */
sggdate     date,                    /*最近更改日                             */
sggorig     varchar2(10),            /*资料建立部门                           */
sggoriu     varchar2(10)             /*资料建立者                             */
);

alter table sgg_file add  constraint sgg_pk primary key  (sgg01) enable validate;
grant select on sgg_file to tiptopgp;
grant update on sgg_file to tiptopgp;
grant delete on sgg_file to tiptopgp;
grant insert on sgg_file to tiptopgp;
grant index on sgg_file to public;
grant select on sgg_file to ods;
