/*
================================================================================
檔案代號:apz_file
檔案名稱:应付账款系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table apz_file
(
apz00       varchar2(1) NOT NULL,    /*KEY, VALUE(0), 隐藏字段                */
                                     /*KEY, VALUE(0), 隱藏欄位                */
apz01       varchar2(1),             /*当前应付帐款系统是否可放给             */
                                     /*目前應付帳款系統是否可放給使用者使用   */
apz02       varchar2(1),             /*是否与会计总帐管理系统相连             */
                                     /*是否與會計總帳管理系統相連             */
apz02p      varchar2(10),            /*总帐管理系统所在营运中心编             */
                                     /*Plant # where AGL is                   */
apz02b      varchar2(5),             /*总帐管理系统使用帐套编号               */
                                     /*總帳管理系統使用帳別編號               */
apz03       varchar2(1),             /*是否与制造管理系统相连                 */
                                     /*是否與製造管理系統相連                 */
apz04       varchar2(1),             /*是否与票据管理系统相连                 */
                                     /*是否與票據管理系統相連                 */
apz04p      varchar2(10),            /*票据管理系统所在营运中心编             */
                                     /*Plant No. where ANM Module is          */
apz05       varchar2(1),             /*付款冲帐时,可否冲销凭证未审            */
                                     /*付款沖帳時,可否沖銷傳票未確認之應付帳款*/
apz06       varchar2(1),             /*付款冲帐时,可否冲销未抛转凭            */
apz07       varchar2(1),             /*发票录入是否检查字首                   */
                                     /*發票輸入是否檢查字軌                   */
apz08       varchar2(1),             /*多发票录入完后更新帐款金额             */
                                     /*多發票輸入完後更新帳款金額             */
                                     /*1.立即更新  2.詢問                     */
apz11       varchar2(1),             /*No Use                                 */
                                     /*No Use                       #No:8727  */
apz12       varchar2(10),            /*发票金额与验收单金额不符时             */
                                     /*發票金額與驗收單金額不符時留置原因碼   */
apz13       varchar2(1),             /*是否依部门区分缺省会计科目             */
                                     /*是否依部門區分預設會計科目(Y/N)        */
apz14       varchar2(1),             /*是否检查营利事业税号                   */
                                     /*是否檢查營利事業統一編號  (Y/N)        */
apz15       varchar2(1),             /*进货金额可否大于发票金额               */
                                     /*進貨金額可否大於發票金額  (Y/N)        */
apz16       varchar2(1),             /*进货发票请款时可否更改进货             */
                                     /*進貨發票請款時可否修改進貨單價(Y/N)    */
apz21       number(5),               /*月底重评价年度                         */
apz22       number(5),               /*月底重评价月份                         */
apz23       varchar2(1),             /*No Use                                 */
apz24       varchar2(1),             /*No Use                                 */
apz25       varchar2(1),             /*请款作业录入营运中心编号否             */
                                     /*Input Plant No. In Billing ?(Y/N)      */
apz26       varchar2(1),             /*付款作业录入营运中心编号否             */
                                     /*Enter Plant No. in Payment task?(Y/N)  */
apz27       varchar2(1),             /*月底重评价当月认列汇差,次月            */
apz31       varchar2(1),             /*进货发票录入时是否自动生成             */
                                     /*進貨發票輸入時是否自動產生分錄(Y/N)    */
apz32       varchar2(1),             /*杂项发票录入时是否自动生成             */
                                     /*雜項發票輸入時是否自動產生分錄(Y/N)    */
apz33       varchar2(1),             /*应付汇率使用类型                       */
                                     /*no use   no.6805                       */
apz34       varchar2(1),             /*预付发票录入时是否自动生成             */
                                     /*預付發票輸入時是否自動產生分錄(Y/N)    */
apz35       varchar2(1),             /*预付C.M.录入时是否自动生成分           */
                                     /*預付C.M.輸入時是否自動產生分錄(Y/N)    */
apz36       varchar2(1),             /*No Use                                 */
apz37       varchar2(1),             /*No Use                                 */
apz38       varchar2(1),             /*No Use                                 */
apz39       varchar2(1),             /*No Use                                 */
apz40       varchar2(1),             /*付款录入时是否自动生成分录             */
                                     /*付款輸入時是否自動產生分錄(Y/N)        */
apz42       varchar2(1),             /*月底重评价分录底稿生成方式             */
                                     /*                 #no.5630 改為 no use  */
                                     /*月底重評價分錄底稿產生方式       NO.A048*/
                                     /* 1.明細  2.彙總  3.依廠商              */
apz43       varchar2(1),             /*应付帐款凭证摘要格式                   */
                                     /*應付帳款傳票摘要格式                   */
                                     /*  0.空白                               */
                                     /*  1.廠商                               */
                                     /*  2.廠商+發票/帳款編號                 */
