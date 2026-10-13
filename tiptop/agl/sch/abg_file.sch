/*
================================================================================
檔案代號:abg_file
檔案名稱:凭证项次立账异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abg_file
(
abg00       varchar2(5) NOT NULL,    /*帐套                                   */
abg01       varchar2(20) NOT NULL,   /*凭证编号                               */
abg02       number(5) NOT NULL,      /*项次                                   */
abg03       varchar2(24),            /*科目编号                               */
abg04       varchar2(80),            /*摘要                                   */
abg05       varchar2(10),            /*部门                                   */
abg06       date,                    /*凭证日期                               */
abg071      number(20,6) NOT NULL,   /*立帐金额                               */
abg072      number(20,6) NOT NULL,   /*己冲金额                               */
abg073      number(20,6) NOT NULL,   /*预冲金额                               */
abg11       varchar2(30),            /*核算项-1                               */
abg12       varchar2(30),            /*核算项-2                               */
abg13       varchar2(30),            /*核算项-3                               */
abg14       varchar2(30),            /*核算项-4                               */
abg15       varchar2(1),             /*来源                                   */
abg16       varchar2(1),             /*No Use                                 */
abg17       varchar2(1),             /*No Use                                 */
abg31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
abg32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
abg33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
abg34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
abg35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
abg36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
abg37       varchar2(30),            /*No Use                                 */
abglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index abg_02 on abg_file (abg03);
alter table abg_file add  constraint abg_pk primary key  (abg01,abg02,abg00) enable validate;
grant select on abg_file to tiptopgp;
grant update on abg_file to tiptopgp;
grant delete on abg_file to tiptopgp;
grant insert on abg_file to tiptopgp;
grant index on abg_file to public;
grant select on abg_file to ods;
