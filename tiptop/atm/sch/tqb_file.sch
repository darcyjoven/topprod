/*
================================================================================
檔案代號:tqb_file
檔案名稱:组织机构资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqb_file
(
tqb01       varchar2(10) NOT NULL,   /*组织编号                               */
tqb02       varchar2(80) NOT NULL,   /*组织名称                               */
tqb03       varchar2(10) NOT NULL,   /*组织类别                               */
tqbacti     varchar2(1),             /*有效否                                 */
tqbuser     varchar2(10),            /*资料所有者                             */
tqbgrup     varchar2(10),            /*资料所有部门                           */
tqbmodu     varchar2(10),            /*资料更改者                             */
tqbdate     date,                    /*最后更改日期                           */
tqb04       varchar2(1),             /*是否记录营运中心                       */
tqb05       varchar2(10),            /*营运中心代码                           */
tqboriu     varchar2(10),            /*资料建立者                             */
tqborig     varchar2(10)             /*资料建立部门                           */
);

alter table tqb_file add  constraint tqb_pk primary key  (tqb01) enable validate;
grant select on tqb_file to tiptopgp;
grant update on tqb_file to tiptopgp;
grant delete on tqb_file to tiptopgp;
grant insert on tqb_file to tiptopgp;
grant index on tqb_file to public;
grant select on tqb_file to ods;
