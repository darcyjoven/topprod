/*
================================================================================
檔案代號:abi_file
檔案名稱:凭证项次核算账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abi_file
(
abi00       varchar2(5) NOT NULL,    /*帐套                                   */
abi01       varchar2(20) NOT NULL,   /*凭证编号                               */
abi02       number(5) NOT NULL,      /*项次                                   */
abi03       number(5) NOT NULL,      /*会计年度                               */
abi04       number(5) NOT NULL,      /*期别                                   */
abi05       varchar2(24),            /*会计科目                               */
abi06       date,                    /*凭证日期                               */
abi07       varchar2(10),            /*部门                                   */
abi08       number(20,6),            /*立帐金额                               */
abi09       number(20,6),            /*已冲金额                               */
abi10       varchar2(80),            /*摘要                                   */
abi11       varchar2(30),            /*核算项-1                               */
abi12       varchar2(30),            /*核算项-2                               */
abi13       varchar2(30),            /*核算项-3                               */
abi14       varchar2(30),            /*核算项-4                               */
abi15       varchar2(1),             /*No Use                                 */
abi16       varchar2(1),             /*No Use                                 */
abi31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
abi32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
abi33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
abi34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
abi35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
abi36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
abi37       varchar2(30),            /*No Use                                 */
abilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index abi_02 on abi_file (abi05);
alter table abi_file add  constraint abi_pk primary key  (abi01,abi02,abi00,abi03,abi04) enable validate;
grant select on abi_file to tiptopgp;
grant update on abi_file to tiptopgp;
grant delete on abi_file to tiptopgp;
grant insert on abi_file to tiptopgp;
grant index on abi_file to public;
grant select on abi_file to ods;
