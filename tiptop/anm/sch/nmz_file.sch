/*
================================================================================
檔案代號:nmz_file
檔案名稱:票据系统参数档(一)
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table nmz_file
(
nmz00       varchar2(1) NOT NULL,    /*KEY, VALUE(0), 隐藏字段                */
                                     /*KEY, VALUE(0), 隱藏欄位                */
nmz01       varchar2(1),             /*当前票据系统是否可放给用户             */
                                     /*目前票據系統是否可放給使用者使用       */
nmz02       varchar2(1),             /*是否与总帐会计系统相连                 */
                                     /*是否與總帳會計系統相連                 */
nmz02p      varchar2(10),            /*总帐会计系统所在营运中心编             */
                                     /*總帳會計系統所在工廠編號               */
nmz02b      varchar2(5),             /*总帐会计系统使用帐套编号               */
                                     /*總帳會計系統使用帳別編號               */
nmz03       varchar2(1),             /*银行收支维护是否检查收状单             */
                                     /*銀行收支維護是否檢查收狀單號           */
nmz04       varchar2(1),             /*银行存款出帐汇率缺省方式               */
                                     /*銀行存款出帳匯率預設方式               */
                                     /*  1.移動平均匯率 2.每日/月匯率         */
nmz05       varchar2(1),             /*付款单是否要抛转凭证才可生             */
                                     /*付款單是否要拋轉傳票才可產生應付票據   */
nmz06       varchar2(1),             /*应付票据兑现时银行日期是否             */
                                     /*應付票據兌現時銀行日期是否等於會計日期 */
nmz07       varchar2(1),             /*应付票据部门是否可为空白               */
                                     /*應付票據部門是否可為空白               */
nmz08       varchar2(1),             /*应收票据部门是否可为空白               */
                                     /*應收票據部門是否可為空白               */
nmz09       varchar2(1),             /*月底重评价分录底稿生成方式             */
nmz10       date,                    /*关帐日期                               */
nmz11       varchar2(1),             /*是否依部门区分缺省会计科目             */
                                     /*是否依部門區分預設會計科目(Y/N)        */
nmz12       number(5),               /*No Use                                 */
                                     /*no use       no.6856                   */
nmz13       date,                    /*No Use                                 */
                                     /*no use       no.6856                   */
nmz14       number(5),               /*未付款发票追索天数                     */
                                     /*未付款發票追索天數                     */
nmz15       number(5),               /*未请款进货追索天数                     */
                                     /*未請款進貨追索天數                     */
nmz16       number(5),               /*未进货采购追索天数                     */
                                     /*未進貨採購追索天數                     */
nmz17       number(5),               /*未收款发票追索天数                     */
                                     /*未收款發票追索天數                     */
nmz18       number(5),               /*未开发票出货追索天数                   */
                                     /*未開發票出貨追索天數                   */
nmz19       number(5),               /*未出货销单追索天数                     */
                                     /*未出貨銷單追索天數                     */
nmz20       varchar2(1),             /*银行存款月底重评价当月认列             */
                                     /*Cash in Bank Sprd Apprvd in EOM Revalu.,Un-Rev. Nx. Mon.*/
nmz21       number(5),               /*银行存款月底重评价年度                 */
nmz22       number(5),               /*银行存款月底重评价月份                 */
nmz23       number(5),               /*应收票据呆帐计提第一期天数             */
                                     /*應收票據呆帳提列第一期天數             */
nmz24       number(5),               /*应收票据呆帐计提第二期天数             */
                                     /*應收票據呆帳提列第二期天數             */
nmz25       number(5),               /*应收票据呆帐计提第三期天数             */
                                     /*應收票據呆帳提列第三期天數             */
nmz26       number(5),               /*应收票据呆帐计提第四期天数             */
                                     /*應收票據呆帳提列第四期天數             */
nmz27       number(9,4),             /*应收票据呆帐计提第一期比率             */
                                     /*應收票據呆帳提列第一期比率             */
nmz28       number(9,4),             /*应收票据呆帐计提第二期比率             */
                                     /*應收票據呆帳提列第二期比率             */
nmz29       number(9,4),             /*应收票据呆帐计提第三期比率             */
                                     /*應收票據呆帳提列第三期比率             */
nmz30       number(9,4),             /*应收票据呆帐计提第四期比率             */
                                     /*應收票據呆帳提列第四期比率             */
nmz31       varchar2(2),             /*应付票据兑现异动码(贷)                 */
                                     /*應付票據兌現異動碼(貸)                 */
nmz32       varchar2(2),             /*应付票据退票异动码(借)                 */
                                     /*應付票據退票異動碼(借)                 */
nmz33       varchar2(2),             /*应收票据兑现异动码(借)                 */
                                     /*應收票據兌現異動碼(借)                 */
