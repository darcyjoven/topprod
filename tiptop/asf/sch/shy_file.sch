/*
================================================================================
檔案代號:shy_file
檔案名稱:生产日报档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shy_file
(
shy01       varchar2(20) DEFAULT ' ' NOT NULL, /*移转单号*/
shy02       number(5) DEFAULT '0' NOT NULL, /*项次*/
shy03       varchar2(20),            /*工单号码                               */
shy06       number(5),               /*工艺序号                               */
shy07       varchar2(40),            /*料号                                   */
shy08       number(15,3),            /*良品转出量                             */
shy09       number(15,3),            /*当站报废量                             */
shy10       number(15,3),            /*返工转出量                             */
shy11       number(15,3),            /*当站下线量                             */
shy12       number(15,3),            /*加载数量                               */
shy13       number(5),               /*返工转出下工艺序号                     */
shy14       varchar2(10),            /*领料单号                               */
shy15       varchar2(10),            /*入库单号                               */
shy16       number(5),               /*项次                                   */
shy17       varchar2(23),            /*run card                               */
shy18       number(15,3),            /*工单转出量                             */
shy19       varchar2(10),            /*员工编号                               */
shy20       varchar2(20),            /*条形码                                 */
shy21       varchar2(6),             /*作业编号                               */
shy22       varchar2(6),             /*no use                                 */
shy23       varchar2(10),            /*群组编号                               */
shy24       number(5),               /*群组报工序号                           */
shyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table shy_file add  constraint shy_pk primary key  (shy01,shy02) enable validate;
grant select on shy_file to tiptopgp;
grant update on shy_file to tiptopgp;
grant delete on shy_file to tiptopgp;
grant insert on shy_file to tiptopgp;
grant index on shy_file to public;
grant select on shy_file to ods;
