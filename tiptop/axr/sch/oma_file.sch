/*
================================================================================
檔案代號:oma_file
檔案名稱:应收/待抵账款单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oma_file
(
oma00       varchar2(2),             /*帐款类型                               */
                                     /*帐款类别                               */
                                     /*(1*:应收帐款, 2*:待抵账款 3*:其他)     */
                                     /*10.待抵账扣费用(流通)                  */
                                     /*11.订金应收,                           */
                                     /*12.出货应收,                           */
                                     /*13.尾款应收,                           */
                                     /*14.杂项应收,                           */
                                     /*15.订金/押金(流通),                    */
                                     /*16.代退款应收,                         */
                                     /*17.应收(流通),                         */
                                     /*18.储值卡订金(流通),                   */
                                     /*19.代收,                               */
                                     /*21.退货折让待抵,                       */
                                     /*22.杂项待抵,                           */
                                     /*23.预收(订金),                         */
                                     /*24.暂收(溢收),                         */
                                     /*25.折扣,                               */
                                     /*26.预收(流通),                         */
                                     /*27.代收应返,                           */
                                     /*28.代退,                               */
                                     /*31.其他应收(不列入应收帐款)            */
oma01       varchar2(20) NOT NULL,   /*帐款编号                               */
                                     /*帳款編號                               */
                                     /* 11.訂金號碼       21.待抵單號         */
                                     /* 12.INVOICE#       22.待抵單號         */
                                     /* 13.INVOICE#2      23.待抵單號         */
                                     /* 14.應收單號       24.待抵單號         */
oma02       date,                    /*帐款日期                               */
                                     /*帳款日期                               */
oma03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號  occ01                    */
                                     /*  MISC: 雜項客戶, 可輸入簡稱           */
oma032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
oma04       varchar2(10),            /*发票客户编号                           */
                                     /*發票客戶編號(9605 No use,請由發票檔維護)*/
oma042      varchar2(20),            /*发票客户税号                           */
                                     /*發票客戶統一編號(9605 No use)          */
oma043      varchar2(80),            /*发票客户全名                           */
                                     /*發票客戶全名(9605 No use)              */
oma044      varchar2(255),           /*发票客户地址                           */
                                     /*發票客戶地址(9605 No use)              */
oma05       varchar2(5),             /*发票别                                 */
                                     /*發票別 (自動開發票時將會依本欄位取簿號)*/
                                     /*  預設'1',輸入時不可空白               */
oma06       varchar2(10),            /*客户分类                               */
                                     /*帳款分類 xx                            */
oma07       varchar2(1),             /*出货是否计入未开发票的销货             */
                                     /*出貨是否計入未開發票的銷貨待驗收入 (Y/N)*/
oma08       varchar2(1),             /*1.内销 2.外销  3.视同外销              */
                                     /*1.Domestic Sales 2.Export Sales 3. As Export Sales*/
oma09       date,                    /*发票日期/折让单日期                    */
                                     /*發票日期/折讓單日期                    */
oma10       varchar2(100),           /*发票号码                               */
                                     /*發票號碼 (於開立發票後更新)ome01       */
oma11       date,                    /*应收款日/应扣抵日                      */
                                     /*應收款日/應扣抵日                      */
oma12       date,                    /*容许票据到期日                         */
                                     /*容許票據到期日/Null                    */
oma13       varchar2(10),            /*科目分类码                             */
                                     /*科目分類碼 ool01                       */
oma14       varchar2(10),            /*人员编号                               */
                                     /*人員編號  gen01                        */
oma15       varchar2(10),            /*部门编号                               */
                                     /*部門編號  gem01                        */
oma16       varchar2(20),            /*订单单号/出货单号                      */
                                     /*訂單單號/出貨單號oea01/oga01           */
                                     /* 11.訂單單號       21.退貨單號         */
                                     /* 12.出貨單號       22.參考單號         */
                                     /* 13.出貨單號       23.原帳單號         */
                                     /* 14.參考單號       24.沖帳單號         */
oma161      number(5),               /*订金应收比率                           */
                                     /*訂金應收比率                           */
oma162      number(5),               /*出货应收比率                           */
                                     /*出貨應收比率                           */
oma163      number(5),               /*尾款应收比率                           */
                                     /*尾款應收比率                           */
oma17       varchar2(1),             /*扣抵区分                               */
                                     /*扣抵區分 (1/2)     No:6374             */
oma171      varchar2(2),             /*格式                                   */
                                     /*格式 (31/32/33/34/35/36)               */
