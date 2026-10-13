/*
================================================================================
檔案代號:bhd_file
檔案名稱:部门分摊异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bhd_file
(
bhd01       varchar2(10) NOT NULL,   /*版本                                   */
bhd02       number(5) NOT NULL,      /*年度                                   */
bhd03       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
bhd04       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
bhd05       varchar2(6) NOT NULL,    /*分摊类型                               */
                                     /*Apportionment Category,Depreciation Always Be Anticipated Depreciation insert*/
                                     /*Labor Expense Using                    */
                                     /*Sales Reve '@@@@@1'                    */
                                     /*Sales Cost '@@@@@2'                    */
                                     /*Manu. Cost '@@@@@3'                    */
                                     /*Purs. Cost '@@@@@4'                    */
                                     /*Labor Exp. '@@@@@5'                    */
                                     /*Depreciation     'Depreciation'        */
bhd06       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bhd07       varchar2(24),            /*会计科目                               */
                                     /*會計科目                               */
bhd08       varchar2(10),            /*被分摊部门                             */
                                     /*被分攤部門                             */
bhd09       number(20,6)             /*分摊金额                               */
                                     /*分攤金額                               */
);

alter table bhd_file add  constraint bhd_pk primary key  (bhd01,bhd02,bhd03,bhd04,bhd05,bhd06) enable validate;
grant select on bhd_file to tiptopgp;
grant update on bhd_file to tiptopgp;
grant delete on bhd_file to tiptopgp;
grant insert on bhd_file to tiptopgp;
grant index on bhd_file to public;
grant select on bhd_file to ods;
