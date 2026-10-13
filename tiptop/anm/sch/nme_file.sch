/*
================================================================================
檔案代號:nme_file
檔案名稱:银行存款异动记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nme_file
(
nme00       number(10) DEFAULT '0' NOT NULL, /*电脑编号*/
                                     /*電腦編號                               */
nme01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
nme02       date DEFAULT sysdate,    /*银行日期                               */
                                     /*Bank Date(Actual Bank Inward/Outward Date)*/
                                     /*  If N/P Cashing Account Outward, Auto Create One Row,And The Field Is Blank.But The Field Updated To Actual Bank Inward/Outward Date When Bank Statement.*/
nme021      varchar2(6),             /*No Use                                 */
nme03       varchar2(2) DEFAULT ' ' NOT NULL, /*核算项*/
                                     /*異動碼                                 */
nme04       number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
nme05       varchar2(80),            /*摘要                                   */
nme06       varchar2(24),            /*对方科目                               */
                                     /*對方科目                               */
nme07       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
nme08       number(20,6),            /*本币金额                               */
                                     /*本幣金額                               */
nme09       varchar2(2),             /*调节码                                 */
                                     /*調節碼                                 */
nme10       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
nme11       varchar2(10),            /*收付款理由                             */
nme12       varchar2(20) DEFAULT ' ' NOT NULL, /*参考单号*/
                                     /*參考單號                               */
                                     /*  由應付票據兌現退票轉入時:應付票據單號*/
                                     /*  由應收票據兌現退票轉入時:應收票據單號*/
                                     /*  由銀行存款收支作業轉入時:收支單號    */
nme13       varchar2(40),            /*收支对象简称(厂商/客户/银行)           */
                                     /*收支對象簡稱(廠商/客戶/銀行)           */
nme14       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼                             */
                                     /*反應於現金變動表上的變動分類           */
nme15       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
nme16       date DEFAULT sysdate NOT NULL, /*会计日期*/
                                     /*會計日期                               */
nme17       varchar2(20),            /*应付/应收票据转入时, 储存票            */
                                     /*應付/應收票據轉入時, 儲存票號          */
nme18       number(5),               /*次数　　　                             */
                                     /*次數　　　                             */
                                     /*外匯交易可能分次交割                   */
nme19       varchar2(1),             /*No Use                                 */
nme20       varchar2(1),             /*对帐码                                 */
                                     /*對帳碼 ('Y'表已對帳)                   */
nmeacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
nmeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
nmegrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
nmemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
nmedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
nme061      varchar2(24),            /*对方科目二                             */
nme21       number(5) DEFAULT '0' NOT NULL, /*参考项次*/
nme22       varchar2(2) DEFAULT ' ' NOT NULL, /*交易单据类型*/
                                     /*交易單據類型：                         */
                                     /*01 付款             02 零用金付款      */
                                     /*03 直接付款         04 零用金直接付款  */
                                     /*05 集團調撥         06 集團還本還息    */
                                     /*07 銀行收支         08 直接收款        */
                                     /*09 應收票據         10 應付票據        */
                                     /*11 預購付款         12 預購更改付款    */
                                     /*13 短期融資         14 中長期貸款      */
                                     /*15 信貸還本         16 信貸還息        */
                                     /*17 定期存款單       18 定存到期處理    */
                                     /*19 定存到期處理利息 20 利息收入        */
                                     /*21 外匯買賣         22 投資購買        */
                                     /*23 票券平倉         24 月底重評價      */
                                     /*X  內部帳戶                            */
nme23       varchar2(2),             /*支付类型                               */
                                     /*支付類型：                             */
                                     /*僅針對01,02,03,04,05,06,07需支付單據類型*/
                                     /*01,02,03,04:為付款單單身的性質aph03    */
                                     /*05,06: 01 調撥  02 手續費              */
                                     /*07 為單頭入帳類別nmg20                 */
nme24       varchar2(1),             /*网银支付状态                           */
                                     /*網銀支付狀態                           */
                                     /*0 落地支付成功,                        */
                                     /*1 網銀支付失敗                         */
                                     /*2 網銀支付未明,                        */
                                     /*3 網銀提交成功,                        */
                                     /*4 網銀轉帳成功                         */
                                     /*5 轉支付                               */
                                     /*9 未轉                                 */
nme25       varchar2(15),            /*交易对象编号                           */
nmeud01     varchar2(255),           /*自订字段-Textedit                      */
nmeud02     varchar2(40),            /*自订字段-文字                          */
nmeud03     varchar2(40),            /*自订字段-文字                          */
nmeud04     varchar2(40),            /*自订字段-文字                          */
nmeud05     varchar2(40),            /*自订字段-文字                          */
nmeud06     varchar2(40),            /*自订字段-文字                          */
nmeud07     number(15,3),            /*自订字段-数值                          */
nmeud08     number(15,3),            /*自订字段-数值                          */
nmeud09     number(15,3),            /*自订字段-数值                          */
nmeud10     number(10),              /*自订字段-整数                          */
nmeud11     number(10),              /*自订字段-整数                          */
nmeud12     number(10),              /*自订字段-整数                          */
nmeud13     date,                    /*自订字段-日期                          */
nmeud14     date,                    /*自订字段-日期                          */
nmeud15     date,                    /*自订字段-日期                          */
nme26       varchar2(1),             /*转出码(网银)                           */
nmelegal    varchar2(10) NOT NULL,   /*所属法人                               */
nmeoriu     varchar2(10),            /*资料建立者                             */
nmeorig     varchar2(10),            /*资料建立部门                           */
nme27       varchar2(20) DEFAULT ' ' NOT NULL, /*流水号*/
nme28       date,                    /*网银媒体档转出日期                     */
nme29       varchar2(15)             /*网银媒体档转出批号                     */
);

create        index nme_04 on nme_file (nme17);
create        index nme_01 on nme_file (nme02);
create        index nme_05 on nme_file (nme10);
create        index nme_03 on nme_file (nme12);
create        index nme_02 on nme_file (nme16);
alter table nme_file add  constraint nme_pk primary key  (nme00,nme01,nme03,nme12,nme16,nme21,nme22,nme27) enable validate;
grant select on nme_file to tiptopgp;
grant update on nme_file to tiptopgp;
grant delete on nme_file to tiptopgp;
grant insert on nme_file to tiptopgp;
grant index on nme_file to public;
grant select on nme_file to ods;
