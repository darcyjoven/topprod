/*
================================================================================
檔案代號:nqb_file
檔案名稱:营运中心周转金设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nqb_file
(
nqb01       varchar2(10) NOT NULL,   /*来源营运中心                           */
nqb02       date NOT NULL,           /*日期                                   */
nqb03       number(20,6),            /*周转金额                               */
nqbacti     varchar2(1),             /*资料有效码                             */
nqbuser     varchar2(10),            /*资料所有者                             */
nqbgrup     varchar2(10),            /*资料所有群                             */
nqbmodu     varchar2(10),            /*资料更改者                             */
nqbdate     date,                    /*最近更改日                             */
nqborig     varchar2(10),            /*资料建立部门                           */
nqboriu     varchar2(10)             /*资料建立者                             */
);

alter table nqb_file add  constraint nqb_pk primary key  (nqb01,nqb02) enable validate;
grant select on nqb_file to tiptopgp;
grant update on nqb_file to tiptopgp;
grant delete on nqb_file to tiptopgp;
grant insert on nqb_file to tiptopgp;
grant index on nqb_file to public;
grant select on nqb_file to ods;
