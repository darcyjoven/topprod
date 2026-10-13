/*
================================================================================
檔案代號:occ_file
檔案名稱:客户主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table occ_file
(
occ01       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
occ02       varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                               */
occ03       varchar2(10),            /*客户分类                               */
                                     /*客戶分類                               */
occ04       varchar2(10),            /*负责业务员编号                         */
                                     /*負責業務員編號                         */
occ05       varchar2(1),             /*1.永久性 2.暂时性                      */
                                     /*1.永久性 2.暫時性                      */
occ06       varchar2(1),             /*性质                                   */
                                     /*性質 (1.買受人 2.送貨客戶 3.收款客戶)  */
occ07       varchar2(10),            /*收款客户编号                           */
                                     /*收款客戶編號                           */
occ08       varchar2(5),             /*惯用发票别                             */
                                     /*慣用發票別                             */
occ09       varchar2(10),            /*送货客户编号                           */
                                     /*送貨客戶編號                           */
occ10       varchar2(1),             /*No Use                                 */
occ11       varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
occ12       date,                    /*创业日                                 */
                                     /*創 業 日                               */
occ13       number(20,6),            /*资 本 额                               */
                                     /*資 本 額                               */
occ14       number(20,6),            /*年营业额                               */
                                     /*年營業額                               */
occ15       number(15),              /*员工人数                               */
                                     /*員工人數                               */
occ16       date,                    /*初次交易日                             */
occ171      date,                    /*最近交易日-报价日                      */
                                     /*最近交易日-報價日 (系統自動更新)       */
occ172      date,                    /*最近交易日-接单日                      */
                                     /*最近交易日-接單日 (系統自動更新)       */
occ173      date,                    /*最近交易日-出货日                      */
                                     /*最近交易日-出貨日 (系統自動更新)       */
occ174      date,                    /*最近交易日-收款日                      */
                                     /*最近交易日-收款日 (系統自動更新)       */
occ175      date,                    /*信用额度有效日期                       */
                                     /*信用額度有效日期(for tiptop40)         */
occ18       varchar2(80),            /*公司全名(1)                            */
occ19       varchar2(80),            /*公司全名(2)                            */
occ20       varchar2(10),            /*区域编号                               */
                                     /*區域編號                               */
occ21       varchar2(10),            /*国家编号                               */
                                     /*國別編號                               */
occ22       varchar2(10),            /*地区别                                 */
occ231      varchar2(255),           /*发票地址-1                             */
                                     /*發票地址-1                             */
occ232      varchar2(255),           /*发票地址-2                             */
                                     /*發票地址-2                             */
occ233      varchar2(255),           /*发票地址-3                             */
                                     /*發票地址-3                             */
occ241      varchar2(255),           /*送货地址-1                             */
                                     /*送貨地址-1                             */
occ242      varchar2(255),           /*送货地址-2                             */
                                     /*送貨地址-2                             */
occ243      varchar2(255),           /*送货地址-3                             */
                                     /*送貨地址-3                             */
occ261      varchar2(40),            /*TEL NO-1                               */
occ262      varchar2(40),            /*TEL NO-2                               */
occ263      varchar2(40),            /*TEL NO-3                               */
occ271      varchar2(40),            /*FAX NO-1                               */
occ272      varchar2(40),            /*FAX NO-2                               */
occ273      varchar2(40),            /*FAX NO-2                               */
occ28       varchar2(40),            /*公司负责人                             */
                                     /*公司負責人                             */
occ29       varchar2(40),            /*业务联络人                             */
                                     /*業務聯絡人                             */
occ292      varchar2(5),             /*业务联络人分机号码                     */
                                     /*業務聯絡人分機號碼                     */
occ30       varchar2(40),            /*财务联络人                             */
                                     /*財務聯絡人                             */
occ302      varchar2(5),             /*财务联络人分机号码                     */
                                     /*財務聯絡人分機號碼                     */
occ31       varchar2(1),             /*客户销售库存管理否                     */
occ32       number(9,4),             /*最大折扣率                             */
occ33       varchar2(10),            /*额度客户                               */
occ34       varchar2(10),            /*集团码                                 */
                                     /*集團碼                                 */