oma172      varchar2(1),             /*课税种                                 */
                                     /*課稅別 (1/2/3)                         */
oma173      number(5),               /*申报年度                               */
                                     /*申報年度(西元)                         */
oma174      number(5),               /*申报月份                               */
                                     /*申報月份                               */
oma175      number(10),              /*申报流水编号                           */
                                     /*申報流水編號                           */
oma18       varchar2(24),            /*科目编号                               */
                                     /*科目編號                               */
                                     /* 11.應收帳款科目   21.應付銷退款科目   */
                                     /* 12.應收帳款科目   22.待抵科目         */
                                     /* 13.應收帳款科目   23.預收科目         */
                                     /* 14.應收帳款科目   24.溢收科目         */
oma19       varchar2(20),            /*待抵帐款-预收单号                      */
                                     /*待抵帳款-預收單號                      */
                                     /*  當帳款類別='11'時: 拋轉成的預收單號  */
                                     /*  當帳款類別='12'時: 須沖帳的原預收單號*/
oma20       varchar2(1),             /*分录底稿是否可重新生成                 */
                                     /*分錄底稿是否可重新產生(Y/N)            */
                                     /*  設為'N'時表示分錄底稿不必產生,       */
                                     /*         或表示分錄底稿有經過人為修改, */
                                     /*         當執行'分錄產生'時, 不可再產生*/
oma21       varchar2(4),             /*税种                                   */
                                     /*稅別        gec01                      */
oma211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)gec04      */
oma212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)gec05      */
oma213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)gec07      */
oma23       varchar2(4),             /*币种                                   */
                                     /*幣別   azi01                           */
oma24       number(20,10),           /*汇率                                   */
                                     /*匯率 (更改時將更新單身本幣單價金額)    */
oma25       varchar2(10),            /*销售分类一                             */
                                     /*銷售分類一 oab01                       */
oma26       varchar2(10),            /*销售分类二                             */
                                     /*銷售分類二 oab01                       */
oma32       varchar2(6),             /*收款条件编号                           */
                                     /*收款條件編號 oag01                     */
oma33       varchar2(20),            /*抛转凭证号                             */
                                     /*拋轉傳票號 npp01                       */
oma34       varchar2(1),             /*销退方式                               */
oma35       varchar2(1),             /*外销方式                               */
oma36       varchar2(40),            /*非经海关证明文件名称                   */
oma37       varchar2(16),            /*非经海关证明文件号码                   */
oma38       varchar2(10),            /*出口报单类型                           */
oma39       varchar2(30),            /*出口报单号码                           */
oma40       varchar2(1),             /*关系人否                               */
oma50       number(20,6) NOT NULL,   /*原币原订金或出货总税前金额             */
                                     /*原幣原訂金或出貨總未稅金額             */
oma50t      number(20,6) NOT NULL,   /*原币原订金或出货总含税金额             */
                                     /*原幣原訂金或出貨總含稅金額             */
oma52       number(20,6) NOT NULL,   /*原币预收订金转销货收入金额             */
                                     /*原幣預收訂金轉銷貨收入金額 / 0         */
oma53       number(20,6) NOT NULL,   /*本币预收订金转销货收入金额             */
                                     /*本幣預收訂金轉銷貨收入金額 / 0         */
oma54       number(20,6) NOT NULL,   /*原币应收税前金额 / 待抵税前            */
                                     /*原幣應收未稅金額 / 待抵未稅            */
oma54x      number(20,6) NOT NULL,   /*原币应收税额  / 待抵税额               */
                                     /*原幣應收稅額     / 待抵稅額            */
oma54t      number(20,6) NOT NULL,   /*原币应收含税金额 / 待抵含税            */
                                     /*原幣應收含稅金額 / 待抵含稅            */
oma55       number(20,6) NOT NULL,   /*原币已冲帐金额                         */
                                     /*原幣已沖帳金額                         */
oma56       number(20,6) NOT NULL,   /*本币应收税前金额 / 待抵税前            */
                                     /*本幣應收未稅金額 / 待抵未稅            */
oma56x      number(20,6) NOT NULL,   /*本币应收税额  / 待抵税额               */
                                     /*本幣應收稅額     / 待抵稅額            */
oma56t      number(20,6) NOT NULL,   /*本币应收含税金额 / 待抵含税            */
                                     /*本幣應收含稅金額 / 待抵含稅            */
oma57       number(20,6) NOT NULL,   /*本币已冲帐金额                         */
                                     /*本幣已沖帳金額                         */
