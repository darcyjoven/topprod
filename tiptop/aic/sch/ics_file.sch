/*
================================================================================
檔案代號:ics_file
檔案名稱:ICD料件光罩基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ics_file
(
ics00       varchar2(40) NOT NULL,   /*光罩料号                               */
ics01       varchar2(80),            /*光罩群组                               */
ics02       varchar2(40),            /*母体编号                               */
ics03       varchar2(10),            /*工艺编号                               */
ics04       varchar2(10),            /*内编母体版本                           */
ics05       varchar2(10),            /*作业编号                               */
ics06       varchar2(10),            /*所属客户                               */
ics07       varchar2(10),            /*光罩厂商                               */
ics08       varchar2(255),           /*保管位置                               */
ics09       varchar2(10),            /*所有权                                 */
ics10       varchar2(10),            /*归属厂商 / 客户                        */
ics11       number(20,6),            /*光罩费用                               */
ics12       varchar2(4),             /*币种                                   */
ics13       number(15,3),            /*预计下单数量                           */
ics14       varchar2(4),             /*单位                                   */
ics15       number(15,3),            /*累计下单数量                           */
ics16       varchar2(1),             /*帐款处理方式                           */
ics17       varchar2(20),            /*预收帐款编号                           */
ics18       varchar2(20),            /*应收帐款编号                           */
ics19       date,                    /*下单期限                               */
ics20       varchar2(40),            /*产品编号                               */
icspost     varchar2(1)              /*光罩结案码                             */
);

alter table ics_file add  constraint ics_pk primary key  (ics00) enable validate;
grant select on ics_file to tiptopgp;
grant update on ics_file to tiptopgp;
grant delete on ics_file to tiptopgp;
grant insert on ics_file to tiptopgp;
grant index on ics_file to public;
grant select on ics_file to ods;
