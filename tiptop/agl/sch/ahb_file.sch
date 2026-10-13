/*
================================================================================
檔案代號:ahb_file
檔案名稱:常用分摊凭证单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ahb_file
(
ahb00       varchar2(5) NOT NULL,    /*帐套                                   */
ahb000      varchar2(1) NOT NULL,    /*性质(1)固定金额常用凭证                */
ahb01       varchar2(20) NOT NULL,   /*原始编号                               */
ahb02       number(5) NOT NULL,      /*项次                                   */
ahb03       varchar2(24),            /*科目编号                               */
ahb04       varchar2(80),            /*摘要                                   */
ahb05       varchar2(10),            /*部门                                   */
ahb06       varchar2(1),             /*借贷别                                 */
ahb07       number(20,6),            /*异动金额 或比率                        */
ahb08       varchar2(10),            /*项目编号                               */
ahb11       varchar2(30),            /*核算项-1                               */
ahb12       varchar2(30),            /*核算项-2                               */
ahb13       varchar2(30),            /*核算项-3                               */
ahb14       varchar2(30),            /*核算项-4                               */
ahb15       varchar2(10),            /*预算编号                               */
ahb16       varchar2(24),            /*变动比率分子科目                       */
ahb31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
ahb32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
ahb33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
ahb34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
ahb35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
ahb36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
ahb37       varchar2(30),            /*关系人异动码                           */
                                     /*#FUN-5C0015                            */
ahbud01     varchar2(255),           /*自订字段-Textedit                      */
ahbud02     varchar2(40),            /*自订字段-文字                          */
ahbud03     varchar2(40),            /*自订字段-文字                          */
ahbud04     varchar2(40),            /*自订字段-文字                          */
ahbud05     varchar2(40),            /*自订字段-文字                          */
ahbud06     varchar2(40),            /*自订字段-文字                          */
ahbud07     number(15,3),            /*自订字段-数值                          */
ahbud08     number(15,3),            /*自订字段-数值                          */
ahbud09     number(15,3),            /*自订字段-数值                          */
ahbud10     number(10),              /*自订字段-整数                          */
ahbud11     number(10),              /*自订字段-整数                          */
ahbud12     number(10),              /*自订字段-整数                          */
ahbud13     date,                    /*自订字段-日期                          */
ahbud14     date,                    /*自订字段-日期                          */
ahbud15     date,                    /*自订字段-日期                          */
ahblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ahb_02 on ahb_file (ahb03);
alter table ahb_file add  constraint ahb_pk primary key  (ahb01,ahb02,ahb00,ahb000) enable validate;
grant select on ahb_file to tiptopgp;
grant update on ahb_file to tiptopgp;
grant delete on ahb_file to tiptopgp;
grant insert on ahb_file to tiptopgp;
grant index on ahb_file to public;
grant select on ahb_file to ods;
