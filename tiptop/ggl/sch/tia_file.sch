/*
================================================================================
檔案代號:tia_file
檔案名稱:现金流量活动现金代码档
檔案目的:维护现金流量表打印的科目群组
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tia_file
(
tia01       number(5) NOT NULL,      /*起始年度                               */
tia02       number(5) NOT NULL,      /*起始期别                               */
tia03       number(5),               /*截止年度                               */
tia04       number(5),               /*截止期别                               */
tia05       varchar2(5) NOT NULL,    /*帐套                                   */
tia06       varchar2(24) NOT NULL,   /*科目编号                               */
tia07       varchar2(1) NOT NULL,    /*借贷别                                 */
tia08       number(20,6),            /*金额                                   */
tia081      number(20,6),            /*调整金额                               */
                                     /*gib_file中相應記錄的gib08之和,存放現金變動碼不為tia09的金額合計*/
tia09       varchar2(6),             /*现金代码                               */
tiauser     varchar2(10),            /*资料所有者                             */
tiagrup     varchar2(10),            /*资料所有群                             */
tiamodu     varchar2(10),            /*资料更改者                             */
tiadate     date,                    /*最近更改日                             */
tiaorig     varchar2(10),            /*资料建立部门                           */
tiaoriu     varchar2(10)             /*资料建立者                             */
);

alter table tia_file add  constraint tia_pk primary key  (tia01,tia02,tia05,tia06,tia07) enable validate;
grant select on tia_file to tiptopgp;
grant update on tia_file to tiptopgp;
grant delete on tia_file to tiptopgp;
grant insert on tia_file to tiptopgp;
grant index on tia_file to public;
grant select on tia_file to ods;
