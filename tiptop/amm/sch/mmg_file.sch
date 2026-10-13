/*
================================================================================
檔案代號:mmg_file
檔案名稱:开发运行单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmg_file
(
mmg01       varchar2(20) NOT NULL,   /*开发运行单编号                         */
                                     /*開發執行單編號(開發案號)               */
mmg02       varchar2(20) NOT NULL,   /*运行工单编号                           */
mmg03       varchar2(1),             /*模治具类型                             */
                                     /*1:治具 2:塑模 3:沖模 4:其他            */
mmg04       varchar2(40),            /*料件编号                               */
                                     /*料件編號   ima01                       */
                                     /*儲存該開發執行單將投入生產料件         */
mmg05       varchar2(2),             /*工作性质                               */
                                     /*工作性質 mmi01,mmi03='1'               */
mmg06       date,                    /*开立日期                               */
mmg07       date,                    /*需求日期                               */
mmg08       date,                    /*结案日期                               */
mmg09       varchar2(10),            /*需求部门                               */
mmg10       number(15,3) NOT NULL,   /*生产数量                               */
                                     /*Production Quantity/ Forecast Input Quantity/The unit is*/
                                     /*the production unit                    */
                                     /*Style     (21,22,23,24,25,26,27,28,29)        (31,32,33,34,35,36)*/
mmg11       number(15,3) NOT NULL,   /*制品预定送样数量                       */
mmg12       varchar2(16),            /*图别                                   */
                                     /*圖別                                   	 */
mmg121      varchar2(10),            /*版别                                   */
mmg13       date,                    /*产品结构指定有效日期                   */
                                     /*產品結構指定有效日期                   */
mmg14       varchar2(1),             /*开发运行单结案状态                     */
                                     /*開發執行單結案狀態 (Y/N)               */
mmg15       varchar2(10),            /*预计开发运行单相关零件完工             */
mmg16       varchar2(10),            /*预计开发运行单完工入库库位             */
mmg17       number(9,4),             /*完工比率(%)                            */
mmg18       number(20,6),            /*已耗费用                               */
                                     /*To Spend Expenses = SUM(Transferred Part Processing Price * Qty)*/
mmg19       number(15,3),            /*已耗工时                               */
                                     /*To Spend Work Hours = SUM(Transferred Part Processing Work Hours * Qty)*/
mmg191      number(20,6),            /*工时费用                               */
                                     /*Work Hours Expense = SUM(Transferred Part Processing Work Hours * Qty * Wage)*/
mmg20       varchar2(20),            /*模具穴数                               */
mmg21       varchar2(40),            /*制品料号                               */
                                     /*製品料號 ima01 儲存該模治具會產出之產品*/
mmg22       varchar2(255),           /*备注                                   */
mmg23       varchar2(4),             /*生产单位                               */
mmgacti     varchar2(1),             /*确认码                                 */
                                     /*Confirm Valid  Y/N/X                   */
mmguser     varchar2(10),            /*资料所有者 系统维护                    */
                                     /*Data Owener System Maintain            */
mmggrup     varchar2(10),            /*资料所有群 系统维护                    */
                                     /*Data Group System Maintain             */
mmgmodu     varchar2(10),            /*资料更改者 系统维护                    */
                                     /*Data Modified By System Maimtain       */
mmgdate     date,                    /*最近更改日 系统维护                    */
                                     /*Latest Modified Date System Maintain   */
mmgud01     varchar2(255),           /*自订字段-Textedit                      */
mmgud02     varchar2(40),            /*自订字段-文字                          */
mmgud03     varchar2(40),            /*自订字段-文字                          */
mmgud04     varchar2(40),            /*自订字段-文字                          */
mmgud05     varchar2(40),            /*自订字段-文字                          */
mmgud06     varchar2(40),            /*自订字段-文字                          */
mmgud07     number(15,3),            /*自订字段-数值                          */
mmgud08     number(15,3),            /*自订字段-数值                          */
mmgud09     number(15,3),            /*自订字段-数值                          */
mmgud10     number(10),              /*自订字段-整数                          */
mmgud11     number(10),              /*自订字段-整数                          */
mmgud12     number(10),              /*自订字段-整数                          */
mmgud13     date,                    /*自订字段-日期                          */
mmgud14     date,                    /*自订字段-日期                          */
mmgud15     date,                    /*自订字段-日期                          */
mmgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmglegal    varchar2(10) NOT NULL,   /*所属法人                               */
mmgoriu     varchar2(10),            /*资料建立者                             */
mmgorig     varchar2(10)             /*资料建立部门                           */
);

create        index mmg_02 on mmg_file (mmg04);
alter table mmg_file add  constraint mmg_pk primary key  (mmg01,mmg02) enable validate;
grant select on mmg_file to tiptopgp;
grant update on mmg_file to tiptopgp;
grant delete on mmg_file to tiptopgp;
grant insert on mmg_file to tiptopgp;
grant index on mmg_file to public;
grant select on mmg_file to ods;
