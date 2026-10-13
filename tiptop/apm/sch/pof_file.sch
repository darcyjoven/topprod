/*
================================================================================
檔案代號:pof_file
檔案名稱:料件特卖价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pof_file
(
pof01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
pof02       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
pof03       date DEFAULT sysdate NOT NULL, /*生效日期*/
pof04       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
pof05       varchar2(6) DEFAULT ' ' NOT NULL, /*付款方式*/
pof06       date,                    /*失效日期                               */
pof07       varchar2(255),           /*備注                                   */
pof08       varchar2(4),             /*税种                                   */
pof09       number(9,4),             /*税率                                   */
pofdate     date,                    /*最近更改日                             */
pofgrup     varchar2(10),            /*资料所有部门                           */
pofmodu     varchar2(10),            /*资料更改者                             */
pofuser     varchar2(10),            /*资料所有者                             */
poforiu     varchar2(10),            /*资料建立者                             */
poforig     varchar2(10)             /*资料建立部门                           */
);

alter table pof_file add  constraint pof_pk primary key  (pof01,pof02,pof03,pof04,pof05) enable validate;
grant select on pof_file to tiptopgp;
grant update on pof_file to tiptopgp;
grant delete on pof_file to tiptopgp;
grant insert on pof_file to tiptopgp;
grant index on pof_file to public;
grant select on pof_file to ods;
