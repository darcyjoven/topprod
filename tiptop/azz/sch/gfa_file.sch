/*
================================================================================
檔案代號:gfa_file
檔案名稱:单据自动化设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gfa_file
(
gfa01       varchar2(1) NOT NULL,    /*单据性质                               */
gfa02       varchar2(5) NOT NULL,    /*单据别                                 */
gfa03       varchar2(20),            /*自动生成的作业                         */
gfa04       varchar2(1),             /*生成方式                               */
gfa05       varchar2(5),             /*自动生成的单据别                       */
gfa06       varchar2(1),             /*自动审核否                             */
gfa07       varchar2(1),             /*是否串联p_flow                         */
gfaacti     varchar2(1),             /*资料有效码                             */
gfadate     date,                    /*最近更改日                             */
gfagrup     varchar2(10),            /*资料所有部门                           */
gfamodu     varchar2(10),            /*资料更改者                             */
gfauser     varchar2(10),            /*资料所有者                             */
gfaorig     varchar2(10),            /*资料建立部门                           */
gfaoriu     varchar2(10)             /*资料建立者                             */
);

alter table gfa_file add  constraint gfa_pk primary key  (gfa01,gfa02) enable validate;
grant select on gfa_file to tiptopgp;
grant update on gfa_file to tiptopgp;
grant delete on gfa_file to tiptopgp;
grant insert on gfa_file to tiptopgp;
grant index on gfa_file to public;
grant select on gfa_file to ods;
