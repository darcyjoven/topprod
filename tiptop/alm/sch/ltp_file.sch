/*
================================================================================
檔案代號:ltp_file
檔案名稱:收券规则单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltp_file
(
ltp01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
ltp02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltp021      number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltp03       varchar2(20),            /*券种编号                               */
ltp04       date,                    /*生效日期                               */
ltp05       date,                    /*失效日期                               */
ltp06       varchar2(1) DEFAULT ' ' NOT NULL, /*收券规则*/
ltp07       varchar2(1) DEFAULT ' ' NOT NULL, /*排除规则*/
ltp08       varchar2(1) DEFAULT ' ' NOT NULL, /*满额收券否*/
ltp09       number(20,6) DEFAULT '0' NOT NULL, /*达成金额*/
ltp10       number(20,6) DEFAULT '0' NOT NULL, /*收券金额*/
ltp11       varchar2(1) DEFAULT ' ' NOT NULL, /*发布否*/
ltp12       date,                    /*发布日期                               */
ltpacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ltpcond     date,                    /*审核日期                               */
ltpconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
ltpcont     varchar2(8),             /*审核时间                               */
ltpconu     varchar2(10),            /*审核人员                               */
ltpcrat     date,                    /*资料创建日                             */
ltpdate     date,                    /*最近更改日                             */
ltpgrup     varchar2(10),            /*资料所有群                             */
ltplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltpmodu     varchar2(10),            /*资料更改者                             */
ltporig     varchar2(10),            /*资料建立部门                           */
ltporiu     varchar2(10),            /*资料建立者                             */
ltpplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ltppos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
ltpuser     varchar2(10)             /*资料所有者                             */
);

alter table ltp_file add  constraint ltp_pk primary key  (ltp01,ltp02,ltpplant) enable validate;
grant select on ltp_file to tiptopgp;
grant update on ltp_file to tiptopgp;
grant delete on ltp_file to tiptopgp;
grant insert on ltp_file to tiptopgp;
grant index on ltp_file to public;
grant select on ltp_file to ods;