nmz34       varchar2(2),             /*应收票据退票异动码(贷)                 */
                                     /*應收票據退票異動碼(貸)                 */
nmz35       varchar2(2),             /*银行存款汇差利得调整异动码             */
                                     /*銀行存款匯差調整異動碼                 */
nmz36       varchar2(2),             /*应收票据汇差调整异动码                 */
                                     /*應收票據匯差調整異動碼                 */
nmz37       varchar2(2),             /*应付票据汇差调整异动码                 */
                                     /*應付票據匯差調整異動碼                 */
nmz38       varchar2(2),             /*应付票据未兑现调节码                   */
                                     /*應付票據未兌現調節碼                   */
nmz39       varchar2(2),             /*外汇交割手续费异动码                   */
                                     /*外匯交割手續費異動碼                   */
nmz40       varchar2(1),             /*No Use                                 */
nmz41       number(5),               /*银行存款现行年度                       */
                                     /*銀行存款現行年度                       */
nmz42       number(5),               /*银行存款现行月份                       */
                                     /*銀行存款現行月份                       */
nmz51       varchar2(5),             /*整批支票付款缺省开票单别               */
                                     /*整批支票付款預設開票單別               */
nmz52       varchar2(1),             /*融资暂估利息,次月回转否                */
nmz53       varchar2(2),             /*银行存款汇差损失调整异动码             */
                                     /*銀行存款匯差損失調整異動碼             */
nmz54       varchar2(4),             /*付款支票抬头取厂商联络人类             */
                                     /*付款支票抬頭取廠商聯絡人類別           */
nmz55       varchar2(4),             /*整批支票付款缺省现金变动码             */
                                     /*整批支票付款預設現金變動碼             */
nmz56       number(20,6),            /*单笔定存利息代扣所得税之界             */
nmz57       number(9,4),             /*定存利息代扣所得税之百分比             */
nmz58       varchar2(24),            /*代扣所得税会计科目                     */
nmz59       varchar2(10),            /*应收票据月底重评价当月认列             */
                                     /*N/R Sprd Apprvd in EOM Revalu.,Un-Rev. Nx. Mon.*/
nmz60       number(5),               /*应收票据月底重评价年度                 */
nmz61       number(5),               /*应收票据月底重评价月份                 */
nmz62       varchar2(10),            /*应收票据月底重评价分录底稿             */
                                     /*Mode of NR Revaluated Draft NO.A05     */
                                     /* 1.Details  2.Account summary  3.According to customers*/
nmz63       varchar2(10),            /*应付票据月底重评价当月认列             */
                                     /*N/R Sprd Apprvd in EOM Revalu.,Un-Rev. Nx. Mon.*/
nmz64       number(5),               /*应付票据月底重评价年度                 */
nmz65       number(5),               /*应付票据月底重评价月份                 */
nmz66       varchar2(10),            /*应付票据月底重评价分录底稿             */
                                     /*Mode of NR Revaluated Draft NO.A05 1.Detail 2.Account No. 3.By Vender*/
nmz67       varchar2(10),            /*No Use                                 */
nmz68       varchar2(10),            /*No Use                                 */
nmz69       varchar2(10),            /*No Use                                 */
nmz02c      varchar2(5),             /*总帐管理系统使用预设帐别二             */
nmz581      varchar2(24),            /*定存代扣所得税科目二                   */
nmz70       varchar2(1) DEFAULT ' ' NOT NULL, /*現金流量表來源*/
nmzud01     varchar2(255),           /*自订字段                               */
nmzud02     varchar2(40),            /*自订字段                               */
nmzud03     varchar2(40),            /*自订字段                               */
nmzud04     varchar2(40),            /*自订字段                               */
nmzud05     varchar2(40),            /*自订字段                               */
nmzud06     varchar2(255),           /*自订字段                               */
nmzud07     number(15,3),            /*自订字段                               */
nmzud08     number(15,3),            /*自订字段                               */
nmzud09     number(15,3),            /*自订字段                               */
nmzud10     number(10),              /*自订字段                               */
nmzud11     number(10),              /*自订字段                               */
nmzud12     number(10),              /*自订字段                               */
nmzud13     date,                    /*自订字段                               */
nmzud14     date,                    /*自订字段                               */
nmzud15     date,                    /*自订字段                               */
nmz71       varchar2(1) DEFAULT 'Y' NOT NULL, /*是否启用现金流量表功能*/
nmz72       varchar2(1) DEFAULT '2' NOT NULL, /*现金变动码输入控制*/
nmz73       varchar2(4)              /*现金变动码                             */
);

alter table nmz_file add  constraint nmz_pk primary key  (nmz00) enable validate;
grant select on nmz_file to tiptopgp;
grant update on nmz_file to tiptopgp;
grant delete on nmz_file to tiptopgp;
grant insert on nmz_file to tiptopgp;
grant index on nmz_file to public;
grant select on nmz_file to ods;
