/*
================================================================================
檔案代號:azf_file
檔案名稱:码别编号说明资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azf_file
(
azf01       varchar2(10) NOT NULL,   /*码别编号                               */
                                     /*碼別代號                               */
azf02       varchar2(1) NOT NULL,    /*码类型                                 */
                                     /*Codes 2/6/8/A/D/E/F/G/H                */
                                     /*2：Reason code 3：Scrap Reason for Bond*/
                                     /*4：Reason Code 5：Deduction Item Code  */
                                     /*6：QC Code     8：Material Category    */
                                     /*A:Withdraw Bonded Material             */
                                     /*D:Other Group Code 1                   */
                                     /*E:Other Group Code 2                   */
                                     /*F：Other Group Code 3                  */
                                     /*G：Cost Group                          */
                                     /*H：Accounting Titles for Reason Codes  */
                                     /*R：Result of Business Request  S：Result of Business Processing*/
                                     /*T：Bank Cart Trans.Type  Z：MO Description Type*/
azf03       varchar2(80),            /*说明内容                               */
                                     /*說明內容                               */
azf04       number(5),               /*保税异动类型                           */
                                     /*保稅異動類別                           */
                                     /*10.廠內生產領用                        */
                                     /*11.廠外加工領用                        */
                                     /*12.外運                                */
                                     /*13.其他領用                            */
                                     /*21.訂單取消                            */
                                     /*22.溢領                                */
                                     /*23.原料不良                            */
                                     /*24.混料                                */
                                     /*25.驗收退料                            */
                                     /*26.倉庫退料                            */
azfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
azfuser     varchar2(10),            /*原始资料建立者                         */
                                     /*原始資料建立者                         */
azfgrup     varchar2(10),            /*用户部门                               */
                                     /*使用者部門                             */
azfmodu     varchar2(10),            /*最后更改资料者                         */
                                     /*最後修改資料者                         */
azfdate     date,                    /*最后更改日期                           */
                                     /*最後修改日期                           */
azf05       varchar2(24),            /*存货差异科目编号                       */
azf06       number(5),               /*成本性质                               */
                                     /*0.Goods 1.Product 2.Semi-Product 3.Raw Material*/
azf07       varchar2(24),            /*会计科目                               */
azf08       varchar2(1),             /*是否列入销售费用                       */
azf051      varchar2(24),            /*存货差异科目编号二                     */
azf09       varchar2(1),             /*用途                                   */
                                     /*1.出貨 2.銷退 3.現返 4.雜項 5.倉退 6.調撥*/
                                     /*for流通配銷                            */
azf10       varchar2(1),             /*是否搭赠                               */
                                     /*for流通配銷                            */
azf11       varchar2(1),             /*是否计算业绩                           */
                                     /*for流通配銷                            */
azf12       varchar2(1),             /*是否影响呆滞日期                       */
                                     /*for流通配銷                            */
azf13       varchar2(1),             /*是否拒收                               */
                                     /*for流通配銷                            */
azf14       varchar2(24),            /*销售费用会计科目                       */
azf15       varchar2(10),            /*No Use                                 */
azf16       varchar2(10),            /*No Use                                 */
azf17       varchar2(30),            /*No Use                                 */
azf18       varchar2(1),             /*品牌类型                               */
azf19       varchar2(10),            /*小类编号                               */
azfpos      varchar2(1) DEFAULT 'N' NOT NULL, /*已传POS否*/
azforig     varchar2(10),            /*资料建立部门                           */
azforiu     varchar2(10),            /*资料建立者                             */
azf071      varchar2(24),            /*会计科目二                             */
azf141      varchar2(24),            /*銷售費用會計科目二                     */
azf20       varchar2(24),            /*主营业务收入科目                       */
azf201      varchar2(24),            /*主营业务收入科目二                     */
azf21       varchar2(24),            /*外销收入科目二                         */
azf211      varchar2(24),            /*外销收入科目二                         */
ta_azf01    number(15,3)             /*生产周期                               */
);

alter table azf_file add  constraint azf_pk primary key  (azf01,azf02) enable validate;
grant select on azf_file to tiptopgp;
grant update on azf_file to tiptopgp;
grant delete on azf_file to tiptopgp;
grant insert on azf_file to tiptopgp;
grant index on azf_file to public;
grant select on azf_file to ods;
