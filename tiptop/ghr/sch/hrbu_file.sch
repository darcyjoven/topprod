/*
================================================================================
檔案代號:hrbu_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbu_file
(
hrbu01      varchar2(50) NOT NULL,   /*型号编码                               */
hrbu02      varchar2(50),            /*型号名称                               */
hrbu03      number(5),               /*数据长度                               */
hrbu04      number(5),               /*刷卡机号起始位                         */
hrbu05      number(5),               /*刷卡机号截止位                         */
hrbu06      number(5),               /*卡号起始位                             */
hrbu07      number(5),               /*卡号截止位                             */
hrbu08      number(5),               /*年起始位                               */
hrbu09      number(5),               /*年截止位                               */
hrbu10      number(5),               /*月起始位                               */
hrbu11      number(5),               /*月截止位                               */
hrbu12      number(5),               /*日起始位                               */
hrbu13      number(5),               /*日截止位                               */
hrbu14      number(5),               /*时起始位                               */
hrbu15      number(5),               /*时截止位                               */
hrbu16      number(5),               /*分起始位                               */
hrbu17      number(5),               /*分截止位                               */
hrbu18      number(5),               /*秒起始位                               */
hrbu19      number(5),               /*秒截止位                               */
hrbu20      number(5),               /*功能键起始位                           */
hrbu21      number(5),               /*功能键截止位                           */
hrbu22      varchar2(255),           /*备注                                   */
hrbuacti    varchar2(1),             /*资料有效否                             */
hrbuud01    varchar2(255),
hrbuud02    varchar2(40),
hrbuud03    varchar2(40),
hrbuud04    varchar2(40),
hrbuud05    varchar2(40),
hrbuud06    varchar2(40),
hrbuud07    number(15,3),
hrbuud08    number(15,3),
hrbuud09    number(15,3),
hrbuud10    number(10),
hrbuud11    number(10),
hrbuud12    number(10),
hrbuud13    date,
hrbuud14    date,
hrbuud15    date,
hrbuuser    varchar2(10),
hrbugrup    varchar2(10),
hrbumodu    varchar2(10),
hrbudate    date,
hrbuorig    varchar2(10),
hrbuoriu    varchar2(10)
);

alter table hrbu_file add  constraint tpc_hrbu_pk primary key  (hrbu01) enable validate;
grant select on hrbu_file to tiptopgp;
grant update on hrbu_file to tiptopgp;
grant delete on hrbu_file to tiptopgp;
grant insert on hrbu_file to tiptopgp;
grant index on hrbu_file to public;
grant select on hrbu_file to ods;
