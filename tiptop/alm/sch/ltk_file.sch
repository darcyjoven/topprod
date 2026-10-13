/*
================================================================================
檔案代號:ltk_file
檔案名稱:会员活动日积分回馈/折扣率变更配置文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltk_file
(
ltk01       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类别*/
ltk02       varchar2(20),            /*卡种代号                               */
ltk03       date,                    /*生效日期                               */
ltk04       date,                    /*失效日期                               */
ltk05       varchar2(10) DEFAULT ' ' NOT NULL, /*纪念日代码*/
ltk06       varchar2(1) DEFAULT ' ' NOT NULL, /*优惠条件*/
ltk07       number(20),              /*积分回馈基准                           */
ltk08       number(20),              /*积分倍数                               */
ltk09       number(20),              /*加送积分                               */
ltk10       number(6,2),             /*折扣率                                 */
ltk11       number(5),               /*纪念日前(日)                           */
ltk12       number(5),               /*纪念日后(日)                           */
ltk13       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
ltk14       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltk15       date,                    /*时段开始日期                           */
ltk16       date,                    /*时段结束日期                           */
ltk17       varchar2(8),             /*每日时段开始时间                       */
ltk18       varchar2(8),             /*每日时段结束时间                       */
ltk19       varchar2(2),             /*固定日期                               */
ltk20       varchar2(1) DEFAULT ' ' NOT NULL, /*固定星期*/
ltk21       number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltkacti     varchar2(1) NOT NULL,    /*资料有效码                             */
ltkdate     date,                    /*最近更改日                             */
ltkgrup     varchar2(10),            /*资料所有群                             */
ltklegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltkmodu     varchar2(10),            /*资料更改者                             */
ltkorig     varchar2(10),            /*资料建立部门                           */
ltkoriu     varchar2(10),            /*资料建立者                             */
ltkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ltkuser     varchar2(10)             /*资料所有者                             */
);

alter table ltk_file add  constraint ltk_pk primary key  (ltk13,ltk14,ltk21,ltk05,ltkplant) enable validate;
grant select on ltk_file to tiptopgp;
grant update on ltk_file to tiptopgp;
grant delete on ltk_file to tiptopgp;
grant insert on ltk_file to tiptopgp;
grant index on ltk_file to public;
grant select on ltk_file to ods;
