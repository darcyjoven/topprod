/*
================================================================================
檔案代號:hrec_file
檔案名稱:薪酬预算变动管理
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrec_file
(
hrec01      varchar2(10) NOT NULL,   /*流水编码                               */
hrec02      varchar2(20),            /*预算年度                               */
hrec03      number(15,2),            /*原年度预算总额                         */
hrec04      number(15,2),            /*现年度预算总额                         */
hrec05      date,                    /*变动日期                               */
hrec06      varchar2(20),            /*变动预算类别                           */
hrec07      varchar2(20),            /*变更期别                               */
hrec08      number(15,2),            /*追加预算金额                           */
hrec09      number(15,2),            /*消减预算金额                           */
hrecacti    varchar2(1),             /*资料有效码                             */
hrecuser    varchar2(20),            /*资料所有者                             */
hrecgrup    varchar2(20),            /*资料所有群                             */
hrecoriu    varchar2(20),            /*资料建立者                             */
hrecorig    varchar2(20),            /*资料建立部门                           */
hrecmodu    varchar2(20),            /*最近修改人                             */
hrecdate    date,                    /*最近更改日                             */
hrecud01    varchar2(255),
hrecud02    varchar2(40),
hrecud03    varchar2(40),
hrecud04    varchar2(40),
hrecud05    varchar2(40),
hrecud06    varchar2(40),
hrecud07    number(15,3),
hrecud08    number(15,3),
hrecud09    number(15,3),
hrecud10    number(5),
hrecud11    number(5),
hrecud12    number(5),
hrecud13    date,
hrecud14    date,
hrecud15    date,
hrecconf    varchar2(1)
);

alter table hrec_file add  constraint hrec_pk primary key  (hrec01) enable validate;
grant select on hrec_file to tiptopgp;
grant update on hrec_file to tiptopgp;
grant delete on hrec_file to tiptopgp;
grant insert on hrec_file to tiptopgp;
grant index on hrec_file to public;
grant select on hrec_file to ods;
