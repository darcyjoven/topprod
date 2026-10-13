/*
================================================================================
檔案代號:pjda_file
檔案名稱:wbs本阶预计费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjda_file
(
pjda01      varchar2(30) NOT NULL,   /*本阶wbs编码                            */
pjda02      varchar2(10) NOT NULL,   /*费用编号                               */
pjda03      varchar2(24),            /*科目一                                 */
pjda04      varchar2(24),            /*科目二                                 */
pjda05      number(20,6),            /*预估金额（项目币种）                   */
pjdaacti    varchar2(1),             /*资料有效码                             */
pjdadate    date,                    /*最近更改日                             */
pjdagrup    varchar2(10),            /*资料所有部门                           */
pjdamodu    varchar2(10),            /*资料更改者                             */
pjdauser    varchar2(10),            /*资料所有者                             */
pjdaorig    varchar2(10),            /*资料建立部门                           */
pjdaoriu    varchar2(10)             /*资料建立者                             */
);

alter table pjda_file add  constraint pjda_pk primary key  (pjda01,pjda02) enable validate;
grant select on pjda_file to tiptopgp;
grant update on pjda_file to tiptopgp;
grant delete on pjda_file to tiptopgp;
grant insert on pjda_file to tiptopgp;
grant index on pjda_file to public;
grant select on pjda_file to ods;
