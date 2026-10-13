/*
================================================================================
檔案代號:ama_file
檔案名稱:申报税籍资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ama_file
(
ama01       varchar2(10) NOT NULL,   /*申报部门编号                           */
                                     /*申報部門編號                           */
ama02       varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
ama03       varchar2(20),            /*税籍编号                               */
                                     /*稅籍編號                               */
ama04       varchar2(80),            /*税捐处全名                             */
                                     /*稅捐處全名                             */
ama05       varchar2(255),           /*营业地址(一)                           */
                                     /*營業地址(一)                           */
ama06       varchar2(255),           /*营业地址(二)                           */
                                     /*營業地址(二)                           */
ama07       varchar2(80),            /*公司对外全名                           */
                                     /*公司對外全名                           */
ama08       number(5),               /*已申报年度                             */
                                     /*已申報年度                             */
ama09       number(5),               /*已申报月份                             */
                                     /*已申報月份                             */
ama10       number(5),               /*申报月数                               */
                                     /*申報月數                               */
ama11       varchar2(40),            /*负责人                                 */
                                     /*負責人  #No.B231 010505 add            */
ama12       varchar2(1),             /*是否可更改前端抛转的金额资             */
                                     /*是否可修改前端拋轉的金額資料 #No.B231  */
amaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
amauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
amagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
amamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
amadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ama13       varchar2(1),             /*资料别                                 */
ama14       varchar2(1),             /*县市别                                 */
ama15       varchar2(1),             /*总缴编号                               */
ama16       varchar2(1),             /*自行或委托办理申报注记                 */
ama17       varchar2(10),            /*(代理)申报人身分证统一编号             */
ama18       varchar2(40),            /*(代理)申报人姓名                       */
ama19       varchar2(20),            /*(代理)申报人电话                       */
ama20       varchar2(80),            /*代理申报人证书(登录)字号               */
ama21       varchar2(4),             /*(代理)申报人电话区码                   */
ama22       varchar2(5),             /*(代理)申报人电话分机号码               */
ama23       varchar2(20),            /*总机构税号                             */
ama24       varchar2(1),             /*进销资料并总公司合并申报               */
amaorig     varchar2(10),            /*资料建立部门                           */
amaoriu     varchar2(10),            /*资料建立者                             */
ama100      number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-免税*/
ama101      number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-共同使用*/
ama102      number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-课税*/
ama103      number(20,6) DEFAULT '0' NOT NULL, /*应纳税额-合计(编号76)*/
ama104      number(20,6) DEFAULT '0' NOT NULL, /*应纳税额-免税*/
ama105      number(20,6) DEFAULT '0' NOT NULL, /*应纳税额-共同使用*/
ama25       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供课 */
ama26       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供课 */
ama27       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-共同使 */
ama28       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-共同使 */
ama29       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-共同使 */
ama30       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供免 */
ama31       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-进项税额 */
ama32       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-专供课税 */
ama33       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-共同使用-*/
ama34       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-共同使用-*/
ama35       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-共同使用-*/
ama36       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-专供免税 */
ama37       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-进项税额 */
ama38       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-专供课税 */
ama39       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-共同使用-*/
ama40       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-共同使用-*/
ama41       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-共同使用-*/
ama42       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-专供免税 */
ama43       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-进项税额合 */
ama44       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-专供课税得 */
ama45       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-共同使用-小*/
ama46       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-共同使用-比*/
ama47       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-共同使用-比*/
ama48       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-专供免税不 */
ama49       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-进项税 */
ama50       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-专供课 */
ama51       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-共同使 */
ama52       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-共同使 */
ama53       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-共同使 */
ama54       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-专供免 */
ama55       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-进项税额 */
ama56       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-专供课税 */
ama57       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-共同使用-*/
ama58       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-共同使用-*/
ama59       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-共同使用-*/
ama60       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-专供免税 */
ama61       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(进货及费用)-进项税 */
ama62       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(进货及费用)-专供课 */
ama63       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(进货及费用)-共同使 */
ama64       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(进货及费用)-共同使 */
ama65       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(进货及费用)-共同使 */
ama66       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(进货及费用)-专供免 */
ama67       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(固定资产)-进项税额 */
ama68       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(固定资产)-专供课税 */
ama69       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(固定资产)-共同使用-*/
ama70       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(固定资产)-共同使用-*/
ama71       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(固定资产)-共同使用-*/
ama72       number(20,6) DEFAULT '0' NOT NULL, /*海关代徵(固定资产)-专供免税 */
ama73       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-进项 */
ama74       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-专供 */
ama75       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-共同 */
ama76       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-共同 */
ama77       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-共同 */
ama78       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-专供 */
ama79       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-进项税 */
ama80       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-专供课 */
ama81       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-共同使 */
ama82       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-共同使 */
ama83       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-共同使 */
ama84       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-专供免 */
ama85       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-进项税额合 */
ama86       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-专供课税得 */
ama87       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-共同使用-小*/
ama88       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-共同使用-比*/
ama89       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-共同使用-比*/
ama90       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-专供免税不 */
ama91       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-进项税额合计(*/
ama92       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-专供课税得扣 */
ama93       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-共同使用-小计*/
ama94       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-共同使用-比例*/
ama95       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-共同使用-比例*/
ama96       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-专供免税不得 */
ama97       number(20,6) DEFAULT '0' NOT NULL, /*得扣抵之进项税额合计(编号51)*/
ama98       number(15,6) DEFAULT '0' NOT NULL, /*不得扣抵比例*/
ama99       number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-合计(编号74)*/
ama106      date,                    /*电子发票-核准日                        */
ama107      varchar2(40),            /*电子发票-核准文                        */
ama108      varchar2(20)             /*电子发票-核准号                        */
);

alter table ama_file add  constraint ama_pk primary key  (ama01) enable validate;
grant select on ama_file to tiptopgp;
grant update on ama_file to tiptopgp;
grant delete on ama_file to tiptopgp;
grant insert on ama_file to tiptopgp;
grant index on ama_file to public;
grant select on ama_file to ods;
