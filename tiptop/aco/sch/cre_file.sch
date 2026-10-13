/*
================================================================================
檔案代號:cre_file
檔案名稱:成品/材料报关冲账差异记录单头档
檔案目的:记录成品/材料之异动/报关冲帐之报关差异资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cre_file
(
cre01       varchar2(20) NOT NULL,   /*单据编号                               */
cre02       date,                    /*单据日期                               */
cre03       varchar2(1),             /*类型                                   */
cre031      varchar2(1),             /*交易类型                               */
cre04       varchar2(1),             /*类型                                   */
cre05       varchar2(20),            /*交易参考单号                           */
cre06       varchar2(30),            /*报关单号                               */
cre07       date,                    /*报关日期                               */
cre08       varchar2(10),            /*交易对象                               */
cre09       varchar2(80),            /*对象名称                               */
cre10       varchar2(20),            /*手册编号                               */
cre11       varchar2(20),            /*对应手册编号                           */
cre12       varchar2(6),             /*贸易性质                               */
cre13       varchar2(10),            /*贸易国家                               */
cre14       varchar2(20),            /*通知单号                               */
cre15       number(5),               /*总件数                                 */
cre16       number(15,3),            /*毛重总量（公斤）                       */
cre17       varchar2(12),            /*集装箱号码                             */
cre18       varchar2(20),            /*折合单号                               */
cre19       number(15,3),            /*净重总量（公斤）                       */
cre20       varchar2(10),            /*海关编号                               */
creconf     varchar2(1),             /*确认码                                 */
creacti     varchar2(1),             /*资料有效码                             */
creuser     varchar2(10),            /*资料所有者                             */
cregrup     varchar2(10),            /*资料所有部门                           */
cremodu     varchar2(10),            /*资料更改者                             */
credate     date,                    /*最近更改日                             */
creplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crelegal    varchar2(10) NOT NULL,   /*所属法人                               */
creorig     varchar2(10),            /*资料建立部门                           */
creoriu     varchar2(10)             /*资料建立者                             */
);

alter table cre_file add  constraint cre_pk primary key  (cre01) enable validate;
grant select on cre_file to tiptopgp;
grant update on cre_file to tiptopgp;
grant delete on cre_file to tiptopgp;
grant insert on cre_file to tiptopgp;
grant index on cre_file to public;
grant select on cre_file to ods;
