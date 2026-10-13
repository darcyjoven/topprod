/*
================================================================================
檔案代號:lne_file
檔案名稱:正式商户资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lne_file
(
lne01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lne02       varchar2(20),            /*版本号                                 */
lne03       varchar2(20),            /*潜在商户单号                           */
lne04       varchar2(10),            /*来源门店编号                           */
lne05       varchar2(20),            /*商户简称                               */
lne06       varchar2(80),            /*商户全称                               */
lne07       varchar2(1) DEFAULT ' ' NOT NULL, /*企业性质*/
lne08       varchar2(10),            /*主品牌                                 */
lne09       varchar2(10),            /*产地                                   */
lne10       varchar2(60),            /*经营范围                               */
lne11       varchar2(10),            /*no use                                 */
lne12       varchar2(40),            /*总经理                                 */
lne13       varchar2(20),            /*总经理电话                             */
lne14       varchar2(40),            /*营销负责人                             */
lne15       varchar2(20),            /*负责人电话                             */
lne16       varchar2(40),            /*法人代表                               */
lne17       varchar2(20),            /*代表电话                               */
lne18       varchar2(40),            /*经营人                                 */
lne19       varchar2(20),            /*经营人电话                             */
lne20       varchar2(30),            /*电子信箱                               */
lne21       varchar2(30),            /*公司网站                               */
lne22       varchar2(20),            /*传真                                   */
lne23       varchar2(20),            /*代理登记                               */
lne24       number(20,6) DEFAULT '0',/*拟租面积                               */
lne25       varchar2(50),            /*营业执照                               */
lne26       varchar2(50),            /*税务登记证                             */
lne27       varchar2(1) DEFAULT ' ' NOT NULL, /*缴纳质保金*/
lne28       varchar2(1) DEFAULT ' ' NOT NULL, /*经营行态*/
lne29       number(20,6) DEFAULT '0',/*注册资金                               */
lne30       varchar2(20),            /*营运中心编号证                         */
lne31       varchar2(1) DEFAULT ' ' NOT NULL, /*是否战盟*/
lne32       number(20) DEFAULT '0' NOT NULL, /*当前门店数*/
lne33       number(20) DEFAULT '0' NOT NULL, /*当前摊位数*/
lne34       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lne35       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lne36       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lne37       varchar2(10),            /*审核人                                 */
lne38       date,                    /*审核日期                               */
lne39       varchar2(50),            /*备注                                   */
lne40       varchar2(4),             /*税种                                   */
lne41       varchar2(4),             /*发票种类                               */
lne42       varchar2(6),             /*收款条件                               */
lne43       varchar2(10),            /*联系人姓名                             */
lne44       varchar2(20),            /*联系人电话                             */
lne45       varchar2(20),            /*联系人邮箱                             */
lne46       varchar2(20),            /*邮寄编号                               */
lne47       varchar2(80),            /*邮寄地址                               */
lne48       varchar2(20),            /*发票邮编                               */
lne49       varchar2(80),            /*发票地址                               */
lne50       varchar2(30),            /*银行编号                               */
lne51       varchar2(30),            /*银行名称                               */
lne52       varchar2(30),            /*银行帐号                               */
lne53       varchar2(80),            /*银行户名                               */
lne54       varchar2(50),            /*备注                                   */
lne55       varchar2(30),            /*税号                                   */
lne56       varchar2(10),            /*惯用科目类型                           */
lne57       varchar2(4),             /*惯用币种                               */
lne58       varchar2(1),             /*保留小数位                             */
lne59       varchar2(1),             /*证件审核否                             */
lnecrat     date,                    /*资料创建日                             */
lnedate     date,                    /*最近更改日                             */
lnegrup     varchar2(10),            /*资料所有群                             */
lnemodu     varchar2(10),            /*资料更改者                             */
lneuser     varchar2(10),            /*资料所有者                             */
lneoriu     varchar2(10),            /*资料建立者                             */
lneorig     varchar2(10),            /*资料建立部门                           */
lne61       varchar2(10),            /*所属营运中心                           */
lne62       varchar2(10),            /*商户客户类型                           */
lne63       varchar2(1) DEFAULT '1' NOT NULL, /*商户客户性质*/
lne64       varchar2(10),            /*商户收款客户                           */
lne65       varchar2(10),            /*商户送货客户                           */
lne66       varchar2(1) DEFAULT ' ' NOT NULL, /*惯用语言*/
lne67       varchar2(10),            /*商戶等級                               */
lne68       varchar2(10)             /*品牌等級                               */
);

alter table lne_file add  constraint lne_pk primary key  (lne01) enable validate;
grant select on lne_file to tiptopgp;
grant update on lne_file to tiptopgp;
grant delete on lne_file to tiptopgp;
grant insert on lne_file to tiptopgp;
grant index on lne_file to public;
grant select on lne_file to ods;
