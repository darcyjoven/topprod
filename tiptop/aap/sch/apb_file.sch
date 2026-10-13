/*
================================================================================
檔案代號:apb_file
檔案名稱:应付账款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table apb_file
(
apb01       varchar2(20) NOT NULL,   /*帐款单号                               */
                                     /*帳款單號 apa01                         */
apb02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
apb03       varchar2(10),            /*收货营运中心                           */
                                     /*Goods Received Plant                   */
apb04       varchar2(20),            /*验收单号                               */
                                     /*驗收單號 rva01(rvb01)                  */
apb05       number(5),               /*验收项次                               */
                                     /*驗收項次       rvb02                   */
apb06       varchar2(20),            /*采购单号                               */
                                     /*採購單號 pmm01(pmn01)                  */
apb07       number(5),               /*采购单项次                             */
                                     /*採購單項次     pmn02                   */
apb08       number(20,6),            /*本币单价                               */
                                     /*本幣單價(未稅)                         */
apb081      number(20,6),            /*成本分摊本币单价                       */
                                     /*成本分攤本幣單價(未稅) #No.+005 010514 */
apb09       number(15,3),            /*数量                                   */
                                     /*數量                                   */
apb10       number(20,6),            /*本币金额                               */
                                     /*本幣金額(未稅)                         */
apb101      number(20,6),            /*成本分摊本币金额                       */
                                     /*成本分攤本幣金額(未稅) #No.+005 010514 */
apb11       varchar2(1000),          /*原发票号码                             */
                                     /*原發票號碼 (帳款類別為'21'時可輸入)apa08*/
                                     /*29時輸入進項海關退還代徵營業稅 no:7393 */
apb12       varchar2(40),            /*料号                                   */
                                     /*料號 (from pmn04)                      */
apb13f      number(20,6),            /*原币折让单价                           */
                                     /*原幣折讓單價(僅為差異調整用)           */
apb13       number(20,6),            /*本币折让单价                           */
                                     /*本幣折讓單價(僅為差異調整用)           */
apb14f      number(20,6),            /*原币折让金额                           */
                                     /*原幣折讓金額(僅為差異調整用)           */
apb14       number(20,6),            /*本币折让金额                           */
                                     /*本幣折讓金額(僅為差異調整用)           */
apb15       number(15,3),            /*折让数量                               */
                                     /*折讓數量(僅為差異調整用)               */
apb16       varchar2(1),             /*是否生成折让单                         */
                                     /*是否產生折讓單                         */
apb21       varchar2(20),            /*入库单号                               */
                                     /*入庫單號,退貨單號,       rvu01(rvv01), */
                                     /*專案費用代號             pjd03         */
apb22       number(5),               /*项次                                   */
                                     /*項次                     rvv02         */
apb23       number(20,6),            /*原币单价                               */
                                     /*原幣單價                               */
apb24       number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
apb25       varchar2(24),            /*会计科目                               */
                                     /*會計科目(當apa51='STOCK'時有意義)aag01 */
apb26       varchar2(10),            /*部门                                   */
                                     /*部門    gem01                          */
apb27       varchar2(120),           /*品名                                   */
apb28       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
apb29       varchar2(1),             /*异动类型                               */
                                     /*異動類別 (1.入庫 2.驗退 3.倉退)rvu00/rvv*/
apb30       varchar2(10),            /*预算编号                               */
                                     /*預算編號 (For 請採購預算)              */
apb31       varchar2(10),            /*项目费用编号                           */
apb930      varchar2(10),            /*成本中心                               */
apb251      varchar2(24),            /*会计科目二                             */
apb32       varchar2(10),            /*员工编号                               */
apb33       varchar2(80),            /*报销明细说明                           */
apb34       varchar2(1),             /*暂估否                                 */
apb35       varchar2(10),            /*项目编号                               */
apb36       varchar2(30),            /*WBS编码                                */
apbud01     varchar2(255),           /*自订字段-Textedit                      */
apbud02     varchar2(40),            /*自订字段-文字                          */
apbud03     varchar2(40),            /*自订字段-文字                          */
apbud04     varchar2(40),            /*自订字段-文字                          */
apbud05     varchar2(40),            /*自订字段-文字                          */
apbud06     varchar2(40),            /*自订字段-文字                          */
apbud07     number(15,3),            /*自订字段-数值                          */
apbud08     number(15,3),            /*自订字段-数值                          */
apbud09     number(15,3),            /*自订字段-数值                          */
apbud10     number(10),              /*自订字段-整数                          */
apbud11     number(10),              /*自订字段-整数                          */
apbud12     number(10),              /*自订字段-整数                          */
apbud13     date,                    /*自订字段-日期                          */
apbud14     date,                    /*自订字段-日期                          */
apbud15     date,                    /*自订字段-日期                          */
apblegal    varchar2(10) NOT NULL,   /*所属法人                               */
apb37       varchar2(10)             /*资料来源工厂                           */
);

create        index apb_03 on apb_file (apb21,apb22);
create        index apb_04 on apb_file (apb06,apb07);
create        index apb_02 on apb_file (apb04,apb05);
alter table apb_file add  constraint apb_pk primary key  (apb01,apb02) enable validate;
grant select on apb_file to tiptopgp;
grant update on apb_file to tiptopgp;
grant delete on apb_file to tiptopgp;
grant insert on apb_file to tiptopgp;
grant index on apb_file to public;
grant select on apb_file to ods;
