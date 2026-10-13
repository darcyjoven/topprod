/*
================================================================================
檔案代號:lue_file
檔案名稱:正式商户变更资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lue_file
(
lue01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lue02       varchar2(20) DEFAULT ' ' NOT NULL, /*版本号*/
lue03       varchar2(20),            /*潜在商户单号                           */
lue04       varchar2(10),            /*来源门店编号                           */
lue05       varchar2(20),            /*商户简称                               */
lue06       varchar2(80),            /*商户全称                               */
lue07       varchar2(1) DEFAULT ' ' NOT NULL, /*企业性质*/
lue08       varchar2(10),            /*主品牌                                 */
lue09       varchar2(10),            /*产地编号                               */
lue10       varchar2(60),            /*经营范围                               */
lue11       varchar2(10),            /*no use                                 */
lue12       varchar2(40),            /*总经理                                 */
lue13       varchar2(20),            /*总经理电话                             */
lue14       varchar2(40),            /*销售负责人                             */
lue15       varchar2(20),            /*负责人电话                             */
lue16       varchar2(40),            /*法人代表                               */
lue17       varchar2(20),            /*代表电话                               */
lue18       varchar2(40),            /*经营人                                 */
lue19       varchar2(20),            /*经营人电话                             */
lue20       varchar2(30),            /*电子信箱                               */
lue21       varchar2(30),            /*公司网站                               */
lue22       varchar2(20),            /*传真                                   */
lue23       varchar2(20),            /*代理登记                               */
lue24       number(20,6) DEFAULT '0',/*拟租面积                               */
lue25       varchar2(50),            /*营业执照                               */
lue26       varchar2(50),            /*税务登记证                             */
lue27       varchar2(1) DEFAULT ' ' NOT NULL, /*缴纳质保金*/
lue28       varchar2(1) DEFAULT ' ' NOT NULL, /*经营行态*/
lue29       number(20,6) DEFAULT '0',/*注册资金                               */
lue30       varchar2(20),            /*营运中心编号证                         */
lue31       varchar2(1) DEFAULT ' ' NOT NULL, /*是否战盟*/
lue32       number(20) DEFAULT '0' NOT NULL, /*当前门店数*/
lue33       number(20) DEFAULT '0' NOT NULL, /*当前摊位数*/
lue34       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lue35       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lue36       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lue37       varchar2(10),            /*审核人                                 */
lue38       date,                    /*审核日期                               */
lue39       varchar2(50),            /*备注                                   */
lue40       varchar2(4),             /*税种                                   */
lue41       varchar2(10),            /*发票种类                               */
lue42       varchar2(6),             /*收款条件                               */
lue43       varchar2(10),            /*联系人姓名                             */
lue44       varchar2(20),            /*联系人电话                             */
lue45       varchar2(20),            /*联系人邮箱                             */
lue46       varchar2(20),            /*邮寄邮局                               */
lue47       varchar2(80),            /*邮寄地址                               */
lue48       varchar2(20),            /*发票邮编                               */
lue49       varchar2(80),            /*发票地址                               */
lue50       varchar2(30),            /*银行编号                               */
lue51       varchar2(30),            /*银行名称                               */
lue52       varchar2(30),            /*银行账号                               */
lue53       varchar2(80),            /*银行户名                               */
lue54       varchar2(50),            /*备注                                   */
lue55       varchar2(1) DEFAULT ' ' NOT NULL, /*变更发出*/
lue56       varchar2(30),            /*法人身份证                             */
lue57       varchar2(10),            /*惯用科目类型                           */
lue58       varchar2(4),             /*惯用币种                               */
lue59       varchar2(1) DEFAULT ' ' NOT NULL, /*保留小数位*/
lue60       varchar2(1) DEFAULT ' ' NOT NULL, /*证件审核否*/
luecrat     date,                    /*资料创建日                             */
luedate     date,                    /*最近更改日                             */
luegrup     varchar2(10),            /*资料所有群                             */
luemodu     varchar2(10),            /*资料更改者                             */
lueuser     varchar2(10),            /*资料所有者                             */
lueoriu     varchar2(10),            /*资料建立者                             */
lueorig     varchar2(10),            /*资料建立部门                           */
lue61       varchar2(10),            /*所属营运中心                           */
lue62       varchar2(10),            /*商户客户类型                           */
lue63       varchar2(1) DEFAULT '1' NOT NULL, /*商户客户性质*/
lue64       varchar2(10),            /*商户收款客户                           */
lue65       varchar2(10),            /*商户送货客户                           */
lue66       varchar2(1) DEFAULT ' ' NOT NULL /*惯用语言*/
);

alter table lue_file add  constraint lue_pk primary key  (lue01,lue02) enable validate;
grant select on lue_file to tiptopgp;
grant update on lue_file to tiptopgp;
grant delete on lue_file to tiptopgp;
grant insert on lue_file to tiptopgp;
grant index on lue_file to public;
grant select on lue_file to ods;
