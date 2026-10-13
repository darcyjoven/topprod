/*
================================================================================
檔案代號:slb_file
檔案名稱:度法基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table slb_file
(
slb01       varchar2(10) DEFAULT ' ' NOT NULL, /*度法代码*/
slb02       varchar2(80),            /*度法说明                               */
slb03       varchar2(80),            /*英文说明                               */
slbacti     varchar2(1),             /*资料有效码                             */
slbdate     date,                    /*最近更改日                             */
slbmodu     varchar2(10),            /*资料更改者                             */
slbuser     varchar2(10),            /*资料所有者                             */
slborig     varchar2(10),            /*资料建立部门                           */
slboriu     varchar2(10)             /*资料建立者                             */
);

alter table slb_file add  constraint slb_pk primary key  (slb01) enable validate;
grant select on slb_file to tiptopgp;
grant update on slb_file to tiptopgp;
grant delete on slb_file to tiptopgp;
grant insert on slb_file to tiptopgp;
grant index on slb_file to public;
grant select on slb_file to ods;
