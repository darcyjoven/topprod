/*
================================================================================
檔案代號:tol_file
檔案名稱:广告合同资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tol_file
(
tol01       varchar2(10) NOT NULL,   /*合约编号                               */
tol02       date,                    /*单据日期                               */
tol03       varchar2(50),            /*合约类型                               */
tol04       varchar2(80),            /*合约说明                               */
tol05       varchar2(10),            /*代理商编号                             */
tol06       date,                    /*广告发布起始日期                       */
tol07       date,                    /*广告发布终止日期                       */
tol08       date,                    /*合约签订日期                           */
tol09       number(20,6),            /*合约金额                               */
tol10       number(20,6),            /*已请款金额                             */
tol11       number(20,6),            /*扣款金额                               */
tol12       varchar2(255),           /*备注                                   */
tol13       varchar2(1),             /*确认码                                 */
tol14       varchar2(1),             /*状态                                   */
tolacti     varchar2(1),             /*资料有效码                             */
toluser     varchar2(10),            /*资料所有者                             */
tolgrup     varchar2(10),            /*资料所有部门                           */
tolmodu     varchar2(10),            /*资料最近更改者                         */
toldate     date,                    /*最近更改日                             */
tolud01     varchar2(255),           /*自订字段-Textedit                      */
tolud02     varchar2(40),            /*自订字段-文字                          */
tolud03     varchar2(40),            /*自订字段-文字                          */
tolud04     varchar2(40),            /*自订字段-文字                          */
tolud05     varchar2(40),            /*自订字段-文字                          */
tolud06     varchar2(40),            /*自订字段-文字                          */
tolud07     number(15,3),            /*自订字段-数值                          */
tolud08     number(15,3),            /*自订字段-数值                          */
tolud09     number(15,3),            /*自订字段-数值                          */
tolud10     number(10),              /*自订字段-整数                          */
tolud11     number(10),              /*自订字段-整数                          */
tolud12     number(10),              /*自订字段-整数                          */
tolud13     date,                    /*自订字段-日期                          */
tolud14     date,                    /*自订字段-日期                          */
tolud15     date,                    /*自订字段-日期                          */
tolorig     varchar2(10),            /*资料建立部门                           */
toloriu     varchar2(10)             /*资料建立者                             */
);

alter table tol_file add  constraint tol_pk primary key  (tol01) enable validate;
grant select on tol_file to tiptopgp;
grant update on tol_file to tiptopgp;
grant delete on tol_file to tiptopgp;
grant insert on tol_file to tiptopgp;
grant index on tol_file to public;
grant select on tol_file to ods;
