/*
================================================================================
檔案代號:aek_file
檔案名稱:合併個體異動碼會計科目餘額檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aek_file
(
aek00       varchar2(5) NOT NULL,    /*集团帐套                               */
aek01       varchar2(10) NOT NULL,   /*集团代号                               */
aek02       varchar2(10) NOT NULL,   /*合併個體編號                           */
aek03       varchar2(5) NOT NULL,    /*合併個體帳別                           */
aek04       varchar2(24) NOT NULL,   /*科目编号                               */
aek05       varchar2(30) NOT NULL,   /*核算项值                               */
aek06       number(5) NOT NULL,      /*会计年度                               */
aek07       number(5) NOT NULL,      /*期别                                   */
aek08       number(20,6) NOT NULL,   /*借方金额                               */
aek09       number(20,6) NOT NULL,   /*贷方金额                               */
aek10       number(10),              /*借方总笔数                             */
aek11       number(10),              /*贷方总笔数                             */
aek12       varchar2(4) NOT NULL,    /*币种                                   */
aeklegal    varchar2(10) NOT NULL,   /*所属法人                               */
aek13       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aek14       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aek15       varchar2(4),             /*no use                                 */
aek16       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aek17       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aek18       varchar2(4),             /*no use                                 */
aek19       varchar2(10)             /*no use                                 */
);

alter table aek_file add  constraint aek_pk primary key  (aek00,aek01,aek02,aek03,aek04,aek05,aek06,aek07,aek12) enable validate;
grant select on aek_file to tiptopgp;
grant update on aek_file to tiptopgp;
grant delete on aek_file to tiptopgp;
grant insert on aek_file to tiptopgp;
grant index on aek_file to public;
grant select on aek_file to ods;
