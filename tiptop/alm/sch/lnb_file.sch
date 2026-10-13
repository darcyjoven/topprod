/*
================================================================================
檔案代號:lnb_file
檔案名稱:潜在商户资料登记档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnb_file
(
lnb01       varchar2(20) DEFAULT ' ' NOT NULL, /*潜在商户单号*/
lnb02       varchar2(20),            /*预登记单号                             */
lnb03       varchar2(10),            /*来源门店编号                           */
lnb04       varchar2(10),            /*商户号                                 */
lnb05       varchar2(20),            /*商户简称                               */
lnb06       varchar2(80),            /*商户全称                               */
lnb07       varchar2(1) DEFAULT ' ' NOT NULL, /*企业性质*/
lnb08       varchar2(10),            /*主品牌                                 */
lnb09       varchar2(10),            /*产地                                   */
lnb10       varchar2(60),            /*经营范围                               */
lnb11       varchar2(10),            /*no use                                 */
lnb12       varchar2(40),            /*总经理                                 */
lnb13       varchar2(20),            /*总经理电话                             */
lnb14       varchar2(40),            /*营销负责人                             */
lnb15       varchar2(20),            /*负责人电话                             */
lnb16       varchar2(40),            /*法人代表                               */
lnb17       varchar2(20),            /*代表电话                               */
lnb18       varchar2(40),            /*经营人                                 */
lnb19       varchar2(20),            /*经营人电话                             */
lnb20       varchar2(30),            /*电子信箱                               */
lnb21       varchar2(30),            /*公司网站                               */
lnb22       varchar2(20),            /*传真                                   */
lnb23       varchar2(20),            /*代理登记                               */
lnb24       number(20,6) DEFAULT '0',/*拟租面积                               */
lnb25       varchar2(50),            /*营业执照                               */
lnb26       varchar2(50),            /*税务登记证                             */
lnb27       varchar2(1) DEFAULT ' ' NOT NULL, /*缴纳质保金*/
lnb28       varchar2(1) DEFAULT ' ' NOT NULL, /*经营行态*/
lnb29       number(20,6) DEFAULT '0',/*注册资金                               */
lnb30       varchar2(20),            /*营运中心编号证                         */
lnb31       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lnb32       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lnb33       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lnb34       varchar2(10),            /*审核人                                 */
lnb35       date,                    /*审核日期                               */
lnb36       varchar2(50),            /*备注                                   */
lnb37       varchar2(4),             /*税种                                   */
lnb38       varchar2(4),             /*发票种类                               */
lnb39       varchar2(6),             /*收款条件                               */
lnb40       varchar2(10),            /*联系人姓名                             */
lnb41       varchar2(20),            /*联系人电话                             */
lnb42       varchar2(30),            /*联系人信箱                             */
lnb43       varchar2(20),            /*邮寄邮局                               */
lnb44       varchar2(80),            /*邮寄地址                               */
lnb45       varchar2(20),            /*发票邮编                               */
lnb46       varchar2(80),            /*发票地址                               */
lnb47       varchar2(30),            /*银行编号                               */
lnb48       varchar2(30),            /*银行名称                               */
lnb49       varchar2(30),            /*银行帐号                               */
lnb50       varchar2(80),            /*银行户名                               */
lnb51       varchar2(50),            /*备注                                   */
lnb52       varchar2(10),            /*惯用科目类型                           */
lnb53       varchar2(4),             /*币种                                   */
lnbcrat     date,                    /*资料创建日                             */
lnbdate     date,                    /*最近更改日                             */
lnbgrup     varchar2(10),            /*资料所有群                             */
lnbmodu     varchar2(10),            /*资料更改者                             */
lnbuser     varchar2(10),            /*资料所有者                             */
lnboriu     varchar2(10),            /*资料建立者                             */
lnborig     varchar2(10),            /*资料建立部门                           */
lnb54       varchar2(20)             /*意向協議單號                           */
);

alter table lnb_file add  constraint lnb_pk primary key  (lnb01) enable validate;
grant select on lnb_file to tiptopgp;
grant update on lnb_file to tiptopgp;
grant delete on lnb_file to tiptopgp;
grant insert on lnb_file to tiptopgp;
grant index on lnb_file to public;
grant select on lnb_file to ods;
