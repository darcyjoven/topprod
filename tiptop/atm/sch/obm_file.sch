/*
================================================================================
檔案代號:obm_file
檔案名稱:运输方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obm_file
(
obm01       varchar2(10) NOT NULL,   /*运输方式代码                           */
obm02       varchar2(80),            /*说明                                   */
obmacti     varchar2(1),             /*有效否                                 */
obmuser     varchar2(10),            /*建档人员                               */
obmgrup     varchar2(10),            /*建档部门                               */
obmmodu     varchar2(10),            /*最后更改人员                           */
obmdate     date,                    /*最后更改日期                           */
obmorig     varchar2(10),            /*资料建立部门                           */
obmoriu     varchar2(10)             /*资料建立者                             */
);

alter table obm_file add  constraint obm_pk primary key  (obm01) enable validate;
grant select on obm_file to tiptopgp;
grant update on obm_file to tiptopgp;
grant delete on obm_file to tiptopgp;
grant insert on obm_file to tiptopgp;
grant index on obm_file to public;
grant select on obm_file to ods;
