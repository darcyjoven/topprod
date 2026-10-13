/*
================================================================================
檔案代號:lqg_file
檔案名稱:促銷活動設置檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqg_file
(
lqg01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单编号*/
lqg02       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
lqg03       varchar2(10),            /*促销主题编号                           */
lqg04       varchar2(10),            /*促销哦负责人                           */
lqg05       varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
lqg06       varchar2(1) DEFAULT ' ' NOT NULL, /*签核*/
lqg07       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lqg08       varchar2(10),            /*审核人                                 */
lqg09       date,                    /*审核日期                               */
lqg10       varchar2(10),            /*终止人                                 */
lqg11       date,                    /*终止日期                               */
lqg12       varchar2(1) DEFAULT ' ', /*计算方法                               */
lqg13       varchar2(20),            /*返券种类                               */
lqg14       number(5),               /*返券限制天数                           */
lqg15       varchar2(10),            /*取整金额                               */
lqg16       varchar2(1) DEFAULT ' ', /*取整方向                               */
lqg17       varchar2(1) DEFAULT ' ' NOT NULL, /*尾款不参加促销*/
lqg18       varchar2(1) DEFAULT ' ' NOT NULL, /*是否满额参加促销*/
lqg19       number(20,2),            /*满额享受促销额度                       */
lqg20       varchar2(1) DEFAULT ' ' NOT NULL, /*是否可积分*/
lqg21       varchar2(1) DEFAULT ' ' NOT NULL, /*是否分摊*/
lqg22       varchar2(1) DEFAULT ' ', /*默认费用分摊方式                       */
lqg23       varchar2(1) DEFAULT ' ', /*默认分摊金额类型                       */
lqg24       varchar2(1) DEFAULT ' ', /*no use                                 */
lqgacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lqgcrat     date,                    /*资料创建日                             */
lqgdate     date,                    /*最近更改日                             */
lqggrup     varchar2(10),            /*资料所有群                             */
lqgmodu     varchar2(10),            /*资料更改者                             */
lqguser     varchar2(10),            /*资料所有者                             */
lqgoriu     varchar2(10),            /*资料建立者                             */
lqgorig     varchar2(10)             /*资料建立部门                           */
);

alter table lqg_file add  constraint lqg_pk primary key  (lqg01) enable validate;
grant select on lqg_file to tiptopgp;
grant update on lqg_file to tiptopgp;
grant delete on lqg_file to tiptopgp;
grant insert on lqg_file to tiptopgp;
grant index on lqg_file to public;
grant select on lqg_file to ods;
