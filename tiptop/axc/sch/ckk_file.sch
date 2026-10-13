/*
================================================================================
檔案代號:ckk_file
檔案名稱:成本核算表
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ckk_file
(
ckk00       varchar2(10) DEFAULT ' ' NOT NULL, /*版本*/
ckk01       varchar2(10),            /*类型代码                               */
ckk02       varchar2(60),            /*类型说明                               */
ckk03       number(5),               /*年度                                   */
ckk04       number(5),               /*期别                                   */
ckk05       varchar2(20),            /*程序编号                               */
ckk06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ckk07       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
ckk08       number(20,6) DEFAULT '0' NOT NULL, /*总金额*/
ckk09       number(20,6) DEFAULT '0' NOT NULL, /*材料金额*/
ckk10       number(20,6) DEFAULT '0' NOT NULL, /*人工金额*/
ckk11       number(20,6) DEFAULT '0' NOT NULL, /*加工费*/
ckk12       number(20,6) DEFAULT '0' NOT NULL, /*制費一金額*/
ckk13       number(20,6) DEFAULT '0' NOT NULL, /*制費二金額*/
ckk14       number(20,6) DEFAULT '0' NOT NULL, /*制費三金額*/
ckk15       number(20,6) DEFAULT '0' NOT NULL, /*制費四金額*/
ckk16       number(20,6) DEFAULT '0' NOT NULL, /*制費五金額*/
ckk17       varchar2(100),           /*執行條件                               */
ckkacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ckkdate     date,
ckktime     varchar2(8),             /*資料產生時間                           */
ckkuser     varchar2(10)             /*資料產生者                             */
);

create        index ckk_01 on ckk_file (ckk03,ckk04,ckk06);
alter table ckk_file add  constraint ckk_pk primary key  (ckk00) enable validate;
grant select on ckk_file to tiptopgp;
grant update on ckk_file to tiptopgp;
grant delete on ckk_file to tiptopgp;
grant insert on ckk_file to tiptopgp;
grant index on ckk_file to public;
grant select on ckk_file to ods;
