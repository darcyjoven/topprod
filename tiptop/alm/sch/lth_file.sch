/*
================================================================================
檔案代號:lth_file
檔案名稱:會員紀念日積分回饋設定檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lth_file
(
lth01       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类别*/
lth02       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种代号*/
lth03       date DEFAULT sysdate NOT NULL, /*生效日期*/
lth04       date DEFAULT sysdate NOT NULL, /*失效日期*/
lth05       varchar2(10) DEFAULT ' ' NOT NULL, /*纪念日代码*/
lth06       varchar2(1) DEFAULT ' ' NOT NULL, /*优惠条件*/
lth07       number(20),              /*积分回馈基准                           */
lth08       number(20),              /*积分倍数                               */
lth09       number(20),              /*加送积分                               */
lth10       number(6,2),             /*折扣率                                 */
lthdate     date,                    /*最近更改日                             */
lthgrup     varchar2(10),            /*资料所有群                             */
lthmodu     varchar2(10),            /*资料更改者                             */
lthorig     varchar2(10),            /*资料建立部门                           */
lthoriu     varchar2(10),            /*资料建立者                             */
lthuser     varchar2(10),            /*资料所有者                             */
lth11       number(5),               /*纪念日前(日)                           */
lth12       number(5),               /*纪念日后(日)                           */
lthacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lth13       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lth14       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lth15       date,                    /*时段开始日期                           */
lth16       date,                    /*时段结束日期                           */
lth17       varchar2(8),             /*每日时段开始时间                       */
lth18       varchar2(8),             /*每日时段结束时间                       */
lth19       varchar2(2),             /*固定日期                               */
lth20       varchar2(1) DEFAULT ' ' NOT NULL, /*固定星期*/
lthlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lthplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lth_file add  constraint lth_pk primary key  (lth13,lth14,lth05,lthplant) enable validate;
grant select on lth_file to tiptopgp;
grant update on lth_file to tiptopgp;
grant delete on lth_file to tiptopgp;
grant insert on lth_file to tiptopgp;
grant index on lth_file to public;
grant select on lth_file to ods;
