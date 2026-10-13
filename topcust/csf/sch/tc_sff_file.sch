/*
================================================================================
檔案代號:tc_sff_file
檔案名稱:申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sff_file
(
tc_sff01    varchar2(20) NOT NULL,   /*申请单号                               */
tc_sff02    number(5) NOT NULL,      /*项次                                   */
tc_sff03    varchar2(40) NOT NULL,   /*工单单号                               */
tc_sff04    varchar2(40),            /*料号                                   */
tc_sff05    number(15,3),            /*发料数量                               */
tc_sff06    varchar2(4),             /*发料单位                               */
tc_sff07    varchar2(6),             /*作业编号                               */
tc_sff08    varchar2(255),           /*备注                                   */
tc_sff09    varchar2(10),            /*理由码                                 */
tc_sffud01  varchar2(255),           /*自订字段-Textedit                      */
tc_sffud02  varchar2(40),            /*是否发料                               */
tc_sffud03  varchar2(40),            /*自订字段-文字                          */
tc_sffud04  varchar2(40),            /*自订字段-文字                          */
tc_sffud05  varchar2(40),            /*自订字段-文字                          */
tc_sffud06  varchar2(40),            /*自订字段-文字                          */
tc_sffud07  number(15,3),            /*自订字段-数值                          */
tc_sffud08  number(15,3),            /*自订字段-数值                          */
tc_sffud09  number(15,3),            /*自订字段-数值                          */
tc_sffud10  number(10),              /*自订字段-整数                          */
tc_sffud11  number(10),              /*自订字段-整数                          */
tc_sffud12  number(10),              /*自订字段-整数                          */
tc_sffud13  date,                    /*自订字段-日期                          */
tc_sffud14  date,                    /*自订字段-日期                          */
tc_sffud15  date,                    /*自订字段-日期                          */
tc_sffplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_sfflegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_sff012   varchar2(10),            /*工艺段号                               */
tc_sff013   number(5),               /*工艺序                                 */
tc_sff014   varchar2(23),            /*Run Card                               */
tc_sff26    varchar2(1),             /*替编号                                 */
tc_sff27    varchar2(40),            /*被替代料号                             */
tc_sff28    number(15,6)             /*替代率                                 */
);

alter table tc_sff_file add  constraint tpc_sff_pk primary key  (tc_sff01,tc_sff02,tc_sff03) enable validate;
grant select on tc_sff_file to tiptopgp;
grant update on tc_sff_file to tiptopgp;
grant delete on tc_sff_file to tiptopgp;
grant insert on tc_sff_file to tiptopgp;
grant index on tc_sff_file to public;
grant select on tc_sff_file to ods;
