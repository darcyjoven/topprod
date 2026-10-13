/*
================================================================================
檔案代號:bgz_file
檔案名稱:预算管理系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgz_file
(
bgz00       varchar2(1) NOT NULL,    /*KEY VALUE                              */
                                     /*KEY, VALUE(0), 隱藏欄位                */
bgz01       varchar2(1),             /*预估汇率是否做版本控管                 */
                                     /*預估匯率是否做版本控管                 */
bgz02       varchar2(1),             /*材料预估是否做版本控管                 */
                                     /*材料預估是否做版本控管                 */
bgz03       varchar2(1),             /*采购单价来源                           */
                                     /*採購單價來源                           */
                                     /*1.料件主檔 2.材料成本 3.料件/供應商    */
bgz04       varchar2(1),             /*人工制费分摊基础                       */
                                     /*人工製費分攤基礎                       */
                                     /*1.生產量 2.料件標準工時                */
bgz10       varchar2(24),            /*销货收入会计科目                       */
                                     /*銷貨收入會計科目                       */
bgz11       varchar2(24),            /*销货成本会计科目                       */
                                     /*銷貨成本會計科目                       */
bgz12       varchar2(24),            /*制成品会计科目                         */
                                     /*製成品會計科目                         */
bgz13       varchar2(24),            /*原料会计科目                           */
                                     /*原料會計科目                           */
bgz14       number(5),               /*预算年度                               */
                                     /*預算年度                               */
bgz15       number(5),               /*预计调幅                               */
                                     /*預計調幅                               */
bgz16       number(5),               /*调薪起始月份                           */
                                     /*調薪起始月份                           */
bgz17       number(5),               /*费用分摊第一季分配权数                 */
                                     /*費用分攤第一季分配權數                 */
bgz18       number(5),               /*费用分摊第二季分配权数                 */
                                     /*費用分攤第二季分配權數                 */
bgz19       number(5),               /*费用分摊第三季分配权数                 */
                                     /*費用分攤第三季分配權數                 */
bgz20       number(5),               /*费用分摊第四季分配权数                 */
                                     /*費用分攤第四季分配權數                 */
bgz21       varchar2(6),             /*加班时薪计算基础费用项目一             */
                                     /*加班時薪計算基礎費用項目一             */
bgz22       varchar2(6),             /*加班时薪计算基础费用项目二             */
                                     /*加班時薪計算基礎費用項目二             */
bgz23       varchar2(6),             /*加班时薪计算基础费用项目三             */
                                     /*加班時薪計算基礎費用項目三             */
bgz24       varchar2(6),             /*加班时薪计算基础费用项目四             */
                                     /*加班時薪計算基礎費用項目四             */
bgz25       varchar2(6),             /*加班时薪计算基础费用项目五             */
                                     /*加班時薪計算基礎費用項目五             */
bgz26       varchar2(6),             /*加班时薪计算基础费用项目六             */
                                     /*加班時薪計算基礎費用項目六             */
bgz27       varchar2(6),             /*未超时加班费用项目                     */
                                     /*未超時加班費用項目                     */
bgz28       number(9,4),             /*未超时加班费用倍率                     */
                                     /*未超時加班費用倍率                     */
bgz29       varchar2(6),             /*超时加班费用项目                       */
                                     /*超時加班費用項目                       */
bgz30       number(9,4),             /*超时加班费用倍率                       */
                                     /*超時加班費用倍率                       */
bgz31       number(5),               /*月薪换算时薪除以天数                   */
                                     /*月薪換算時薪除以天數                   */
bgz32       number(5),               /*月薪换算时薪除以一天的小时             */
bgz33       varchar2(6),             /*基本工资费用项目                       */
                                     /*底薪費用項目                           */
bgz34       varchar2(6),             /*劳保费费用项目                         */
                                     /*勞保費費用項目                         */
bgz35       varchar2(6),             /*健保费费用项目                         */
                                     /*健保費費用項目                         */
bgz36       varchar2(24),            /*应付帐款                               */
                                     /*應付帳款    03/10/23    No.8563        */
bgzud01     varchar2(255),           /*自订字段                               */
bgzud02     varchar2(40),            /*自订字段                               */
bgzud03     varchar2(40),            /*自订字段                               */
bgzud04     varchar2(40),            /*自订字段                               */
bgzud05     varchar2(40),            /*自订字段                               */
bgzud06     varchar2(255),           /*自订字段                               */
bgzud07     number(15,3),            /*自订字段                               */
bgzud08     number(15,3),            /*自订字段                               */
bgzud09     number(15,3),            /*自订字段                               */
bgzud10     number(10),              /*自订字段                               */
bgzud11     number(10),              /*自订字段                               */
bgzud12     number(10),              /*自订字段                               */
bgzud13     date,                    /*自订字段                               */
bgzud14     date,                    /*自订字段                               */
bgzud15     date                     /*自订字段                               */
);

alter table bgz_file add  constraint bgz_pk primary key  (bgz00) enable validate;
grant select on bgz_file to tiptopgp;
grant update on bgz_file to tiptopgp;
grant delete on bgz_file to tiptopgp;
grant insert on bgz_file to tiptopgp;
grant index on bgz_file to public;
grant select on bgz_file to ods;
