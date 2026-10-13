/*
================================================================================
檔案代號:abb_file
檔案名稱:会计凭证单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table abb_file
(
abb00       varchar2(5) NOT NULL,    /*帐套                                   */
abb01       varchar2(20) NOT NULL,   /*凭证编号                               */
abb02       number(5) NOT NULL,      /*项次                                   */
abb03       varchar2(24),            /*科目编号                               */
abb04       varchar2(1000),          /*摘要                                   */
abb05       varchar2(10),            /*部门                                   */
abb06       varchar2(1),             /*借贷别                                 */
abb07f      number(20,6),            /*原币金额                               */
abb07       number(20,6) NOT NULL,   /*异动金额                               */
abb08       varchar2(10),            /*项目编号                               */
abb11       varchar2(30),            /*核算项-1                               */
abb12       varchar2(30),            /*核算项-2                               */
abb13       varchar2(30),            /*核算项-3                               */
abb14       varchar2(30),            /*核算项-4                               */
abb15       varchar2(10),            /*预算编号                               */
abb24       varchar2(4),             /*原币币种                               */
abb25       number(20,10),           /*汇率                                   */
abb31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
abb32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
abb33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
abb34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
abb35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
abb36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
abb37       varchar2(30),            /*核算项-关系人                          */
                                     /*#FUN-5C0015                            */
abb41       number(15,3),            /*数量                                   */
abb42       number(20,6),            /*单价                                   */
abb930      varchar2(6),             /*No Use                                 */
abbud01     varchar2(255),           /*自订字段-Textedit                      */
abbud02     varchar2(40),            /*自订字段-文字                          */
abbud03     varchar2(40),            /*自订字段-文字                          */
abbud04     varchar2(40),            /*自订字段-文字                          */
abbud05     varchar2(40),            /*自订字段-文字                          */
abbud06     varchar2(40),            /*自订字段-文字                          */
abbud07     number(15,3),            /*自订字段-数值                          */
abbud08     number(15,3),            /*自订字段-数值                          */
abbud09     number(15,3),            /*自订字段-数值                          */
abbud10     number(10),              /*自订字段-整数                          */
abbud11     number(10),              /*自订字段-整数                          */
abbud12     number(10),              /*自订字段-整数                          */
abbud13     date,                    /*自订字段-日期                          */
abbud14     date,                    /*自订字段-日期                          */
abbud15     date,                    /*自订字段-日期                          */
abblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index abb_03 on abb_file (abb00,abb01,abb03,abb06);
create        index abb_02 on abb_file (abb03);
alter table abb_file add  constraint abb_pk primary key  (abb01,abb02,abb00) enable validate;
grant select on abb_file to tiptopgp;
grant update on abb_file to tiptopgp;
grant delete on abb_file to tiptopgp;
grant insert on abb_file to tiptopgp;
grant index on abb_file to public;
grant select on abb_file to ods;
