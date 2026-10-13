/*
================================================================================
檔案代號:hrdu_file
檔案名稱:员工参保退保管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdu_file
(
hrdu01      varchar2(20) NOT NULL,   /*员工ID                                 */
hrdu02      varchar2(50),            /*统筹体系ID                             */
hrdu03      varchar2(20) NOT NULL,   /*缴纳标志ID                             */
hrdu04      varchar2(100),           /*扣缴开始月份                           */
hrdu05      varchar2(20) NOT NULL,   /*参数ID                                 */
hrdu06      varchar2(20),            /*统筹类型ID                             */
hrdu07      number(20,6),            /*公司定额基数                           */
hrdu08      number(20,6),            /*公司比例                               */
hrdu09      number(20,6),            /*个人定额基数                           */
hrdu10      number(20,6),            /*个人比例                               */
hrduacti    varchar2(1),             /*资料有效码                             */
hrduuser    varchar2(10),            /*资料所有者                             */
hrdugrup    varchar2(10),            /*资料所有群                             */
hrdumodu    varchar2(10),            /*资料修改者                             */
hrdudate    date,                    /*最近修改日                             */
hrduorig    varchar2(10),            /*资料建立部门                           */
hrduoriu    varchar2(10),            /*资料建立者                             */
hrduud01    varchar2(255),
hrduud02    varchar2(40),
hrduud03    varchar2(40),
hrduud04    varchar2(40),
hrduud05    varchar2(40),
hrduud06    varchar2(40),
hrduud07    number(15,3),
hrduud08    number(15,3),
hrduud09    number(15,3),
hrduud10    number(10),
hrduud11    number(10),
hrduud12    number(10),
hrduud13    date,
hrduud14    date,
hrduud15    date
);

alter table hrdu_file add  constraint hrdu_pk primary key  (hrdu01,hrdu03,hrdu05) enable validate;
grant select on hrdu_file to tiptopgp;
grant update on hrdu_file to tiptopgp;
grant delete on hrdu_file to tiptopgp;
grant insert on hrdu_file to tiptopgp;
grant index on hrdu_file to public;
grant select on hrdu_file to ods;
