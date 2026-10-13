/*
================================================================================
檔案代號:tc_aec_file
檔案名稱:仓库对应作业编号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_aec_file
(
tc_aec01    varchar2(10) NOT NULL,   /*仓库编号                               */
tc_aec02    number(5) NOT NULL,      /*项次                                   */
tc_aec03    varchar2(6),             /*作业编号                               */
tc_aec04    varchar2(1),             /*资料有效码                             */
tc_aec05    varchar2(255),           /*no use                                 */
tc_aec06    varchar2(40),            /*no use                                 */
tc_aec07    varchar2(40),            /*no use                                 */
tc_aec08    varchar2(40),            /*no use                                 */
tc_aec09    varchar2(40),            /*no use                                 */
tc_aec10    varchar2(40),            /*no use                                 */
tc_aec11    varchar2(40),            /*no use                                 */
tc_aec12    number(15,3),            /*no use                                 */
tc_aec13    number(15,3),            /*no use                                 */
tc_aec14    number(15,3),            /*no use                                 */
tc_aec15    number(10),              /*no use                                 */
tc_aec16    number(10),              /*no use                                 */
tc_aec17    number(10),              /*no use                                 */
tc_aec18    date,                    /*no use                                 */
tc_aec19    date,                    /*no use                                 */
tc_aec20    date,                    /*no use                                 */
tc_aecuser  varchar2(10),            /*资料所有者                             */
tc_aecgrep  varchar2(10),            /*资料所有群                             */
tc_aecmodu  varchar2(10),            /*资料更改者                             */
tc_aecdate  date                     /*最近更改日                             */
);

alter table tc_aec_file add  constraint tpc_aec_pk primary key  (tc_aec01,tc_aec02) enable validate;
grant select on tc_aec_file to tiptopgp;
grant update on tc_aec_file to tiptopgp;
grant delete on tc_aec_file to tiptopgp;
grant insert on tc_aec_file to tiptopgp;
grant index on tc_aec_file to public;
grant select on tc_aec_file to ods;
