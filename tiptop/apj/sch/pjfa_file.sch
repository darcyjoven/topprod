/*
================================================================================
檔案代號:pjfa_file
檔案名稱:wbs本阶计划材料需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjfa_file
(
pjfa01      varchar2(30) NOT NULL,   /*本阶wbs编码                            */
pjfa02      number(5) NOT NULL,      /*项次                                   */
pjfa03      varchar2(40),            /*料件编号                               */
pjfa04      varchar2(120),           /*品名                                   */
pjfa05      number(15,3),            /*需求量                                 */
pjfa06      date,                    /*需求日                                 */
pjfa07      number(15,3),            /*转请购量                               */
pjfaacti    varchar2(1),             /*资料有效码                             */
pjfadate    date,                    /*最近更改日                             */
pjfagrup    varchar2(10),            /*资料所有部门                           */
pjfamodu    varchar2(10),            /*资料更改者                             */
pjfauser    varchar2(10),            /*资料所有者                             */
pjfaorig    varchar2(10),            /*资料建立部门                           */
pjfaoriu    varchar2(10)             /*资料建立者                             */
);

alter table pjfa_file add  constraint pjfa_pk primary key  (pjfa01,pjfa02) enable validate;
grant select on pjfa_file to tiptopgp;
grant update on pjfa_file to tiptopgp;
grant delete on pjfa_file to tiptopgp;
grant insert on pjfa_file to tiptopgp;
grant index on pjfa_file to public;
grant select on pjfa_file to ods;
