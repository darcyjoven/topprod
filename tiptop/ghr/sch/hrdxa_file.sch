/*
================================================================================
檔案代號:hrdxa_file
檔案名稱:员工薪资计算明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdxa_file
(
hrdxa01     varchar2(50) NOT NULL,   /*所属薪资月                             */
hrdxa02     varchar2(20) NOT NULL,   /*员工ID                                 */
hrdxa03     varchar2(50),            /*姓名                                   */
hrdxa04     varchar2(20),            /*部门ID                                 */
hrdxa05     varchar2(20),            /*职位ID                                 */
hrdxa06     varchar2(20),            /*申报归属公司ID                         */
hrdxa07     number(5),               /*发薪次数                               */
hrdxa08     number(15,2),            /*应付薪资                               */
hrdxa09     number(15,2),            /*税前薪资                               */
hrdxa10     number(15,2),            /*速算扣除数                             */
hrdxa11     number(15,2),            /*税率                                   */
hrdxa12     number(15,2),            /*个人所得税                             */
hrdxa13     number(15,2),            /*税后薪资                               */
hrdxa14     number(15,2),            /*实付薪资                               */
hrdxa15     number(15,2),            /*固定转账金额                           */
hrdxa16     number(15,2),            /*银行发放金额                           */
hrdxa17     number(15,2),            /*现金发放金额                           */
hrdxa18     number(15,2),            /*上月口零                               */
hrdxa19     number(15,2),            /*本月扣零                               */
hrdxa20     number(15,2),            /*公司退休金提缴金额                     */
hrdxa21     number(15,2),            /*公司上月累计提缴                       */
hrdxa22     varchar2(100) NOT NULL,  /*计算组名称                             */
hrdxa23     number(15,2),            /*固定收入总额                           */
hrdxa24     number(15,2),            /*浮动收入总额                           */
hrdxa25     number(15,2),            /*奖金收入总额                           */
hrdxa26     number(15,2),            /*福利收入总额                           */
hrdxa27     number(15,2)             /*其他收入总额                           */
);

alter table hrdxa_file add  constraint tpc_hrdxa_pk primary key  (hrdxa01,hrdxa02,hrdxa22) enable validate;
grant select on hrdxa_file to tiptopgp;
grant update on hrdxa_file to tiptopgp;
grant delete on hrdxa_file to tiptopgp;
grant insert on hrdxa_file to tiptopgp;
grant index on hrdxa_file to public;
grant select on hrdxa_file to ods;
