/*
================================================================================
檔案代號:pjt_file
檔案名稱:项目成本异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjt_file
(
pjt01       number(5) NOT NULL,      /*年度                                   */
pjt02       number(5) NOT NULL,      /*期别                                   */
pjt03       varchar2(10) NOT NULL,   /*项目编号                               */
pjt10       number(20,6),            /*本期到款金额                           */
pjt11       number(20,6),            /*本期实际材料成本                       */
pjt12       number(20,6),            /*本期实际其他成本支出                   */
pjt13       number(20,6),            /*本期预提其他成本支出                   */
pjt14       number(20,6),            /*本期总收入                             */
pjt15       number(20,6),            /*本期外部收入                           */
pjt16       number(20,6),            /*本期结转收入                           */
pjt17       number(20,6),            /*本期结转材料成本                       */
pjt18       number(20,6),            /*本期结转其他成本                       */
pjt19       number(20,6),            /*计划总收入                             */
pjt20       number(20,6),            /*计划总材料成本                         */
pjt21       number(20,6),            /*计划总其他成本                         */
pjtdate     date,                    /*最近计算日期                           */
pjttime     varchar2(5),             /*最近计算时间                           */
pjtuser     varchar2(10),            /*最近计算人员                           */
pjtorig     varchar2(10),            /*资料建立部门                           */
pjtoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjt_file add  constraint pjt_pk primary key  (pjt01,pjt02,pjt03) enable validate;
grant select on pjt_file to tiptopgp;
grant update on pjt_file to tiptopgp;
grant delete on pjt_file to tiptopgp;
grant insert on pjt_file to tiptopgp;
grant index on pjt_file to public;
grant select on pjt_file to ods;
