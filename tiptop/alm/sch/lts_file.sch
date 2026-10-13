/*
================================================================================
檔案代號:lts_file
檔案名稱:收券规则变更单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lts_file
(
lts01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
lts02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lts021      number(5) DEFAULT '0' NOT NULL, /*版本号*/
lts03       varchar2(20),            /*券种编号                               */
lts04       date,                    /*生效日期                               */
lts05       date,                    /*失效日期                               */
lts06       varchar2(1) DEFAULT ' ' NOT NULL, /*收券规则*/
lts07       varchar2(1) DEFAULT ' ' NOT NULL, /*排除规则*/
lts08       varchar2(1) DEFAULT 'N' NOT NULL, /*满额收券否*/
lts09       number(20,6) DEFAULT '0' NOT NULL, /*达成金额*/
lts10       number(20,6) DEFAULT '0' NOT NULL, /*收券金额*/
lts11       varchar2(1) DEFAULT 'N' NOT NULL, /*发布否*/
lts12       date,                    /*发布日期                               */
ltsacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ltscond     date,                    /*审核日期                               */
ltsconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
ltscont     varchar2(8),             /*审核时间                               */
ltsconu     varchar2(10),            /*审核人员                               */
ltscrat     date,                    /*资料创建日                             */
ltsdate     date,                    /*最近更改日                             */
ltsgrup     varchar2(10),            /*资料所有群                             */
ltslegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltsmodu     varchar2(10),            /*资料更改者                             */
ltsorig     varchar2(10),            /*资料建立部门                           */
ltsoriu     varchar2(10),            /*资料建立者                             */
ltsplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ltsuser     varchar2(10)             /*资料所有者                             */
);

alter table lts_file add  constraint lts_pk primary key  (lts01,lts02,lts021,ltsplant) enable validate;
grant select on lts_file to tiptopgp;
grant update on lts_file to tiptopgp;
grant delete on lts_file to tiptopgp;
grant insert on lts_file to tiptopgp;
grant index on lts_file to public;
grant select on lts_file to ods;