apz44       varchar2(1),             /*付款冲帐凭证摘要格式                   */
                                     /*付款沖帳傳票摘要格式                   */
                                     /*  0.空白                               */
                                     /*  1.廠商                               */
                                     /*  2.廠商+票據到期日                    */
apz45       number(5),               /*应付帐龄第一段天数                     */
                                     /*應付帳齡第一段天數                     */
apz46       number(5),               /*应付帐龄第二段天数                     */
                                     /*應付帳齡第二段天數                     */
apz47       number(5),               /*应付帐龄第三段天数                     */
                                     /*應付帳齡第三段天數                     */
apz48       number(5),               /*应付帐龄第四段天数                     */
                                     /*應付帳齡第四段天數                     */
apz49       varchar2(4),             /*缺省税种                               */
                                     /*預設稅別                               */
apz50       varchar2(1),             /*自动生成付款单时是否依营运             */
                                     /*Payment Slip by Plant when Auto Gen    */
apz51       varchar2(1),             /*自动生成付款单时是否依帐款             */
                                     /*自動產生付款單時是否依帳款類別區分付款單*/
apz52       varchar2(1),             /*即期支票付款时贷方科目设置             */
                                     /*即期支票付款時貸方科目設定方式         */
                                     /*  1.應付票據                           */
                                     /*  2.銀行存款                           */
apz53       date,                    /*No Use                                 */
                                     /*no use             #no.5054            */
                                     /*發票請款時, 僅可對本日期前的入庫單請款 */
apz54       varchar2(1),             /*杂项发票请款凭证税额摘要格             */
                                     /*雜項發票請款傳票稅額摘要格式           */
                                     /*  0.空白                               */
                                     /*  1.廠商+發票號+日期                   */
apz55       varchar2(1),             /*请款凭证若为立即付款, 贷方             */
                                     /*請款傳票若為立即付款, 貸方摘要格式     */
                                     /*  0.空白                               */
                                     /*  1.廠商+票據到期日                    */
apz56       number(5),               /*结帐日                                 */
                                     /*結帳日                    97/05/07 V3.0*/
apz57       date,                    /*关帐日期                               */
                                     /*關帳日期                  97/05/07 V3.0*/
apz58       varchar2(2),             /*银行出帐异动码                         */
                                     /*銀行出帳異動碼                         */
apz59       varchar2(1),             /*杂项请款单身是否录入MISC资料           */
                                     /*雜項請款單身是否輸入MISC資料           */
apz60       varchar2(1),             /*进货发票审核时是否自动生成             */
                                     /*進貨發票確認時是否自動產生折讓單(Y/N)  */
apz02c      varchar2(5),             /*总帐管理系统使用帐套编号二             */
apz61       varchar2(1),             /*预付金额是够与采购单勾稽               */
apz62       varchar2(1) DEFAULT 'N', /*预付/暂付不做月底重评价                */
apz63       varchar2(20) DEFAULT ' ',/*申报税号                               */
apz64       varchar2(5),             /*默认调帐单别                           */
apz65       varchar2(1) DEFAULT ' ' NOT NULL, /*轉銷科目類型*/
apz66       varchar2(10),            /*转销帐款类型                           */
apz67       varchar2(5),             /*默认溢收单别                           */
apz68       varchar2(1) DEFAULT 'Y' NOT NULL, /*调帐是否走中间过渡科目*/
apzud01     varchar2(255),           /*自订字段                               */
apzud02     varchar2(40),            /*自订字段                               */
apzud03     varchar2(40),            /*自订字段                               */
apzud04     varchar2(40),            /*自订字段                               */
apzud05     varchar2(40),            /*自订字段                               */
apzud06     varchar2(255),           /*自订字段                               */
apzud07     number(15,3),            /*自订字段                               */
apzud08     number(15,3),            /*自订字段                               */
apzud09     number(15,3),            /*自订字段                               */
apzud10     number(10),              /*自订字段                               */
apzud11     number(10),              /*自订字段                               */
apzud12     number(10),              /*自订字段                               */
apzud13     date,                    /*自订字段                               */
apzud14     date,                    /*自订字段                               */
apzud15     date,                    /*自订字段                               */
apz69       varchar2(1) DEFAULT 'N' NOT NULL, /*按照帐款日期生成应付立账汇 */
apz70       varchar2(5),             /*待抵调账单别                           */
apz71       varchar2(10),            /*零用金默认付款条件                     */
apz72       varchar2(20),            /*零用金默认还款银行                     */
apz73       varchar2(2),             /*零用金默认还款异动码                   */
apz74       varchar2(1)              /*是否允许客户立账                       */
);

alter table apz_file add  constraint apz_pk primary key  (apz00) enable validate;
grant select on apz_file to tiptopgp;
grant update on apz_file to tiptopgp;
grant delete on apz_file to tiptopgp;
grant insert on apz_file to tiptopgp;
grant index on apz_file to public;
grant select on apz_file to ods;