oma58       number(20,10),           /*发票汇率                               */
                                     /*發票匯率 (更改時將更新單身發票單價金額)*/
oma59       number(20,6),            /*本币发票税前金额                       */
                                     /*本幣發票未稅金額                       */
oma59x      number(20,6),            /*本币发票税额                           */
                                     /*本幣發票稅額                           */
oma59t      number(20,6),            /*本币发票含税金额                       */
                                     /*本幣發票含稅金額                       */
oma60       number(20,10),           /*重估汇率                               */
                                     /*重估匯率                               */
oma61       number(20,6),            /*本币未冲金额                           */
                                     /*本幣未沖金額                           */
oma62       varchar2(20),            /*覆出单号                               */
                                     /*覆出單號                     養生NO:7257*/
oma63       varchar2(10),            /*项目编号                               */
                                     /*專案編號                     養生NO:7258*/
oma99       varchar2(17),            /*多角序号                               */
                                     /*多角序號                         No.8161*/
omaconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
omavoid     varchar2(1),             /*作废否                                 */
                                     /*作廢否 (Y/N)                           */
omavoid2    varchar2(10),            /*作废理由码                             */
                                     /*作廢理由碼 oak01,oak03='2'             */
omaprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
omauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
omagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
omamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
omadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oma64       varchar2(1),             /*状况码                                 */
omamksg     varchar2(1),             /*签核否？                               */
oma65       varchar2(1),             /*收款处理(1.转应收帐款 2.直接           */
oma51f      number(20,6),            /*原币直接冲帐金额                       */
oma51       number(20,6),            /*本币直接冲帐金额                       */
oma66       varchar2(10),            /*出货来源营运中心代码                   */
oma67       varchar2(20),            /*商用发票号码                           */
oma930      varchar2(10),            /*成本中心                               */
oma181      varchar2(24),            /*第二科目编码                           */
oma68       varchar2(10),            /*收款客户                               */
oma69       varchar2(40),            /*收款客户简称                           */
oma992      varchar2(20),            /*集团代付单号                           */
                                     /*For 內部帳戶                           */
omaud01     varchar2(255),           /*自订字段-Textedit                      */
omaud02     varchar2(40),            /*自订字段-文字                          */
omaud03     varchar2(40),            /*自订字段-文字                          */
omaud04     varchar2(40),            /*自订字段-文字                          */
omaud05     varchar2(40),            /*自订字段-文字                          */
omaud06     varchar2(40),            /*自订字段-文字                          */
omaud07     number(15,3),            /*自订字段-数值                          */
omaud08     number(15,3),            /*自订字段-数值                          */
omaud09     number(15,3),            /*自订字段-数值                          */
omaud10     number(10),              /*自订字段-整数                          */
omaud11     number(10),              /*自订字段-整数                          */
omaud12     number(10),              /*自订字段-整数                          */
omaud13     date,                    /*自订字段-日期                          */
omaud14     date,                    /*自订字段-日期                          */
omaud15     date,                    /*自订字段-日期                          */
oma70       varchar2(1),             /*来源类型                               */
omalegal    varchar2(10) NOT NULL,   /*所属法人                               */
oma71       varchar2(20),            /*申报税号                               */
omaoriu     varchar2(10),            /*资料建立者                             */
omaorig     varchar2(10),            /*资料建立部门                           */
oma72       varchar2(20),            /*开账来源AR单据号码                     */
oma165      number(5),               /*期别                                   */
oma73       number(20,6) DEFAULT '0' NOT NULL, /*本幣代收*/
oma73f      number(20,6) DEFAULT '0' NOT NULL, /*原幣代收*/
oma74       varchar2(1) DEFAULT '1' NOT NULL, /*开票性质*/
                                     /*1.商场开票, 2.商户开票                 */
oma75       varchar2(20),            /*发票代码                               */
oma76       varchar2(20)             /*开票单号                               */
);

create        index oma_04 on oma_file (oma10);
create        index oma_06 on oma_file (oma33);
create        index oma_02 on oma_file (oma16);
create        index oma99 on oma_file (oma99);
create        index oma_03 on oma_file (oma02);
alter table oma_file add  constraint oma_pk primary key  (oma01) enable validate;
grant select on oma_file to tiptopgp;
grant update on oma_file to tiptopgp;
grant delete on oma_file to tiptopgp;
grant insert on oma_file to tiptopgp;
grant index on oma_file to public;
grant select on oma_file to ods;
