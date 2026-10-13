/*
================================================================================
檔案代號:rmc_file
檔案名稱:RMA 序号明细档(待修品仓)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmc_file
(
rmc01       varchar2(20) NOT NULL,   /*RMA 单号                               */
                                     /*RMA 單號                               */
rmc02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次-ret#                              */
rmc03       number(5),               /*指向rmbfile之项次                      */
                                     /*指向rmbfile之項次                      */
rmc04       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
rmc05       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmc06       varchar2(120),           /*品名                                   */
rmc061      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rmc07       varchar2(15),            /*S/N                                    */
rmc08       date,                    /*修复日期                               */
                                     /*修復日期                               */
rmc09       varchar2(1),             /*是否收费                               */
                                     /*是否收費 : Y/N                         */
rmc10       number(15,3),            /*人工小时                               */
                                     /*人工小時                               */
rmc11       number(9,4),             /*工资率                                 */
                                     /*工資率                                 */
rmc12       number(20,6),            /*人工费用                               */
                                     /*人工費用                               */
rmc13       number(20,6),            /*材料成本费用                           */
                                     /*材料成本費用(由rmd_file加總)           */
rmc14       varchar2(1),             /*修护码                                 */
                                     /*修護碼 : 0/1/2                         */
                                     /*  0 : 未修復                           */
                                     /*  1 : 修復                             */
                                     /*  2 : 不修                             */
                                     /*  3 : 轉銷退                           */
                                     /*  4 : 報廢                             */
                                     /*  5 : 修畢已包裝                       */
                                     /*  6 : 未修已包裝                       */
rmc15       varchar2(15),            /*新S/N : 更换品之S/N                    */
                                     /*新S/N : 更換品之S/N                    */
rmc16       varchar2(1),             /*是否保固                               */
                                     /*是否保固(Y/N)                          */
rmc17       date,                    /*原出货日期                             */
                                     /*原出貨日期                             */
rmc18       number(5),               /*保证期                                 */
                                     /*保証期(天數)                           */
rmc19       number(20,6),            /*应收金额                               */
                                     /*應收金額                               */
rmc21       varchar2(1),             /*除帐码                                 */
                                     /*除帳碼                                 */
                                     /*  0.未除帳                             */
                                     /*  1.覆出除帳                           */
                                     /*  2.轉入銷退除帳                       */
                                     /*  3.報廢除帳                           */
rmc22       date,                    /*除帐日期                               */
                                     /*除帳日期                               */
rmc23       varchar2(20),            /*参考单号                               */
                                     /*參考單號 : 視除帳碼而定                */
                                     /*  1.覆出單號                           */
                                     /*  2.銷退單號                           */
                                     /*  3.報廢單號                           */
rmc231      number(5),               /*销退单批号                             */
                                     /*銷退單批號                             */
rmc24       number(5),               /*参考单项次                             */
                                     /*參考單項次                             */
rmc25       varchar2(5),             /*机型                                   */
                                     /*機型(model)                            */
rmc26       varchar2(20),            /*客户审核单号                           */
                                     /*客戶確認單號(debit notes)              */
rmc27       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
rmc28       number(20,6),            /*预估收费金额                           */
                                     /*預估收費金額                           */
rmc29       date,                    /*审核提出日期                           */
                                     /*確認提出日期                           */
rmc30       date,                    /*回覆审核日期                           */
                                     /*回覆確認日期                           */
rmc31       number(15,3),            /*实收数量                               */
                                     /*實收數量                               */
rmc311      number(15,3),            /*覆出数量                               */
                                     /*覆出數量                               */
rmc312      number(15,3),            /*销退数量                               */
                                     /*銷退數量                               */
rmc313      number(15,3),            /*报废数量                               */
                                     /*報廢數量                               */
rmc32       varchar2(80),            /*额外说明                               */
                                     /*額外說明                               */
rmcud01     varchar2(255),           /*自订字段-Textedit                      */
rmcud02     varchar2(40),            /*自订字段-文字                          */
rmcud03     varchar2(40),            /*自订字段-文字                          */
rmcud04     varchar2(40),            /*自订字段-文字                          */
rmcud05     varchar2(40),            /*自订字段-文字                          */
rmcud06     varchar2(40),            /*自订字段-文字                          */
rmcud07     number(15,3),            /*自订字段-数值                          */
rmcud08     number(15,3),            /*自订字段-数值                          */
rmcud09     number(15,3),            /*自订字段-数值                          */
rmcud10     number(10),              /*自订字段-整数                          */
rmcud11     number(10),              /*自订字段-整数                          */
rmcud12     number(10),              /*自订字段-整数                          */
rmcud13     date,                    /*自订字段-日期                          */
rmcud14     date,                    /*自订字段-日期                          */
rmcud15     date,                    /*自订字段-日期                          */
rmcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index rmc_02 on rmc_file (rmc23,rmc231,rmc24);
create        index rmc_03 on rmc_file (rmc07);
alter table rmc_file add  constraint rmc_pk primary key  (rmc01,rmc02) enable validate;
grant select on rmc_file to tiptopgp;
grant update on rmc_file to tiptopgp;
grant delete on rmc_file to tiptopgp;
grant insert on rmc_file to tiptopgp;
grant index on rmc_file to public;
grant select on rmc_file to ods;
