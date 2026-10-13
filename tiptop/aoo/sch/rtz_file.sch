/*
================================================================================
檔案代號:rtz_file
檔案名稱:门店基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rtz_file
(
rtz01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心代码*/
rtz02       varchar2(10),            /*营运中心类别                           */
rtz03       varchar2(1) DEFAULT ' ' NOT NULL, /*门市属性1自营2加盟*/
rtz04       varchar2(10),            /*商品策略                               */
rtz05       varchar2(10),            /*价格策略                               */
rtz06       varchar2(10),            /*散客编号                               */
rtz07       varchar2(10),            /*预设成本仓                             */
rtz08       varchar2(10),            /*默认非成本仓                           */
rtz09       number(5),               /*配送天数                               */
rtz10       varchar2(10),            /*城区编号                               */
rtz11       varchar2(1) DEFAULT 'N' NOT NULL, /*上级下发促销重新审核*/
rtzpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传pos否*/
rtz12       varchar2(1) DEFAULT ' ' NOT NULL, /*业务类型*/
rtz13       varchar2(60),            /*门店简称                               */
rtz14       number(20,6) DEFAULT '0' NOT NULL, /*每月租金*/
rtz15       number(20,6) DEFAULT '0' NOT NULL, /*每月每人平均参考工资*/
rtz16       varchar2(10),            /*门店邮寄邮编                           */
rtz17       varchar2(255),           /*门店地址                               */
rtz18       varchar2(40),            /*电话                                   */
rtz19       varchar2(40),            /*传真                                   */
rtz20       varchar2(10),            /*门店邮寄邮递区号                       */
rtz21       varchar2(255),           /*门店邮寄地址                           */
rtz22       number(20,6) DEFAULT '0' NOT NULL, /*建筑面积*/
rtz23       number(20,6) DEFAULT '0' NOT NULL, /*经营面积*/
rtz24       varchar2(5),             /*摊位总数                               */
rtz25       varchar2(20),            /*银行编号                               */
rtz26       varchar2(30),            /*银行帐号                               */
rtz27       varchar2(80),            /*银行户名                               */
rtz28       varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
rtzcrat     date,                    /*资料创建日                             */
rtzdate     date,                    /*最近更改日                             */
rtzgrup     varchar2(10),            /*资料所有群                             */
rtzmodu     varchar2(10),            /*资料更改者                             */
rtzorig     varchar2(10),            /*资料建立部门                           */
rtzoriu     varchar2(10),            /*资料建立者                             */
rtzuser     varchar2(10),            /*资料所有者                             */
rtz29       varchar2(10),            /*进驻百货公司客户编号                   */
rtz30       number(20,6),            /*測量面積                               */
rtz31       number(5),               /*订金比例(本店取货)                     */
rtz32       number(5),               /*订金比例(其他门店取货)                 */
rtz33       number(5)                /*订金比例(总部配送)                     */
);

alter table rtz_file add  constraint rtz_pk primary key  (rtz01) enable validate;
grant select on rtz_file to tiptopgp;
grant update on rtz_file to tiptopgp;
grant delete on rtz_file to tiptopgp;
grant insert on rtz_file to tiptopgp;
grant index on rtz_file to public;
grant select on rtz_file to ods;