occ35       varchar2(10),            /*邮递区号                               */
                                     /*郵遞區號(for top40)             99/04/30*/
occ36       number(5),               /*宽限天数                               */
                                     /*寬限天數(for top40)             99/04/30*/
occ37       varchar2(1),             /*是否为关系人                           */
                                     /*是否為關係人(Y/N)                      */
occ38       varchar2(2),             /*客户月结日                             */
                                     /*客戶月結日                             */
occ39       varchar2(2),             /*客户付款日                             */
                                     /*客戶付款日                             */
occ39a      varchar2(2),             /*客户付款日二                           */
                                     /*客戶付款日二(for top40)         99/05/12*/
occ40       varchar2(1),             /*月底重评价                             */
                                     /*Regarded as Home Currency AR(Y/N)      */
                                     /*  Enter Account By Original currency ,But Regarded as Home Currency AR For Dollar-Quotation But Home Currency-Payment Customer. Not To Adjust Spread End Of Month*/
occ41       varchar2(4),             /*惯用税种                               */
                                     /*慣用稅別                               */
occ42       varchar2(4),             /*惯用币种                               */
                                     /*慣用幣別                               */
occ43       varchar2(10),            /*惯用销售分类                           */
                                     /*慣用銷售分類                           */
occ44       varchar2(6),             /*惯用价格条件                           */
                                     /*慣用價格條件                           */
occ45       varchar2(6),             /*惯用收款条件                           */
                                     /*慣用收款條件                           */
occ46       varchar2(80),            /*惯用其它条件                           */
                                     /*慣用其它條件                           */
occ47       varchar2(10),            /*惯用交运方式                           */
                                     /*慣用交運方式                           */
occ48       varchar2(10),            /*惯用起运港口                           */
                                     /*慣用起運港口                           */
occ49       varchar2(10),            /*惯用到达港口                           */
                                     /*慣用到達港口                           */
occ50       varchar2(10),            /*惯用卸货港口                           */
                                     /*慣用卸貨港口(for tiptop40)      99/04/30*/
occ51       varchar2(10),            /*惯用FORWARDER                          */
                                     /*慣用FORWARDER(客戶編號)                */
occ52       varchar2(10),            /*惯用NOTIFY                             */
                                     /*慣用NOTIFY(for tiptop40)        99/04/30*/
occ53       number(5),               /*惯用佣金率%                            */
                                     /*慣用佣金率%                            */
occ55       varchar2(1),             /*惯用文件打印语言                       */
                                     /*慣用文件列印語言 (0.中文 1.英文)       */
occ56       varchar2(1),             /*须出货通知单否                         */
                                     /*須出貨通知單否 (Y/N)                   */
occ57       varchar2(1),             /*须制作包装单否                         */
                                     /*須製作包裝單否 (Y/N)                   */
occ61       varchar2(10),            /*信用评等                               */
                                     /*信用評等                               */
occ62       varchar2(1),             /*信用检查否                             */
                                     /*信用查核否 (Y/N)                       */
occ63       number(20,6),            /*信用额度                               */
                                     /*信用額度                               */
occ631      varchar2(4),             /*额度币种                               */
                                     /*額度幣別(for tiptop40)          99/04/30*/
occ64       number(5),               /*信用额度容许超出比率                   */
                                     /*信用額度容許超出比率%                  */
occ701      varchar2(255),           /*备注-1                                 */
                                     /*備註-1                          genero */
occ702      varchar2(255),           /*备注-2                                 */
                                     /*No use                          genero */
occ703      varchar2(255),           /*备注-3                                 */
                                     /*No use                          genero */
occ704      varchar2(255),           /*备注-4                                 */
                                     /*No use                          genero */
occacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
occuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
occgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
occmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
occdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
occ65       varchar2(1),             /*客户出货签收否                         */
occ1001     date,                    /*营业职照有效开始日期                   */
occ1002     date,                    /*营业职照失效开始日期                   */
occ1003     varchar2(10),            /*所属业态                               */
occ1004     varchar2(1),             /*状态码                                 */
occ1005     varchar2(10),            /*所属机构                               */
occ1006     varchar2(10),            /*所属通路                               */
occ1007     varchar2(10),            /*系统码                                 */
occ1008     varchar2(10),            /*系统区域码                             */
occ1009     varchar2(10),            /*省份/特区                              */
occ1010     varchar2(10),            /*地市级/区                              */
occ1011     varchar2(10),            /*区/县/市                               */
occ1012     varchar2(255),           /*实际公司地址                           */
occ1013     varchar2(10),            /*卖场面积                               */
occ1014     varchar2(10),            /*连锁店数                               */
occ1015     date,                    /*门店开业日                             */
occ1016     varchar2(10),            /*惯用出货仓库                           */
occ1017     varchar2(20),            /*税务登记证号                           */
occ1018     date,                    /*税务登记证有效开始期                   */
occ1019     date,                    /*税务登记证有效截止期                   */
occ1020     varchar2(10),            /*纳税人识别号                           */
occ1021     varchar2(80),            /*发票全称                               */
occ1022     varchar2(10),            /*发票客户编号                           */
occ1023     varchar2(10),            /*收款客户编号                           */
occ1024     varchar2(10),            /*业绩归属组织                           */
occ1025     varchar2(10),            /*费用归属组织                           */
occ1026     number(5),               /*对帐日                                 */
occ1027     varchar2(1),             /*是否更改订单单价                       */
occ1028     number(9,4),             /*惯用订价折扣率                         */
occud01     varchar2(255),           /*用户自订字段                           */
occud02     varchar2(40),            /*用户自订字段                           */
occud03     varchar2(40),            /*用户自订字段                           */
occud04     varchar2(40),            /*用户自订字段                           */
occud05     varchar2(40),            /*用户自订字段                           */
occud06     varchar2(40),            /*用户自订字段                           */
occud07     number(15,3),            /*用户自订字段                           */
occud08     number(15,3),            /*用户自订字段                           */
occud09     number(15,3),            /*用户自订字段                           */
occud10     number(10),              /*用户自订字段                           */
occud11     number(10),              /*用户自订字段                           */
occud12     number(10),              /*用户自订字段                           */
occud13     date,                    /*用户自订字段                           */
occud14     date,                    /*用户自订字段                           */
occud15     date,                    /*用户自订字段                           */
occ66       varchar2(10),            /*代送商编号                             */
occ1029     varchar2(10),            /*no use                                 */
occ67       varchar2(10),            /*惯用科目类型                           */
occ1705     varchar2(10),            /*保税销退异动原因代码                   */
occ1706     varchar2(10),            /*保税出货异动原因代码                   */
occ1707     varchar2(10),            /*保税海关监管编号                       */
occ1708     varchar2(10),            /*保税业务人员                           */
occ234      varchar2(255),           /*发票地址-4                             */
occ235      varchar2(255),           /*发票地址-5                             */
occ244      varchar2(255),           /*送货地址-4                             */
occ245      varchar2(255),           /*送货地址-5                             */
occ246      varchar2(10) DEFAULT ' ' NOT NULL, /*资料来源*/
occ247      number(10),              /*客户资料抛转次数                       */
occ248      number(10),              /*信用资料抛转次数                       */
occ68       varchar2(6),             /*惯用订金收款条件代号                   */
occ69       varchar2(6),             /*惯用尾款收款条件代号                   */
occ71       varchar2(1) DEFAULT '1' NOT NULL, /*客户类型1.现付客户2.账期客户*/
occ72       number(5,2),             /*定金收取比率%                          */
occ930      varchar2(10),            /*对应营运中心                           */
occpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
occoriu     varchar2(10),            /*资料建立者                             */
occorig     varchar2(10),            /*资料建立部门                           */
occ73       varchar2(1) DEFAULT ' ' NOT NULL, /*按交款金额产生应收*/
occ74       varchar2(10),            /*总店号                                 */
occ75       varchar2(20),            /*买方厂编                               */
occ76       number(9,4),             /*期货订单折扣率                         */
occ77       number(9,4)              /*现货订单折扣率                         */
);

create        index occ_02 on occ_file (occ02);
alter table occ_file add  constraint occ_pk primary key  (occ01) enable validate;
grant select on occ_file to tiptopgp;
grant update on occ_file to tiptopgp;
grant delete on occ_file to tiptopgp;
grant insert on occ_file to tiptopgp;
grant index on occ_file to public;
grant select on occ_file to ods;
