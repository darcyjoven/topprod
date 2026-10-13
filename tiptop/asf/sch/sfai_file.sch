/*
================================================================================
檔案代號:sfai_file
檔案名稱:备料档(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfai_file
(
sfai01      varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sfai03      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
sfai08      varchar2(10) DEFAULT ' ' NOT NULL, /*作业编号*/
sfai12      varchar2(4) DEFAULT ' ' NOT NULL, /*发料单位*/
sfaiicd01   number(15,3),            /*应发数量                               */
sfaiicd02   varchar2(4),             /*应发数量单位                           */
sfaiicd03   varchar2(24),            /*发料批号                               */
sfaiicd04   number(15,3),            /*已发参考数量                           */
sfaiicd05   number(15,3),            /*超发参考数量                           */
sfaislk01   number(15,3),            /*码克用量                               */
sfai27      varchar2(40) DEFAULT ' ' NOT NULL, /*被替代料号*/
sfaislk02   varchar2(20),            /*制单号                                 */
sfaiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
sfailegal   varchar2(10) NOT NULL,   /*所属法人                               */
sfai012     varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sfai013     number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sfaiicd06   varchar2(1) DEFAULT 'N' NOT NULL
);

alter table sfai_file add  constraint sfai_pk primary key  (sfai01,sfai03,sfai08,sfai12,sfai27,sfai012,sfai013) enable validate;
grant select on sfai_file to tiptopgp;
grant update on sfai_file to tiptopgp;
grant delete on sfai_file to tiptopgp;
grant insert on sfai_file to tiptopgp;
grant index on sfai_file to public;
grant select on sfai_file to ods;
